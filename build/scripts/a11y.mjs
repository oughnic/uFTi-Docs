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
import { readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, join } from "node:path";

const args = process.argv.slice(2);
if (args.length === 0) { console.error("usage: node a11y.mjs <site folder or page> [...]"); process.exit(2); }
const here = dirname(fileURLToPath(import.meta.url));
const exceptions = JSON.parse(readFileSync(join(here, "a11y-exceptions.json"), "utf8")).exceptions ?? [];

function htmlUnder(target) {
  if (statSync(target).isDirectory()) return readdirSync(target).flatMap((name) => htmlUnder(join(target, name)));
  return target.endsWith(".html") ? [target] : [];
}
const files = args.flatMap(htmlUnder).sort();

const browser = await chromium.launch();
const context = await browser.newContext();
let failing = 0, accepted = 0;
for (const file of files) {
  const page = await context.newPage();
  await page.goto(pathToFileURL(file).href, { waitUntil: "load" });
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
