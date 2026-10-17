// Proves the publisher theme on a real built site, in a real browser: the stylesheet is linked
// and loads, every face the theme names loads from the site's own files, headings use the
// Semibold display face, body text uses the text face, and a figure never outgrows 40 rem.
//
// The site is served over HTTP from a local port, as it is published, because Chromium blocks
// web fonts on file:// pages. Runs with the Playwright the plugin's accessibility runner already
// installs, so copy this file beside tools/a11y/run.mjs (check-output.ps1 does) and run:
//
//   node theme-probe.mjs <site folder> [page.html ...]
//
// Pages default to index.html and every topic page that holds a figure. Exits 1 on any failure.
// Copyright 2026 Oughtibridge Ltd, Apache-2.0.
import { chromium } from "playwright";
import { createServer } from "node:http";
import { createReadStream, existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { extname, join, normalize, relative, resolve, sep } from "node:path";

const [site, ...wanted] = process.argv.slice(2);
if (!site) { console.error("usage: node theme-probe.mjs <site folder> [page.html ...]"); process.exit(2); }
const root = resolve(site);

function htmlUnder(dir) {
  return readdirSync(dir).flatMap((name) => {
    const p = join(dir, name);
    return statSync(p).isDirectory() ? htmlUnder(p) : p.endsWith(".html") ? [p] : [];
  });
}
let pages = wanted.length ? wanted.map((p) => join(root, p)) : [join(root, "index.html"), ...htmlUnder(root).filter((p) => /<figure|<img /.test(readFileSync(p, "utf8")) && !/print[^/\\]*\.html$/.test(p))];
pages = [...new Set(pages)];

// A static server for the site folder, on a port the system picks.
const types = { ".html": "text/html; charset=utf-8", ".css": "text/css", ".js": "text/javascript", ".mjs": "text/javascript", ".json": "application/json", ".svg": "image/svg+xml", ".png": "image/png", ".jpg": "image/jpeg", ".ico": "image/x-icon", ".ttf": "font/ttf", ".woff": "font/woff", ".woff2": "font/woff2", ".pdf": "application/pdf", ".txt": "text/plain", ".xml": "application/xml", ".wasm": "application/wasm" };
const server = createServer((req, res) => {
  const path = decodeURIComponent(new URL(req.url, "http://x").pathname);
  const file = normalize(join(root, path.endsWith("/") ? path + "index.html" : path));
  if (!file.startsWith(root + sep) || !existsSync(file) || statSync(file).isDirectory()) { res.writeHead(404); res.end(); return; }
  res.writeHead(200, { "content-type": types[extname(file).toLowerCase()] ?? "application/octet-stream" });
  createReadStream(file).pipe(res);
});
await new Promise((ok) => server.listen(0, "127.0.0.1", ok));
const base = `http://127.0.0.1:${server.address().port}/`;

const expectFaces = [
  ["Atkinson Hyperlegible Next", "400", "normal"],
  ["Atkinson Hyperlegible Next", "700", "normal"],
  ["Source Serif 4", "600", "normal"],
];

const failures = [];
const browser = await chromium.launch();
const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
for (const file of pages) {
  const page = await context.newPage();
  const failed = [];
  page.on("requestfailed", (r) => failed.push(r.url()));
  page.on("response", (r) => { if (r.status() >= 400) failed.push(`${r.status()} ${r.url()}`); });
  page.on("console", (m) => { if (m.type() === "error") failed.push("console: " + m.text()); });
  const rel = relative(root, file).split(sep).join("/");
  await page.goto(base + rel, { waitUntil: "load" });
  const report = await page.evaluate(async (faces) => {
    await document.fonts.ready;
    const sheet = [...document.styleSheets].find((s) => s.href && s.href.endsWith("/theme/ufti.css"));
    let rules = 0; try { rules = sheet ? sheet.cssRules.length : 0; } catch { rules = -1; }
    const loaded = [...document.fonts].filter((f) => f.status === "loaded").map((f) => [f.family.replace(/^"|"$/g, ""), f.weight, f.style]);
    const styleOf = (sel) => { const e = document.querySelector(sel); if (!e) return null; const c = getComputedStyle(e); return { family: c.fontFamily, weight: c.fontWeight }; };
    const used = (fam, w) => faces.some(([f, fw]) => f === fam && fw === w) && !loaded.some(([lf, lw]) => lf === fam && lw === w);
    const figures = [...document.querySelectorAll("figure img, .fig img, figure svg")].map((e) => ({ h: e.getBoundingClientRect().height, w: e.getBoundingClientRect().width, alt: e.getAttribute("alt") ?? (e.querySelector("title")?.textContent || e.getAttribute("aria-label")) }));
    return { sheet: !!sheet, rules, loaded, missingBody: used("Atkinson Hyperlegible Next", "400"), missingHeading: used("Source Serif 4", "600"), h1: styleOf("h1"), p: styleOf("main p, #main-content p, p"), figures, fontCheck: document.fonts.check('600 16px "Source Serif 4"') };
  }, expectFaces);
  const problems = [];
  if (!report.sheet) problems.push("theme/ufti.css is not linked");
  else if (report.rules === 0) problems.push("theme/ufti.css is linked but empty or not loaded");
  if (report.missingBody) problems.push("Atkinson Hyperlegible Next 400 did not load");
  if (report.h1 && report.missingHeading) problems.push("Source Serif 4 600 did not load");
  if (!report.fontCheck) problems.push('document.fonts.check(\'600 16px "Source Serif 4"\') is false');
  if (report.h1 && !/Source Serif 4/.test(report.h1.family)) problems.push(`h1 is ${report.h1.family}, not Source Serif 4`);
  if (report.h1 && report.h1.weight !== "600") problems.push(`h1 weight is ${report.h1.weight}, not 600`);
  if (report.p && !/Atkinson Hyperlegible Next/.test(report.p.family)) problems.push(`body text is ${report.p.family}, not Atkinson Hyperlegible Next`);
  for (const f of report.figures) {
    if (f.h > 40 * 16 + 1) problems.push(`a figure is ${Math.round(f.h)} px tall, over 40 rem`);
    if (!f.alt) problems.push("a figure has no alternative text");
  }
  for (const u of failed) problems.push("failed to load: " + u);
  const faces = report.loaded.map((l) => l.join(" ")).join(", ");
  console.log(`${problems.length ? "✗" : "✓"} ${rel}: faces loaded [${faces}], h1 ${report.h1 ? report.h1.family.split(",")[0] + " " + report.h1.weight : "none"}, ${report.figures.length} figure(s)` + (report.figures.length ? " up to " + Math.round(Math.max(...report.figures.map((f) => f.h))) + " px" : ""));
  for (const p of problems) { console.log("    " + p); failures.push(`${rel}: ${p}`); }
  await page.close();
}
await browser.close();
server.close();
console.log(failures.length ? `FAIL: ${failures.length} theme problem(s) on ${pages.length} page(s)` : `PASS: the theme holds on ${pages.length} page(s)`);
process.exit(failures.length ? 1 : 0);
