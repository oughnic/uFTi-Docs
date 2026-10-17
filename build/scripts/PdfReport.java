// Reports what a built PDF embeds and shows, and fails when it falls short of the plan.
//
// Run with DesignSystemPDF's own PDFBox on the class path (Java 17 or later runs a single source
// file directly):
//
//   java -cp ".tools/designsystempdf-0.1.2/lib/*" build/scripts/PdfReport.java out/x/y.pdf [--require-font NAME]...
//
// It prints the page count and size, every font with whether it is embedded, and every image with
// the size it is drawn at. It exits 1 when a font is not embedded (PDF/UA needs every font
// embedded), when a required font name is absent (the theme's faces must be used, not the
// generator's bundled fallback), or when an image is drawn larger than the page's content area.
//
// Copyright 2026 Oughtibridge Ltd, Apache-2.0.
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.contentstream.PDFStreamEngine;
import org.apache.pdfbox.contentstream.operator.Operator;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.util.Matrix;

public class PdfReport {
    static final double PT_PER_MM = 72.0 / 25.4;

    public static void main(String[] args) throws IOException {
        if (args.length < 1) { System.err.println("usage: PdfReport <file.pdf> [--require-font NAME]... [--max-image-height-mm N]"); System.exit(2); }
        List<String> required = new ArrayList<>();
        double maxImageHeightMm = 0; // 0: only the page itself limits an image
        for (int i = 1; i < args.length; i++) {
            if (args[i].equals("--require-font") && i + 1 < args.length) required.add(args[++i]);
            else if (args[i].equals("--max-image-height-mm") && i + 1 < args.length) maxImageHeightMm = Double.parseDouble(args[++i]);
        }
        List<String> failures = new ArrayList<>();
        File file = new File(args[0]);
        try (PDDocument doc = Loader.loadPDF(file)) {
            int pages = doc.getNumberOfPages();
            PDPage first = doc.getPage(0);
            double w = first.getMediaBox().getWidth() / PT_PER_MM, h = first.getMediaBox().getHeight() / PT_PER_MM;
            System.out.printf("%s: %d page(s), %.0f x %.0f mm, tagged=%s, %,d bytes%n", file.getName(), pages, w, h,
                doc.getDocumentCatalog().getStructureTreeRoot() != null, file.length());
            if (doc.getDocumentCatalog().getStructureTreeRoot() == null) failures.add("no structure tree: the PDF is not tagged");

            // Fonts: every resource dictionary on every page, and inside form XObjects.
            Map<String, Boolean> fonts = new TreeMap<>();
            for (PDPage page : doc.getPages()) collectFonts(page.getResources(), fonts, 0);
            System.out.println("fonts:");
            for (Map.Entry<String, Boolean> e : fonts.entrySet()) {
                System.out.printf("  %-45s %s%n", e.getKey(), e.getValue() ? "embedded" : "NOT EMBEDDED");
                if (!e.getValue()) failures.add("font not embedded: " + e.getKey());
            }
            for (String want : required) {
                boolean found = false;
                for (String name : fonts.keySet()) if (name.contains(want)) found = true;
                if (!found) failures.add("required font not used: " + want);
            }

            // Images: where each is drawn, and how large.
            System.out.println("images:");
            int n = 0;
            for (int i = 0; i < pages; i++) {
                PDPage page = doc.getPage(i);
                ImageFinder finder = new ImageFinder();
                finder.processPage(page);
                double pageW = page.getMediaBox().getWidth(), pageH = page.getMediaBox().getHeight();
                for (double[] img : finder.found) {
                    n++;
                    double iw = img[0] / PT_PER_MM, ih = img[1] / PT_PER_MM;
                    boolean fits = img[0] <= pageW + 0.5 && img[1] <= pageH + 0.5;
                    boolean withinCap = maxImageHeightMm <= 0 || ih <= maxImageHeightMm + 1;
                    System.out.printf("  page %d: %.0f x %.0f mm (%d x %d px)%s%s%n", i + 1, iw, ih, (int) img[2], (int) img[3], fits ? "" : "  LARGER THAN THE PAGE", withinCap ? "" : "  TALLER THAN THE CAP");
                    if (!fits) failures.add(String.format("an image on page %d is drawn at %.0f x %.0f mm, larger than the page", i + 1, iw, ih));
                    if (!withinCap) failures.add(String.format("an image on page %d is %.0f mm tall, over the %.0f mm cap the theme sets for figures", i + 1, ih, maxImageHeightMm));
                }
            }
            if (n == 0) System.out.println("  (none)");
        }
        if (failures.isEmpty()) { System.out.println("PASS: every font is embedded and every image fits its page."); return; }
        for (String f : failures) System.out.println("FAIL: " + f);
        System.exit(1);
    }

    static void collectFonts(PDResources res, Map<String, Boolean> fonts, int depth) throws IOException {
        if (res == null || depth > 8) return;
        for (COSName name : res.getFontNames()) {
            PDFont font = res.getFont(name);
            if (font == null) continue;
            String key = font.getName() + " (" + font.getSubType() + ")";
            fonts.merge(key, font.isEmbedded(), (a, b) -> a && b);
        }
        for (COSName name : res.getXObjectNames()) {
            PDXObject x = res.getXObject(name);
            if (x instanceof PDFormXObject) collectFonts(((PDFormXObject) x).getResources(), fonts, depth + 1);
        }
    }

    // The displayed size of each image: the current transformation matrix when "Do" draws it.
    // The base engine registers no operators, so the ones that move the matrix are added here.
    static class ImageFinder extends PDFStreamEngine {
        final List<double[]> found = new ArrayList<>();
        ImageFinder() {
            addOperator(new org.apache.pdfbox.contentstream.operator.state.Concatenate(this));
            addOperator(new org.apache.pdfbox.contentstream.operator.state.Save(this));
            addOperator(new org.apache.pdfbox.contentstream.operator.state.Restore(this));
            addOperator(new org.apache.pdfbox.contentstream.operator.state.SetMatrix(this));
            addOperator(new org.apache.pdfbox.contentstream.operator.state.SetGraphicsStateParameters(this));
        }
        @Override
        protected void processOperator(Operator operator, List<COSBase> operands) throws IOException {
            if ("Do".equals(operator.getName()) && !operands.isEmpty() && operands.get(0) instanceof COSName) {
                COSName name = (COSName) operands.get(0);
                PDXObject x = getResources().getXObject(name);
                if (x instanceof PDImageXObject) {
                    PDImageXObject img = (PDImageXObject) x;
                    Matrix ctm = getGraphicsState().getCurrentTransformationMatrix();
                    found.add(new double[] { Math.abs(ctm.getScalingFactorX()), Math.abs(ctm.getScalingFactorY()), img.getWidth(), img.getHeight() });
                    return;
                }
                if (x instanceof PDFormXObject) { showForm((PDFormXObject) x); return; }
            }
            super.processOperator(operator, operands);
        }
    }
}
