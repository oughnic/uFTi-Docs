# Templates

Starting points for every kind of topic, map and diagram. Copy one, rename it, change the words, and the topic starts out right.

These files are **never published**. They are in no map, so the build never reads them. The structure lint checks them as topics (it fails a template that breaks a rule, and it fails a template that a manual's map includes), Vale checks their prose, and `build/scripts/test-source-rules.ps1` builds each one with the toolkit to prove it is valid DITA 1.3 (DEC-073).

## Which template

| I am writing | Copy | It follows |
|---|---|---|
| A task: how to do one thing | [template-task.dita](template-task.dita) | [Standards, section 5](../../authoring/authoring-standards.md#5-topic-patterns) |
| A Quick Start page | [template-quick-start-page.dita](template-quick-start-page.dita) | [Content model, section 3](../../authoring/content-model.md#3-the-quick-start) |
| A page that differs by device idiom | [platforms/desktop/topics/template-variant.dita](platforms/desktop/topics/template-variant.dita), [platforms/phone/topics/template-variant.dita](platforms/phone/topics/template-variant.dita) and [template-variants.ditamap](template-variants.ditamap) | DEC-032, DEC-080, DEC-093 |
| A concept: an idea | [template-concept.dita](template-concept.dita) | Standards, section 5 |
| A chapter introduction | [template-chapter-introduction.dita](template-chapter-introduction.dita) | Standards, section 5 |
| A reference: a table to look things up in | [template-reference.dita](template-reference.dita) | Standards, section 5 |
| A troubleshooting topic: one problem | [template-troubleshooting.dita](template-troubleshooting.dita) | Standards, section 5 |
| A glossary entry | [template-glossentry.dita](template-glossentry.dita) | [Style guide, section 5](../../authoring/style-guide.md#5-words) |
| A good practice concept | [template-good-practice-concept.dita](template-good-practice-concept.dita) | [Good practice strategy, section 8](../../authoring/good-practice-strategy.md#8-writing-and-review-rules) |
| A key concept in four ways: see, read, do, check | The four `template-key-concept-*.dita` files, [template-key-concept-set.ditamap](template-key-concept-set.ditamap) and [template-diagram.svg](template-diagram.svg) | DEC-035, DEC-036 |
| A clickable diagram | [template-diagram.svg](template-diagram.svg), shown by [template-key-concept-see.dita](template-key-concept-see.dita) | DEC-036, DEC-051 |
| A platform's label keys | [template-platform-ui-labels.ditamap](template-platform-ui-labels.ditamap) | DEC-090, DEC-094 |
| A platform's picture keys | [template-platform-images.ditamap](template-platform-images.ditamap) | DEC-011, DEC-085 |

## How to use one

1. **Copy the file** into the folder where the topic belongs (the [content README](../README.md) says where) and give it its real name: a verb for a task (`add-a-person.dita`), a noun phrase for a concept, the symptom for troubleshooting. Names never change after publication.
2. **Make the `id` the same as the file name** without `.dita`. The lint fails a topic whose `id` differs.
3. **Read the comment at the top, do what it says, then delete it.** It holds the rules for that kind of topic.
4. **Change every sentence.** The words in a template are only there to show the shape. Write the real ones from the app on the device, using the Brontë dataset for examples.
5. **Use label keys, never typed labels.** The keys in a template (`ui-add`, `ui-save`) are real, so they resolve. Add a new key to the right key map and to the [terminology list](../../authoring/terminology.md).
6. **Give the topic its help identifier** if it is a task that names controls on a screen ([metadata vocabulary, section 5](../../authoring/metadata-vocabulary.md#5-the-help-identifier)).
7. **Put it in a map** with its key (the file name), then run the checks:

```powershell
pwsh build/scripts/check-source.ps1
```

## Changing a template

A template is a promise about what good looks like. Change one only with a reason, in a pull request that also changes the standard it follows. Run `pwsh build/scripts/test-source-rules.ps1`: it must still pass, and it builds every template with the toolkit.
