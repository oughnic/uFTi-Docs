// Turns the app team's brand artwork into the files the documentation ships. Run it by import-brand.ps1 (it
// needs Node, Playwright and opentype.js, which the pinned container has). Usage:
//   node import-brand.mjs <folder with the app's SVGs> <fonts folder> <out folder> <shipped assets folder>
// For each SVG it replaces every <text> with the outline of the same glyphs, so the file needs no font and
// still draws when it is used as an image (an SVG used as an image cannot load fonts). It also writes the
// favicon (an .ico of the 16, 32 and 48 pixel marks) and the share image (a 1200 x 630 PNG of the hero).
import { chromium } from "playwright";
import { readFileSync, writeFileSync, mkdirSync, readdirSync } from "node:fs";
import { join, basename } from "node:path";

const [src, fontDir, out, ship] = process.argv.slice(2);
if (!src || !fontDir || !out || !ship) { console.error("usage: node import-brand.mjs <svg folder> <fonts folder> <out folder> <shipped folder>"); process.exit(2); }
mkdirSync(out, { recursive: true }); mkdirSync(ship, { recursive: true });

const fonts = {
  "Source Serif 4|600": "SourceSerif4-Semibold.ttf", "Source Serif 4|400": "SourceSerif4-Regular.ttf",
  "Atkinson|400": "AtkinsonHyperlegibleNext-Regular.ttf", "Atkinson|700": "AtkinsonHyperlegibleNext-Bold.ttf",
};
const fontData = Object.fromEntries(Object.entries(fonts).map(([k, f]) => [k, readFileSync(join(fontDir, f)).toString("base64")]));

const browser = await chromium.launch();
const page = await browser.newPage();
await page.setContent("<!doctype html><body></body>");
await page.addScriptTag({ path: "/tmp/node_modules/opentype.js/dist/opentype.js" });

async function outline(svg) {
  return page.evaluate(({ svg, fontData }) => {
    const b64 = (s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0)).buffer;
    const loaded = {};
    const doc = new DOMParser().parseFromString(svg, "image/svg+xml");
    const root = doc.documentElement;
    // Computed style needs the element in a live document, so mount a copy.
    const host = document.body.appendChild(document.createElement("div"));
    host.innerHTML = svg;
    const live = [...host.querySelectorAll("text")];
    const own = [...doc.querySelectorAll("text")];
    own.forEach((t, i) => {
      const cs = getComputedStyle(live[i]);
      const family = cs.fontFamily.split(",")[0].replace(/["']/g, "").trim();
      const w = Number(cs.fontWeight);
      const weight = family === "Atkinson" ? (w >= 700 ? 700 : 400) : (w >= 600 ? 600 : 400);
      const key = `${family}|${weight}`;
      if (!fontData[key]) throw new Error(`no font for ${key}`);
      loaded[key] ??= opentype.parse(b64(fontData[key]));
      const size = parseFloat(cs.fontSize);
      const ls = cs.letterSpacing === "normal" ? 0 : parseFloat(cs.letterSpacing);
      const x = parseFloat(t.getAttribute("x") || "0"), y = parseFloat(t.getAttribute("y") || "0");
      const text = t.textContent;
      const font = loaded[key];
      let width = 0; font.forEachGlyph(text, 0, 0, size, { letterSpacing: ls / size }, (g, gx, gy, fs) => { width = gx + (g.advanceWidth / font.unitsPerEm) * fs; });
      const anchor = cs.textAnchor;
      const x0 = anchor === "middle" ? x - width / 2 : anchor === "end" ? x - width : x;
      const path = font.getPath(text, x0, y, size, { letterSpacing: ls / size });
      const p = doc.createElementNS("http://www.w3.org/2000/svg", "path");
      p.setAttribute("d", path.toPathData(2));
      p.setAttribute("fill", t.getAttribute("fill") || cs.fill);
      if (t.getAttribute("opacity")) p.setAttribute("opacity", t.getAttribute("opacity"));
      t.replaceWith(p);
    });
    doc.querySelectorAll("style").forEach((s) => s.remove());
    return new XMLSerializer().serializeToString(root);
  }, { svg, fontData });
}

const names = readdirSync(src).filter((f) => f.endsWith(".svg"));
for (const f of names) {
  const text = readFileSync(join(src, f), "utf8");
  const done = text.includes("<text") ? await outline(text) : text;
  if (done.includes("<text") || done.includes("@font-face") || done.includes("../../")) throw new Error(`${f} still refers to text or a font`);
  writeFileSync(join(out, f), done);
  console.log(`  ${f}: ${(text.match(/<text/g) || []).length} text element(s) outlined`);
}

// Pixel renders for the favicon, and the share image from the hero.
async function png(file, w, h, clip, scale = 1) {
  const p = await browser.newPage({ viewport: { width: w, height: h }, deviceScaleFactor: scale });
  await p.goto("file://" + join(out, file));
  const buf = await p.screenshot(clip ? { clip } : {});
  await p.close();
  return buf;
}
const sizes = [16, 32, 48];
const images = [];
for (const s of sizes) images.push(await png(`ufti-sampler-${s}.svg`, s, s));
const header = Buffer.alloc(6); header.writeUInt16LE(0, 0); header.writeUInt16LE(1, 2); header.writeUInt16LE(images.length, 4);
let offset = 6 + 16 * images.length;
const dir = images.map((img, i) => { const e = Buffer.alloc(16); e[0] = sizes[i]; e[1] = sizes[i]; e.writeUInt16LE(1, 4); e.writeUInt16LE(32, 6); e.writeUInt32LE(img.length, 8); e.writeUInt32LE(offset, 12); offset += img.length; return e; });
writeFileSync(join(ship, "ufti.ico"), Buffer.concat([header, ...dir, ...images]));
writeFileSync(join(ship, "ufti-share.png"), await png("ufti-hero.svg", 1920, 1080, { x: 0, y: 35, width: 1920, height: 1008 }, 0.625));
writeFileSync(join(ship, "ufti-mark.svg"), readFileSync(join(out, "ufti-sampler.svg")));
writeFileSync(join(ship, "ufti-mark-small.svg"), readFileSync(join(out, "ufti-sampler-32.svg")));
await browser.close();
console.log("  wrote ufti.ico, ufti-share.png, ufti-mark.svg, ufti-mark-small.svg");
