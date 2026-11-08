# The dates, places and names walk

A sheet to walk the date editor, the place box, the name prompt and the list of sources on a running build, and a few differences between phones and tablets. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 6 November 2026 for [issue 129](https://github.com/oughnic/uFTi-Docs/issues/129). The pages it checks are *Dates* and the four pages below it, *Places* and *Names*. Their decisions are DEC-193, DEC-200 to DEC-205.

## Why walk

The pages were written from the app team's answers, which came from reading the code and, for some answers, from the running Windows app. Some statements were never seen on a screen. The walk settles them, so the pages say only what a reader will see.

## How to use this sheet

- **Every leg walks the rows that name it.** The last column, *On*, lists the legs, or a group from the table below. A row marked `help` is about the help links (walk plan, section 6.1), which the Alpha-2 build has; the same legs do it as `app`.
- **Start from the notes skeleton.** On the machine that runs the leg, `pwsh build/walks/New-WalkNotes.ps1 -Sheet dates-places-names -Leg <leg>` writes a `notes.md` with one line for each row that names the leg. You fill in two columns of its *Results* table: the result, and what you saw.
- **Some rows describe Alpha-1.** Where the Alpha-2 build differs from what our pages say, mark the row Different and write what you see. That is what the walk is for.
- **The result is one of four words.** *Same* (as our page says), *Different* (write what you saw), *Not found* (the screen is not there) or *Not done*.
- **A driver may fill in the *Seen* column.** On a leg that is driven with DevFlow, a script does the rows that suit it and writes what it read, and a reviewer sets the *Result*. Rows 2.5 and 6.1 and every row of sections 7 and 8 are always walked by hand (walk plan, section 4.7).
- **The collector merges the legs** into one table with a column for each leg (`build/walks/collect-walk.ps1`).

### Legs and groups

| Token | Legs |
|---|---|
| `app` | `windows-x64`, `windows-arm64`, `android-phone`, `iphone`, `ipad`, `mac` |
| `mobile` | `android-phone`, `android-fold`, `iphone`, `ipad` |
| `camera` | `android-phone`, `android-fold` |
| `help` | `windows-x64`, `windows-arm64`, `android-phone`, `iphone`, `ipad`, `mac` |

## Before you start

- Use a **scratch tree** made for the walk. Make it, then remove it. The Brontë dataset is the only family data that is allowed in this repository (DEC-025). The test dates below are not real people. The old dates are typed, not taken from any family.
- Note the device, its system version and the build version shown in the app, in the leg's environment card. The build must be the Alpha-2 build that the run names, and the app must show its version and build number (walk plan, section 6). This sheet waits for that build.
- Do not paste anything from the application's repository, and do not name its numbers (the standing rule: this repository is public). Name no machine, no account and no serial number.
- Record **what you see**, in the words on the screen, with the capital letters. A picture helps, but pictures for the manuals are made by the journeys, not by this walk.

## 1. The date editor

Open **Basic details** to add a person, and use the date of birth.

| # | Do this | Our pages say | On |
|---|---|---|---|
| 1.1 | Look at the date. Write down every control and its words. | You can type day, month and year, or choose the month from a list. The editor asks *How much do you know?*, with *The year*, *The month and year* and *The whole date*. | `app` |
| 1.2 | Find *Not sure of the date?* and open it. Write down the choices. | You say how sure you are: about right, worked out by you, a limit, or a span of time. | `app` |
| 1.3 | Look for the calendar list. **Where is it?** Does a *More* choice open it? Write the words on the control. | The control is called *Calendar*. The app team read from the code that it sits behind *More*. Nobody has opened it. | `app` |
| 1.4 | Open the calendar list. What calendars does it offer, and in what order? | Four: Gregorian (the default), Julian, Hebrew, French Republican. | `app` |
| 1.5 | Choose **Edit as text**. Look at the box and the line under it. | An example in the box, and a line that starts *Reads as*. | `app` |
| 1.6 | Type `15 March 1900` and leave the box. | *Reads as 15 March 1900.* | `app` |
| 1.7 | Type `about 1900`, `before 1900`, `after 1900`, `between 1850 and 1860`, `from 1850 to 1860`, `44 BC` and `1700 (Easter)`, one at a time. Note the *Reads as* line for each. | Each reads in words, as in the table in *Typing a date*. The last one keeps *Easter* beside the year. | `app` |
| 1.8 | Type `Easter 1700`, `15/03/1900`, `c. 1850` and `March 15, 1900`, one at a time. Note the line, any message, and whether the **Edit as text** switch can be turned off. | Kept as typed. The line only repeats the text. No warning. The switch stays on. | `app` |
| 1.9 | Type `Julian 14 February 1750`. | *Reads as 14 February 1750 (Julian).* | `app` |
| 1.10 | Type `3 September 1752`. | An ordinary date, with no warning. | `app` |
| 1.11 | Type `12 February 1731/32`. Then close the editor and open it again. Does it open in text mode? | Shown as written, with the dual year. The pickers cannot hold it, so it is always edited as text. | `app` |
| 1.12 | Type `Julian 12 February 1731/32`. Note the line. | **Not known.** The pages do not say. | `app` |
| 1.13 | Choose Hebrew from the list, and enter a date. Then French Republican. Note how the date is shown. | The date is kept in that calendar, with the calendar named. | `app` |
| 1.14 | Type `31 February 1900` and leave the box. Then **save the person**. What does the box say? What does the save do? What does the person's page show? | **Not known.** The box shows *31 February 1900* with no message. The pages do not describe the save. | `app` |
| 1.15 | Is there a help button, link or key on the date editor? What does it open? | The Dates page, through the help identifier. **Not known** whether a build shows one. | `help` |

## 2. Where a date is entered, and how it is shown and ordered

| # | Do this | Our pages say | On |
|---|---|---|---|
| 2.1 | Find every place that asks for a date: the person's form, the Baptism, Birth, Burial and Death forms, Event details, Add a family (the marriage and each child), a census form, the 1939 register, a marriage register form. Tick each. | The list in *Dates in lists and in order*. | `app` |
| 2.2 | Look in a source's forms for a date. | A source has no date of its own. | `app` |
| 2.3 | On one person, add events dated `about 1850`, `1849`, `before 1850`, `between 1848 and 1852` and one with no date. Look at the person's page, then the **Events** list. Write the order on each. | On a person's page, by year, then by kind of event. Undated events last. **Not known** for the Events list. | `app` |
| 2.4 | Add a person born `1816` and died `1855`. Look at them in a list. | A life span reads *1816–1855*. | `app` |
| 2.5 | Change the date format settings of the device, if it has them. Look at a date in the app again. | The app writes dates in words, in its own language, not the device's. | `app` |
| 2.6 | Open a census form. Is the calendar list offered? Enter a date that is not the census day. Write any warning, word for word. | The calendar is fixed to Gregorian and no list is offered. A warning never blocks. **Not known:** the words. | `app` |

## 3. Places

| # | Do this | Our pages say | On |
|---|---|---|---|
| 3.1 | Open *Place of birth* on **Basic details**. Write the words in the empty box. | *Start typing a place…* | `app` |
| 3.2 | Add three people with places that start the same, such as `Thornton, Yorkshire`, `Thornton, West Yorkshire` and `Thorpe`. In a fourth person, type `Thor`. What is offered? What does choosing one do? | Up to eight places already in the tree are offered. Choosing one uses it. There is no map and no list to pick from. | `app` |
| 3.3 | Find every field that asks for a place: *Place of death*, the event details form, *Place of birth* for a new child in Add a family. | The list in *Places*. | `app` |
| 3.4 | Is there a help button, link or key on a place field? What does it open? | The Places page. **Not known** whether a build shows one. | `help` |

## 4. Names

| # | Do this | Our pages say | On |
|---|---|---|---|
| 4.1 | Add a person called `Test Person`. Then add another with the same name, and save. Write the box word for word, and every button. | The title says the name is already in this tree. One **Use** button for the person, with the years, and **Add a new person called**. | `app` |
| 4.2 | Add a third person with the same name. Write the title and the buttons. | The title says how many people match. One **Use** button for each match, and one **Add a new person called**. | `app` |
| 4.3 | Choose **Use** on one. What happens to the form? | The form is linked to that person instead of making another. | `app` |
| 4.4 | Choose **Add a new person called**. | A second person is made. | `app` |
| 4.5 | Repeat 4.1 on **Add a family**, with a husband, a wife and a child. Does the same box appear? | **Not known.** The app team will put these names on the same help page when asked. | `app` |
| 4.6 | Is there a help button, link or key on a name field? What does it open? | The Names page. **Not known** whether a build shows one. | `help` |

## 5. Sources

| # | Do this | Our pages say | On |
|---|---|---|---|
| 5.1 | Open the sources of a fact that has a source. Write the lines under each title, word for word. | A title, then a line with the author and where the source is kept, when the source has them, and a quality line when there is one. | `app` |
| 5.2 | Choose **New source**. List every field, in order, with its hint, and which one is required. | Title (required), page or reference number, where it is kept, and the words copied from the record. There is no author field. | `app` |
| 5.3 | Save a source made this way. Look at it in the list. Is there a second line? | A source made in the app has no author, so its line shows only where it is kept. | `app` |
| 5.4 | Add the source to a fact. Write the two fields on the second step. | *Page, folio or entry (optional)* and *Quality of the evidence (optional)*. | `app` |
| 5.5 | Does *Compare records* show under a source for a birth place or a death place? Not under a fact with no place? | It shows only for a fact with a single place, and not once the fact has a source. | `app` |

## 6. Two checks on the pages themselves

| # | Do this | On |
|---|---|---|
| 6.1 | Read the Dates page and the four pages below it on the built site, with the app in your hand. Does any sentence say what the app does not do? | `app` |
| 6.2 | Read *A worked case: a birth in January*. Type its dates into the editor: `15 January 1671`, `3 April 1670`, `29 April 1672`. Do they read as the page says? | `app` |

## 7. Differences between phones and tablets

Our pages came from one device each. These rows are the differences that the app team could not confirm from the code ([issue 115](https://github.com/oughnic/uFTi-Docs/issues/115)). Note the screen the app is on and, on the Fold, whether the cover or the inner screen and whether it is folded.

| # | Do this | Our pages say | On |
|---|---|---|---|
| 7.1 | Open a person, then choose **Edit**. Does the form open part of the way down, so that you scroll up to see the top? | The iPhone and Android tablet pages say so. The Android phone and iPad pages do not. | `mobile` |
| 7.2 | Add a family tree file from the device's file picker. Do the box and the new card show at once, or only after a pause? | The iPad page says to look at the list before you choose the file again. | `mobile` |
| 7.3 | Choose **+** on a person. Does the **Add a record** sheet fill the screen? Does **More forms** show a count in brackets? | The iPhone and tablet pages say both. | `mobile` |
| 7.4 | Open an event. Does the count of sources show before the event has a source, and does it read *Sources: 0*? | The pages say the event page has a count of sources. They do not say whether it shows at 0. | `mobile` |
| 7.5 | Open the list of trees. How many cards sit in a row? | The iPad page says two to a row. The Android tablet page does not say. | `mobile` |
| 7.6 | Remove the tree that is open. Which tree, if any, becomes the open one? | **Not known.** The pages do not say. | `mobile` |

## 8. The camera route

For the phones that have a camera ([issue 68](https://github.com/oughnic/uFTi-Docs/issues/68)). The simulators have none.

| # | Do this | Our pages say | On |
|---|---|---|---|
| 8.1 | On a fact, choose the camera button. Write the device's question word for word. | The device asks whether uFTi may use the camera. | `camera` |
| 8.2 | Refuse. Write what the app says. | A box says the camera is needed to photograph a document. | `camera` |
| 8.3 | Allow it. Take a picture. Where does it appear? | **Not known.** The pages stop at the question. | `camera` |

## When the walk is done

1. Copy every **Different** and **Not found** row into a table below, with what to change in the pages. The collector does this when every leg has dropped its notes.
2. Change the pages, one small pull request for each kind of change.
3. If nothing contradicts the pages, move DEC-193 and DEC-203 to **Accepted**, with the date of the walk, and close issue 129.
4. Tell the app team about anything that looks like a fault in the app, on issue 115, with no private numbers.

## What was found

*Not walked yet.*
