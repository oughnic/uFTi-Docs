// axe-core at WCAG 2.2 AA over every built page, with documented exceptions.
//
// The same check as the plugin repository's tools/a11y/run.mjs (the same Playwright and axe-core,
// pinned through its package-lock), plus a11y-exceptions.json beside this file: each entry names
// a rule, a CSS selector and the reason, and a violation whose every node matches an entry of
// its rule is reported as accepted instead of failing. Everything else fails. Copy this file and
// the JSON beside tools/a11y/run.mjs (check-output.ps1 does) and run:
//
//   node a11y.mjs <site folder> [more folders or pages...]
//
// Copyright 2026 Oughtibridge Ltd, Apache-2.0.
import { chromium } from "playwright";
import { AxeBuilder } from "@axe-core/playwright";
import { pathToFileURL, fileURLToPath } from "node:url";
import { readdirSync, readFileSync, statSync, existsSync, createReadStream } from "node:fs";
import { createServer } from "node:http";
import { dirname, join, relative, resolve, extname, sep } from "node:path";

const args = process.argv.slice(2);
if (args.length === 0) { console.error("usage: node a11y.mjs <site folder or page> [...]"); process.exit(2); }
const here = dirname(fileURLToPath(import.meta.url));
const exceptions = JSON.parse(readFileSync(join(here, "a11y-exceptions.json"), "utf8")).exceptions ?? [];

function htmlUnder(target) {
  if (statSync(target).isDirectory()) return readdirSync(target).flatMap((name) => htmlUnder(join(target, name)));
  return target.endsWith(".html") ? [target] : [];
}
// A folder is served over http from its own root, so a link that starts with a slash (the not-found page's
// stylesheet) resolves as it does on the site, and its Content-Security-Policy treats the page as same-origin.
// A single page is loaded from disk.
const types = { ".html": "text/html; charset=utf-8", ".css": "text/css", ".js": "text/javascript", ".json": "application/json", ".svg": "image/svg+xml", ".png": "image/png", ".woff2": "font/woff2", ".woff": "font/woff", ".ttf": "font/ttf", ".pdf": "application/pdf", ".xml": "text/xml", ".txt": "text/plain" };
async function serve(root) {
  const top = resolve(root);
  const server = createServer((req, res) => {
    let file = resolve(top, "." + decodeURIComponent(new URL(req.url, "http://localhost").pathname));
    if (file !== top && !file.startsWith(top + sep)) { res.statusCode = 403; res.end(); return; }
    if (existsSync(file) && statSync(file).isDirectory()) file = join(file, "index.html");
    if (!existsSync(file)) { res.statusCode = 404; res.end("not found"); return; }
    res.setHeader("content-type", types[extname(file)] ?? "application/octet-stream");
    createReadStream(file).pipe(res);
  });
  await new Promise((done) => server.listen(0, "127.0.0.1", done));
  return `http://127.0.0.1:${server.address().port}`;
}
const targets = [];   // { file, url }
for (const arg of args) {
  if (statSync(arg).isDirectory()) {
    const base = await serve(arg);
    for (const file of htmlUnder(arg)) targets.push({ file, url: `${base}/${relative(arg, file).split(sep).join("/")}` });
  } else if (arg.endsWith(".html")) targets.push({ file: arg, url: pathToFileURL(arg).href });
}
targets.sort((a, b) => a.file.localeCompare(b.file));
const files = targets.map((t) => t.file);

const browser = await chromium.launch();
const context = await browser.newContext();
let failing = 0, accepted = 0;
for (const { file, url } of targets) {
  const page = await context.newPage();
  await page.goto(url, { waitUntil: "load" });
  const { violations } = await new AxeBuilder({ page }).withTags(["wcag2a", "wcag2aa", "wcag21a", "wcag21aa", "wcag22aa"]).analyze();
  const lines = [];
  for (const v of violations) {
    // a node is accepted when the element its target selector names matches an exception's selector
    const candidates = exceptions.filter((e) => e.rule === v.id);
    const verdicts = await Promise.all(v.nodes.map(async (n) => {
      if (!candidates.length) return null;
      const selector = n.target.join(" ");
      return page.evaluate(([sel, exc]) => {
        const el = document.querySelector(sel);
        if (!el) return null;
        const hit = exc.find((e) => { try { return el.matches(e.selector); } catch { return false; } });
        return hit ? hit.reason : null;
      }, [selector, candidates]);
    }));
    const rejected = v.nodes.filter((_, i) => !verdicts[i]);
    if (rejected.length) {
      failing++;
      lines.push(`  [${v.impact}] ${v.id}: ${v.help}`);
      lines.push(`    ${rejected.map((n) => n.target.join(" ")).join(", ")}`);
      lines.push(`    ${v.helpUrl}`);
    }
    const ok = v.nodes.filter((_, i) => verdicts[i]);
    if (ok.length) {
      accepted++;
      lines.push(`  accepted ${v.id} on ${ok.map((n) => n.target.join(" ")).join(", ")}: ${verdicts.find(Boolean)}`);
    }
  }
  if (lines.length) { console.log(`\n${failing ? "✗" : "·"} ${file}`); lines.forEach((l) => console.log(l)); }
  await page.close();
}
await browser.close();
console.log(`\naxe checked ${files.length} page(s); ${failing} violation(s) fail, ${accepted} accepted by a documented exception`);
process.exit(failing ? 1 : 0);
