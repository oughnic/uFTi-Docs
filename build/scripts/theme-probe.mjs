// Proves the publisher theme on a real built site, in a real browser: the stylesheet is linked
// and loads, every face the theme names loads from the site's own files, headings use the
// Semibold display face, body text uses the text face, and a figure never outgrows 40 rem.
//
// Runs with the Playwright the plugin's accessibility runner already installs, so copy or link
// this file beside tools/a11y/run.mjs (check-output.ps1 does) and run:
//
//   node theme-probe.mjs <site folder> [page.html ...]
//
// Pages default to index.html and every topic page that holds a figure. Exits 1 on any failure.
// Copyright 2026 Oughtibridge Ltd, Apache-2.0.
import { chromium } from "playwright";
import { pathToFileURL } from "node:url";
import { readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const [site, ...wanted] = process.argv.slice(2);
if (!site) { console.error("usage: node theme-probe.mjs <site folder> [page.html ...]"); process.exit(2); }

function htmlUnder(dir) {
  return readdirSync(dir).flatMap((name) => {
    const p = join(dir, name);
    return statSync(p).isDirectory() ? htmlUnder(p) : p.endsWith(".html") ? [p] : [];
  });
}
let pages = wanted.length ? wanted.map((p) => join(site, p)) : [join(site, "index.html"), ...htmlUnder(site).filter((p) => /<figure|<img /.test(readFileSync(p, "utf8")) && !/print[^/]*\.html$/.test(p))];
pages = [...new Set(pages)];

const expectFaces = [
  ["Atkinson Hyperlegible Next", "400", "normal"],
  ["Atkinson Hyperlegible Next", "700", "normal"],
  ["Atkinson Hyperlegible Next", "400", "italic"],
  ["Source Serif 4", "400", "normal"],
  ["Source Serif 4", "400", "italic"],
  ["Source Serif 4", "600", "normal"],
  ["Source Serif 4 Semibold", "600", "normal"],
];

const failures = [];
const browser = await chromium.launch();
const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
for (const file of pages) {
  const page = await context.newPage();
  const failed = [];
  page.on("requestfailed", (r) => failed.push(r.url()));
  page.on("console", (m) => { if (m.type() === "error") failed.push("console: " + m.text()); });
  await page.goto(pathToFileURL(file).href, { waitUntil: "load" });
  const report = await page.evaluate(async (faces) => {
    await document.fonts.ready;
    const sheet = [...document.styleSheets].find((s) => s.href && s.href.endsWith("/theme/ufti.css"));
    let rules = 0; try { rules = sheet ? sheet.cssRules.length : 0; } catch { rules = -1; }
    const loaded = [...document.fonts].filter((f) => f.status === "loaded").map((f) => [f.family.replace(/^"|"$/g, ""), f.weight, f.style]);
    const missing = faces.filter(([fam, w, st]) => !loaded.some(([lf, lw, ls]) => lf === fam && lw === w && ls === st));
    const styleOf = (sel) => { const e = document.querySelector(sel); if (!e) return null; const c = getComputedStyle(e); return { family: c.fontFamily, weight: c.fontWeight }; };
    const figures = [...document.querySelectorAll("figure img, .fig img, figure svg")].map((e) => ({ h: e.getBoundingClientRect().height, w: e.getBoundingClientRect().width, alt: e.getAttribute("alt") ?? e.getAttribute("aria-label") }));
    return { sheet: !!sheet, rules, loadedCount: loaded.length, missing, h1: styleOf("h1"), p: styleOf("main p, #main-content p, p"), masthead: styleOf(".app-masthead__title"), figures, fontCheck: document.fonts.check('600 16px "Source Serif 4"') };
  }, expectFaces);
  const rel = relative(site, file);
  const problems = [];
  if (!report.sheet) problems.push("theme/ufti.css is not linked");
  else if (report.rules === 0) problems.push("theme/ufti.css is linked but empty or not loaded");
  if (report.missing.length) problems.push("faces not loaded: " + report.missing.map((m) => m.join(" ")).join(", "));
  if (!report.fontCheck) problems.push('document.fonts.check(\'600 16px "Source Serif 4"\') is false');
  if (report.h1 && !/Source Serif 4/.test(report.h1.family)) problems.push(`h1 is ${report.h1.family}, not Source Serif 4`);
  if (report.h1 && report.h1.weight !== "600") problems.push(`h1 weight is ${report.h1.weight}, not 600`);
  if (report.p && !/Atkinson Hyperlegible Next/.test(report.p.family)) problems.push(`body text is ${report.p.family}, not Atkinson Hyperlegible Next`);
  for (const f of report.figures) {
    if (f.h > 40 * 16 + 1) problems.push(`a figure is ${Math.round(f.h)} px tall, over 40 rem`);
    if (f.alt === null || f.alt === "") problems.push("a figure has no alternative text");
  }
  for (const u of failed) problems.push("failed to load: " + u);
  console.log(`${problems.length ? "✗" : "✓"} ${rel}: ${report.loadedCount} face(s) loaded, h1 ${report.h1 ? report.h1.family.split(",")[0] + " " + report.h1.weight : "none"}, ${report.figures.length} figure(s)` + (report.figures.length ? " up to " + Math.round(Math.max(...report.figures.map((f) => f.h))) + " px" : ""));
  for (const p of problems) { console.log("    " + p); failures.push(`${rel}: ${p}`); }
  await page.close();
}
await browser.close();
console.log(failures.length ? `FAIL: ${failures.length} theme problem(s) on ${pages.length} page(s)` : `PASS: the theme holds on ${pages.length} page(s)`);
process.exit(failures.length ? 1 : 0);
