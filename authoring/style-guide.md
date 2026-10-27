# Style guide

How the uFTi documentation sounds: the words, the sentences and the reading level, and how each rule is checked.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 18 October 2026. Written for WP3 ([issue 9](https://github.com/oughnic/uFTi-Docs/issues/9)). Decisions: DEC-070, DEC-071, DEC-078 and DEC-079 in the [decision log](decision-log.md), after DEC-010 and DEC-029. Nothing here is final until its decision is marked *Accepted*.

This guide is about **words**. How the DITA is built (structure, naming, markup, metadata) is in the [authoring standards](authoring-standards.md). The plain word for each label and term is in the [terminology list](terminology.md). The values for metadata are in the [metadata vocabulary](metadata-vocabulary.md). Start a new topic from a [template](../content/templates/README.md).

## 1. Who we write for

We write for an average 11-year-old (DEC-029). That is not because our readers are children. It is because plain words help everyone, and most of our readers do not read manuals at all ([content model](content-model.md)). So:

- **The words on screen come first,** then the Quick Start, then the manual. A topic that only works if the reader has read another one has failed.
- **Never make the reader feel slow.** If a step is easy to get wrong, say so and say how to put it right. Never blame the reader.
- **The base is the [GOV.UK style guide](https://www.gov.uk/guidance/style-guide)** and its content design principles (DEC-010). This guide records where we do something different or more exact.
- **British English.** Spelling follows the SCOWL `en_GB-ise` dictionary, so *-ise* endings (organise) and *colour*, *licence* (noun) and *practise* (verb).
- **Examples lean to the United Kingdom** (DEC-078). The worked example is the Brontë family of Yorkshire, and records are British ones unless a topic is about somewhere else.

## 2. How each rule is checked

A rule nobody checks drifts. Each rule in this guide and the standards says who checks it. **Every rule that a machine checks has a test that makes it fail** ([`test-source-rules.ps1`](../build/scripts/test-source-rules.ps1)), so we know it can.

| Kind | Check | Where it runs |
|---|---|---|
| Reading level and sentence length | Vale `uFTi.ReadingEase`, `uFTi.GradeLevel`, `uFTi.AverageSentence` and `uFTi.LongSentence` | `check-source.ps1`, CI `lint` job |
| Spelling | Vale `uFTi.Spelling` (British dictionary, plus the vocabulary) | the same |
| Words and phrases | Vale `uFTi.Avoid`, `uFTi.NeutralVerbs`, `uFTi.Positional`, `uFTi.PlainWords`, `uFTi.Terminology`, `uFTi.ProductName`, `uFTi.Dates`, `uFTi.ColourCues`, `uFTi.PositionCues` | the same |
| What must not be said | Vale `uFTi.BusinessModel` (DEC-040), `uFTi.GedcomTags` (DEC-030) | the same |
| Structure, metadata, keys, pictures, diagrams | [`lint.ps1`](../build/scripts/lint.ps1) | the same |
| Sense, tone, accuracy | A person: the reviewers in the [plan, section 7.1](authoring-plan.md#71-roles), using the checklist in section 11 | The pull request |

An **error** fails the build. A **warning** is advice: the topic still passes, and the author reads it and decides. Vale's `MinAlertLevel` shows both.

## 3. Reading level

### 3.1 The targets

Per topic (DEC-029, kept after measuring: see section 3.4):

| Measure | Target | Vale rule | Level |
|---|---|---|---|
| Flesch reading ease | 70 or more | `uFTi.ReadingEase` | error |
| Flesch-Kincaid grade | 6 or less | `uFTi.GradeLevel` | error |
| Average sentence | 15 words or fewer | `uFTi.AverageSentence` | error |
| Longest sentence | 25 words or fewer | `uFTi.LongSentence` | error |

Only the two Flesch measures are used. The other scores in the vendored Readability package (Gunning fog, SMOG, Coleman-Liau, LIX, automated readability, polysyllable count) say the same thing in other numbers and would disagree with each other. The package is not switched on at all: its two Flesch rules print "above 70" and "below 8" in their message whatever threshold a project sets, so `uFTi.ReadingEase` and `uFTi.GradeLevel` restate them with the same formulas and the right words (DEC-071).

### 3.2 What Vale measures (DEC-048)

- **Vale reads the source file you wrote.** It converts each `.dita` file to HTML with the toolkit's stock html5 transformation and measures the text. So the measure is of the words an author writes, in the file they wrote them in, before any build.
- **It sees one topic at a time.** A word that comes from a key (`<uicontrol keyref="ui-save"/>`, `<keyword keyref="product-name"/>`) is not in the topic, so it is **not in the count**. That is why a label never harms the score, and why a label must never be typed inline (DEC-090).
- **What it counts.** The short description, every paragraph, step, list item and table cell. A list item is a sentence of its own, with or without a full stop. **Titles and headings are not counted.**
- **The formulas.** Reading ease is `206.835 − 1.015 × (words ÷ sentences) − 84.6 × (syllables ÷ words)`. Grade is `0.39 × (words ÷ sentences) + 11.8 × (syllables ÷ words) − 15.59`. Vale counts syllables itself.
- **Exceptions.** DEC-029 allows a topic to be over the line only where every exception is a UI label, a proper name or a term with a glossary entry. A UI label is already outside the count when it comes from a key. A name or a glossary term that pushes a topic over is recorded, not hidden: add a section for the one file to `.vale.ini`, set only the threshold that needs to move, and put the reason and the day in a comment above it. The pull request says why. There are none yet.

### 3.3 Short topics and long ones

Both scores are unreliable on very short text. A glossary entry of one sentence is on the line the moment it has 16 words. So a glossary definition is one or two short sentences, and a one-sentence definition stays at 15 words or fewer. The measures are also kinder to steps than to explanations, because a step is an order of five or six short words. Expect a concept to score well below a task. That is what the thresholds are for.

### 3.4 What the Quick Start scores, and why the targets did not move

Measured on 18 October 2026 on every topic in `content/`, with the rules as in `.vale.ini` before WP3 changed anything. Words, sentences and averages are as Vale counts them.

| Topic | Words | Sentences | Average sentence | Reading ease | Grade |
|---|---|---|---|---|---|
| `glossary/fact` | 15 | 1 | 15.0 | 78.8 | 6.0 |
| `glossary/pedigree` | 18 | 2 | 9.0 | 80.2 | 4.3 |
| `glossary/source` | 20 | 2 | 10.0 | 86.7 | 3.6 |
| `glossary/workspace` | 17 | 2 | 8.5 | 93.7 | 2.3 |
| `platforms/android/topics/get-ufti` | 40 | 8 | 5.0 | 91.8 | 1.7 |
| `platforms/android/topics/keep-it-safe` | 109 | 15 | 7.3 | 100.9 | 1.0 |
| `platforms/desktop/topics/add-your-first-person` | 83 | 16 | 5.2 | 101.7 | 0.4 |
| `platforms/desktop/topics/look-around` | 98 | 17 | 5.8 | 100.0 | 0.8 |
| `platforms/phone/topics/add-your-first-person` | 117 | 22 | 5.3 | 103.1 | 0.2 |
| `platforms/phone/topics/look-around` | 119 | 18 | 6.6 | 99.9 | 1.0 |
| `platforms/windows/topics/get-ufti` | 57 | 10 | 5.7 | 85.3 | 2.8 |
| `platforms/windows/topics/keep-it-safe` | 88 | 12 | 7.3 | 96.5 | 1.6 |
| `topics/quick-start/five-things-to-know` | 168 | 21 | 8.0 | 93.5 | 2.2 |
| `topics/quick-start/quick-start` | 34 | 4 | 8.5 | 91.2 | 2.6 |
| `topics/quick-start/say-where-you-found-it` | 116 | 17 | 6.8 | 101.5 | 0.8 |
| `topics/quick-start/what-next` | 50 | 8 | 6.2 | 105.7 | 0.1 |

Across the sixteen: reading ease 78.8 to 105.7 (mean 94.4), grade 0.1 to 6.0 (mean 2.0), average sentence 5.0 to 15.0 (mean 7.5), and the longest sentence 21 words. Every topic passes with room to spare, except the one-sentence glossary entry for *fact*, which sits on both lines at once (15.0 words, grade 6.0).

**Decision (DEC-071): the targets stay as DEC-029 set them.** No topic needs a lower bar, and a tighter one would fail a good glossary entry for no gain. Quick Start pages are all steps, so they say little about the explanations to come. The first concepts and reference topics are the real test. The thresholds move, with a recorded reason, only when a good topic written to this guide fails them. Until then, if a topic fails, rewrite the topic.

### 3.5 When a topic fails

1. Cut each sentence in two at the first *and*, *but*, *so* or *because* that joins two ideas.
2. Swap a long word for a plain one (section 5.2). The advice rules `uFTi.PlainWords` and `uFTi.Terminology` already point at some.
3. Move a hard word out of the sentence: explain it once, in a sentence of its own, and link its glossary entry.
4. Split the topic if it has more than one purpose.

Other languages measure differently. English measures do not apply to Spanish, which has its own (WP16).

## 4. Sentences

- **One idea in each sentence,** in the order it happens. Put the thing the reader needs first: "In **Title**, type where you know this from", not "Where you know this from should be typed in **Title**".
- **Second person, active voice, present tense.** "You choose **Save**", not "**Save** is chosen". A step is an order: "Choose **Save**."
- **Steps.** One action in each, 25 words or fewer, nine steps at most. After it, say what the reader will see: "A screen named **Sources** opens." Put detail the reader needs in `info`, after the step. Never put an explanation of an idea inside a step.
- **Tasks answer the question first.** The title and the first sentence say what the reader will be able to do. Steps come before any background.
- **Prefer a list to a long sentence,** and a table to a list of pairs. A list item is a short sentence of its own.
- **Do not hedge.** Say what happens. Where the app does not do it yet, say nothing about it (DEC-084, DEC-092).
- **No contractions** in steps. They are fine in a friendly aside, but a topic that avoids them is simpler to translate and to read aloud.
- **Questions** are fine in a heading or a checklist. Avoid them in a step.

## 5. Words

### 5.1 Rules

- **One word for one idea.** The [terminology list](terminology.md) says which. Do not use a second word for variety: a reader will think it is a second thing.
- **Plain words.** Words of one or two syllables first. Use a longer word when it is the label on screen or the word a reader already knows.
- **Explain a hard word once,** where the reader first meets it, in plain words, and link its glossary entry with `<term keyref="term-..."/>`. Every term in the glossary has a definition an 11-year-old can read.
- **No jargon without a reason.** If you cannot explain a word in the topic, the topic is too hard. Expand an abbreviation the first time, or link it.
- **Never show a file tag, a structure or a line of a file** (DEC-030). Say what the thing is for: "a family tree file", "a person", "a fact". Vale `uFTi.GedcomTags`.
- **Never state price, "free", "forever", accounts, sign-in or where data are kept** (DEC-040). Vale `uFTi.BusinessModel`.
- **Avoid** *simply*, *just*, *easy*, *obviously*, *please*, *via*, *e.g.*, *i.e.* and *etc.* They tell a reader who is stuck that they should not be. Vale `uFTi.Avoid`.
- **Verbs that work for touch and for a pointer:** *choose*, *select*, *open*, *enter*, *type*. Use *click*, *tap* and *press* only in text for one kind of device (Vale `uFTi.NeutralVerbs`, a warning).
- **Name the control, not its colour or its place** (Vale `uFTi.ColourCues`, an error, and `uFTi.PositionCues`, a warning). Say "choose **Delete**", not "choose the red button on the right". Position changes with the screen and a screen reader does not give it. Say where a control is only when its name alone would not find it, as for the **+** button.
- **The product is written uFTi,** with that capital pattern, in every sentence and every heading (Vale `uFTi.ProductName`). In text, use `<keyword keyref="product-name"/>` so the name changes in one place.

### 5.2 Plain words

The advice rule `uFTi.PlainWords` warns on the left column. The full list is in the [terminology list, section 4](terminology.md#4-plain-words-for-plain-words).

| Say | Not |
|---|---|
| use | utilise |
| start | commence |
| before | prior to |
| to | in order to |
| make sure | ensure |
| about | approximately, regarding |
| help | assist |
| find | locate |
| enough | sufficient |
| show | indicate |

### 5.3 Labels (DEC-090)

- A label is printed **exactly as the app prints it,** with its capitals, its dots and its jargon, and it always comes from a key: `<uicontrol keyref="ui-save"/>`. Use `wintitle` for the title of a box or window, with a key too. The lint fails on a label typed inline.
- A label is jargon the reader did not choose. Use it, and explain it once in a plain sentence: "The menu item *Family* opens the tree, which the screen calls a *pedigree*."
- A label that is wrong or hard is a note for the app team, not a reason to write something else. The list of changes asked is in the terminology list.
- Do not tell the reader to look for a label that is not on screen.

## 6. Numbers, dates and names

- **Dates** are written 1 January 2026, as GOV.UK does. No *1st*, no *January 1*, no *1/1/26*, no *2026-01-01* and no abbreviated month in prose (Vale `uFTi.Dates`). A year alone, or a month and a year, is fine: "October 2026". The ISO form belongs in metadata only.
- **Times** are written the GOV.UK way: 9am, 5.30pm, midday, midnight.
- **Numbers.** Spell out one to nine in text. Use digits for 10 and over, in tables, and for anything the screen shows as a digit. Do not start a sentence with a digit.
- **Names.** *Brontë* has the diaeresis in text. In file names and keys it is `bronte`. Use the people and places of the [dataset](dataset-strategy.md) exactly as it spells them, and invent no one else. Write notes in our own words. Never copy text from a biography, an encyclopaedia or a museum page.
- **Data** is a plural word: *data are*, *the data show*, *these data* (maintainer preference, DEC-176). Say *information* or *facts* where they fit as well.
- **Real people.** Never a living person, and never real family data.

## 7. Headings, titles and layout

- **Sentence case** everywhere: "Say where you found it". Capitals only for names, the product and labels. A machine cannot check this reliably, so the reviewer does.
- **A title says what the topic is for.** A task begins with a verb. A concept is a noun phrase. A troubleshooting topic is the symptom as the reader would say it. No number, no full stop, 70 characters or fewer.
- **A short description is one sentence,** 25 words or fewer, that says what the topic is or what it lets the reader do. It never begins "This topic" and never repeats the title.
- **Bold only comes from markup.** Do not use emphasis. Rewrite the sentence so it does not need it. A real risk takes a `note type="warning"`, once in a topic.

## 8. Tone and inclusion

- **Kind and plain.** The manual helps readers do better. It does not scold, and it does not make a family look wrong.
- **Assume nothing about a family:** how many parents a person has, their gender, their partner or how they were born. Describe what the app lets the reader record.
- **Sensitive subjects** (adoption, illegitimacy, enslavement, forced migration, institutions, crime, infant death, suicide, abuse) are written factually and neutrally, with a short content note at the top where a topic may distress ([good practice strategy, section 9](good-practice-strategy.md#9-sensitive-subjects)).
- **Never blame.** "The form may have closed before the change was saved" is better than "You closed the form".

## 9. Pictures and diagrams

- **Alternative text** is one sentence about what the picture shows and why it matters. It is the key's `linktext`. It never starts "Image of" or "Screenshot of".
- **The caption** (the figure's title, if any) never repeats the alternative text. Quick Start pictures have no title (DEC-082).
- **A diagram** has a title, a description, real text and a text list of the same links ([standards, section 7](authoring-standards.md#7-images-figures-and-tables)).
- Text for a screen reader is written for hearing, not for seeing. Read the alternative text aloud.

## 10. Writing for translation

We write only British English for now (Q6), but we write so that translation can follow.

- Whole sentences, never built from fragments joined together.
- No idiom, joke or culture-specific example that does not travel.
- Names that may change by language are keys.
- Dates and numbers are never ambiguous.
- No text inside pictures.

## 11. Checklist for the plain-language reviewer

A person reads each topic once, aloud if they can, and asks:

- [ ] Could an 11-year-old say what to do after reading it once?
- [ ] Is every hard word explained once, and in the glossary?
- [ ] Does each sentence hold one idea, with the point first?
- [ ] Does every step name a control by its label, and say what the reader will see?
- [ ] Is it free of "just", "simply" and "easy", and of any blame?
- [ ] Is the title a title a reader would search for, and the short description a sentence that helps them choose?
- [ ] Is the picture's alternative text useful if the picture is not seen?
- [ ] Does it say nothing about price, accounts, where data are kept or a file's contents?
- [ ] Are the examples the Brontë family, spelt as the dataset spells them?
- [ ] Are the warnings from Vale (position cues, plain words, terms) answered, or left on purpose?
