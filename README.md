# Did Home Advantage Disappear in Empty Stadiums?

An analysis of 3,800 Premier League matches (2015/16 to 2024/25) asking whether home advantage weakened when games were played behind closed doors during COVID-19, and whether it came back with the crowds.

> **Status:** In progress. Data loading and cleaning in SQL is complete. Statistical testing (Jamovi) and a Tableau dashboard are next.

## Why this question?

Home teams usually win more often, but it's hard to know *why*. Is it travel, familiarity with the pitch, or the crowd? From June 2020 to May 2021, Premier League matches were played with no fans while almost everything else stayed the same. That makes it a **natural experiment**: a rare chance to see what happens to home advantage when the crowd is removed.

As a psychology graduate, I'm especially interested in the social side: do crowds put pressure on referees?

## Data

- **Source:** match-by-match Premier League results and statistics originally compiled by [football-data.co.uk](https://www.football-data.co.uk/), downloaded via the [DataHub mirror](https://datahub.io/football/english-premier-league).
- **Coverage:** 10 seasons, 2015/16 to 2024/25, 380 matches each (3,800 total).
- **Variables used:** date, teams, full-time goals and result, shots, fouls, corners, and yellow and red cards for each side.

The raw CSV files are not included in this repo. To reproduce the analysis, download the ten season files (`season-1516.csv` to `season-2425.csv`) from the link above.

## Method

### 1. Load and clean (SQL, MySQL) ✅

[`01_load_and_clean.sql`](01_load_and_clean.sql) loads all ten seasons into one table and adds:

| Column | Meaning |
|---|---|
| `period` | `pre` (crowds, before June 2020), `closed` (no crowds, June 2020 to May 2021), `post` (crowds back, from August 2021) |
| `home_win` | 1 if the home team won, 0 otherwise |
| `goal_diff` | home goals minus away goals |
| `card_diff` | away yellow cards minus home yellow cards |
| `foul_diff` | away fouls minus home fouls |

The script ends with data checks (matches per season, rows per period) to confirm everything loaded correctly.

### 2. Statistical testing (Jamovi) ⏳

Testing whether the differences between periods are statistically significant, including a logistic regression of home wins on period while controlling for team strength.

### 3. Dashboard (Tableau Public) ⏳

An interactive dashboard of the main findings.

## Early findings

These are descriptive averages only. They haven't been tested for significance yet.

| Period | Matches | Home win % | Avg goal difference (home − away) | Avg card difference (away − home) |
|---|---|---|---|---|
| Pre (crowds) | 1,808 | 45.7% | +0.34 | +0.16 |
| Closed (no crowds) | 472 | 39.6% | +0.08 | +0.01 |
| Post (crowds back) | 1,520 | 44.5% | +0.26 | +0.23 |

**What this suggests so far:**

- **Home teams won less without fans**, and the rate mostly recovered once crowds returned.
- **The home goal advantage almost disappeared** behind closed doors, shrinking from about a third of a goal per match to almost nothing.
- **The referee card gap vanished without crowds.** With fans, away teams received slightly more yellow cards than home teams. Without fans, the gap was essentially zero, and it returned when crowds came back. This fits the idea that crowd noise puts social pressure on referees.

The drop-then-recovery pattern is what a crowd effect would predict, but the next stage will test whether these differences are larger than chance.

## Tools

MySQL (MySQL Workbench) · Jamovi · Tableau Public

## Author

**Pedro Pais**, BSc (Hons) Psychology, Aston University
