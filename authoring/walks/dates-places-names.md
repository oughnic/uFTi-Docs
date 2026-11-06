# The dates, places and names walk

A sheet to walk the date editor, the place box, the name prompt and the list of sources on a running build. Part of the [authoring plan](../authoring-plan.md). Written 6 November 2026 for [issue 129](https://github.com/oughnic/uFTi-Docs/issues/129). The pages it checks are *Dates* and the four pages below it, *Places* and *Names*. Their decisions are DEC-193, DEC-200 to DEC-205.

## Why walk

The pages were written from the app team's answers, which came from reading the code and, for some answers, from the running Windows app. Some statements were never seen on a screen. The walk settles them, so the pages say only what a reader will see.

## Before you start

- Walk on **Windows**, on the **Android phone (A41)** and on the **Mac**. One pass on each. The rows marked *the same on all* need seeing once on one device, and a quick look on the others.
- Use a **scratch tree** made for the walk. Make it, then remove it. The Brontë dataset is the only family data that is allowed in this repository (DEC-025). The test dates below are not real people. The old dates are typed, not taken from any family.
- Note the device, its system version and the build version shown in the app. The build must be the one the pages describe: the Alpha-1 build, shown as 0.1.0 (1), or the next one if Alpha-2 has started.
- Do not paste anything from the application's repository, and do not name its numbers (the standing rule: this repository is public).
- Record **what you see**, in the words on the screen, with the capital letters. A picture helps, but pictures for the manuals are made by the journeys, not by this walk.
- Mark each row **Same** (as our page says), **Different** (write what you saw) or **Not found** (the screen is not there).

## 1. The date editor

Open **Basic details** to add a person, and use the date of birth.

| # | Do this | Our pages say | Windows | A41 | Mac |
|---|---|---|---|---|---|
| 1.1 | Look at the date. Write down every control and its words. | You can type day, month and year, or choose the month from a list. The editor asks *How much do you know?*, with *The year*, *The month and year* and *The whole date*. |  |  |  |
| 1.2 | Find *Not sure of the date?* and open it. Write down the choices. | You say how sure you are: about right, worked out by you, a limit, or a span of time. |  |  |  |
| 1.3 | Look for the calendar list. **Where is it?** Does a *More* choice open it? Write the words on the control. | The control is called *Calendar*. The app team read from the code that it sits behind *More*. Nobody has opened it. |  |  |  |
| 1.4 | Open the calendar list. What calendars does it offer, and in what order? | Four: Gregorian (the default), Julian, Hebrew, French Republican. |  |  |  |
| 1.5 | Choose **Edit as text**. Look at the box and the line under it. | An example in the box, and a line that starts *Reads as*. |  |  |  |
| 1.6 | Type `15 March 1900` and leave the box. | *Reads as 15 March 1900.* |  |  |  |
| 1.7 | Type `about 1900`, `before 1900`, `after 1900`, `between 1850 and 1860`, `from 1850 to 1860`, `44 BC` and `1700 (Easter)`, one at a time. Note the *Reads as* line for each. | Each reads in words, as in the table in *Typing a date*. The last one keeps *Easter* beside the year. |  |  |  |
| 1.8 | Type `Easter 1700`, `15/03/1900`, `c. 1850` and `March 15, 1900`, one at a time. Note the line, any message, and whether the **Edit as text** switch can be turned off. | Kept as typed. The line only repeats the text. No warning. The switch stays on. |  |  |  |
| 1.9 | Type `Julian 14 February 1750`. | *Reads as 14 February 1750 (Julian).* |  |  |  |
| 1.10 | Type `3 September 1752`. | An ordinary date, with no warning. |  |  |  |
| 1.11 | Type `12 February 1731/32`. Then close the editor and open it again. Does it open in text mode? | Shown as written, with the dual year. The pickers cannot hold it, so it is always edited as text. |  |  |  |
| 1.12 | Type `Julian 12 February 1731/32`. Note the line. | **Not known.** The pages do not say. |  |  |  |
| 1.13 | Choose Hebrew from the list, and enter a date. Then French Republican. Note how the date is shown. | The date is kept in that calendar, with the calendar named. |  |  |  |
| 1.14 | Type `31 February 1900` and leave the box. Then **save the person**. What does the box say? What does the save do? What does the person's page show? | **Not known.** The box shows *31 February 1900* with no message. The pages do not describe the save. |  |  |  |
| 1.15 | Is there a help button, link or key on the date editor? What does it open? | The Dates page, through the help identifier. **Not known** whether the released build shows one. |  |  |  |

## 2. Where a date is entered, and how it is shown and ordered

| # | Do this | Our pages say | Windows | A41 | Mac |
|---|---|---|---|---|---|
| 2.1 | Find every place that asks for a date: the person's form, the Baptism, Birth, Burial and Death forms, Event details, Add a family (the marriage and each child), a census form, the 1939 register, a marriage register form. Tick each. | The list in *Dates in lists and in order*. |  |  |  |
| 2.2 | Look in a source's forms for a date. | A source has no date of its own. |  |  |  |
| 2.3 | On one person, add events dated `about 1850`, `1849`, `before 1850`, `between 1848 and 1852` and one with no date. Look at the person's page, then the **Events** list. Write the order on each. | On a person's page, by year, then by kind of event. Undated events last. **Not known** for the Events list. |  |  |  |
| 2.4 | Add a person born `1816` and died `1855`. Look at them in a list. | A life span reads *1816–1855*. |  |  |  |
| 2.5 | Change the date format settings of the device, if it has them. Look at a date in the app again. | The app writes dates in words, in its own language, not the device's. |  |  |  |
| 2.6 | Open a census form. Is the calendar list offered? Enter a date that is not the census day. Write any warning, word for word. | The calendar is fixed to Gregorian and no list is offered. A warning never blocks. **Not known:** the words. |  |  |  |

## 3. Places

| # | Do this | Our pages say | Windows | A41 | Mac |
|---|---|---|---|---|---|
| 3.1 | Open *Place of birth* on **Basic details**. Write the words in the empty box. | *Start typing a place…* |  |  |  |
| 3.2 | Add three people with places that start the same, such as `Thornton, Yorkshire`, `Thornton, West Yorkshire` and `Thorpe`. In a fourth person, type `Thor`. What is offered? What does choosing one do? | Up to eight places already in the tree are offered. Choosing one uses it. There is no map and no list to pick from. |  |  |  |
| 3.3 | Find every field that asks for a place: *Place of death*, the event details form, *Place of birth* for a new child in Add a family. | The list in *Places*. |  |  |  |
| 3.4 | Is there a help button, link or key on a place field? What does it open? | The Places page. **Not known** whether the released build shows one. |  |  |  |

## 4. Names

| # | Do this | Our pages say | Windows | A41 | Mac |
|---|---|---|---|---|---|
| 4.1 | Add a person called `Test Person`. Then add another with the same name, and save. Write the box word for word, and every button. | The title says the name is already in this tree. One **Use** button for the person, with the years, and **Add a new person called**. |  |  |  |
| 4.2 | Add a third person with the same name. Write the title and the buttons. | The title says how many people match. One **Use** button for each match, and one **Add a new person called**. |  |  |  |
| 4.3 | Choose **Use** on one. What happens to the form? | The form is linked to that person instead of making another. |  |  |  |
| 4.4 | Choose **Add a new person called**. | A second person is made. |  |  |  |
| 4.5 | Repeat 4.1 on **Add a family**, with a husband, a wife and a child. Does the same box appear? | **Not known.** The app team will put these names on the same help page when asked. |  |  |  |
| 4.6 | Is there a help button, link or key on a name field? What does it open? | The Names page. **Not known** whether the released build shows one. |  |  |  |

## 5. Sources

| # | Do this | Our pages say | Windows | A41 | Mac |
|---|---|---|---|---|---|
| 5.1 | Open the sources of a fact that has a source. Write the lines under each title, word for word. | A title, a name (called the author), and a quality line. |  |  |  |
| 5.2 | Choose **New source**. List every field, in order, with its hint, and which one is required. | Title (required), page or reference number, where it is kept, and the words copied from the record. There is no author field. |  |  |  |
| 5.3 | Save a source made this way. Look at it in the list. Is there a second line with a name? | **Not known.** This decides the sentence in *Look at the sources of a fact*. |  |  |  |
| 5.4 | Add the source to a fact. Write the two fields on the second step. | *Page, folio or entry (optional)* and *Quality of the evidence (optional)*. |  |  |  |
| 5.5 | Does *Compare records* show under a source for a birth place or a death place? Not under a fact with no place? | It shows only for a fact with a single place, and not once the fact has a source. |  |  |  |

## 6. Two checks on the pages themselves

| # | Do this | Windows | A41 | Mac |
|---|---|---|---|---|
| 6.1 | Read the Dates page and the four pages below it on the built site, with the app in your hand. Does any sentence say what the app does not do? |  |  |  |
| 6.2 | Read *A worked case: a birth in January*. Type its dates into the editor: `15 January 1671`, `3 April 1670`, `29 April 1672`. Do they read as the page says? |  |  |  |

## When the walk is done

1. Copy every **Different** and **Not found** row into a table below, with what to change in the pages.
2. Change the pages, one small pull request for each kind of change.
3. If nothing contradicts the pages, move DEC-193 and DEC-203 to **Accepted**, with the date of the walk, and close issue 129.
4. Tell the app team about anything that looks like a fault in the app, on issue 115, with no private numbers.

## What was found

*Not walked yet.*
