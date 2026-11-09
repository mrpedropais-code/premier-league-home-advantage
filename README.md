# Did Home Advantage Disappear in Empty Stadiums?

An analysis of 3,800 Premier League matches (2015/16 to 2024/25) asking whether home advantage weakened when games were played behind closed doors during COVID-19, and whether it came back with the crowds.

![Power BI dashboard](dashboard.png)

## Key findings

- **Home goal advantage dropped significantly without crowds.** Home teams outscored away teams by about a third of a goal per match before COVID-19, but by almost nothing behind closed doors.
- **The referee card gap closed without crowds and reopened when they returned.** With fans, away teams received more yellow cards than home teams. Without fans the gap was essentially zero, and it was significantly larger again once crowds came back.
- **Home win rate followed the same pattern but did not reach significance** (p = .058).
- **Single seasons are noisy.** 2020/21, the only season fully behind closed doors, had almost no home advantage, but 2024/25 was nearly as low with full crowds.

The effects are small, and the closed-doors period also differed in other ways (congested fixtures, five substitutions, the summer 2020 restart), so the results are consistent with a crowd effect rather than proof of one.

## Why this question?

Home teams usually win more often, but it's hard to know *why*. Is it travel, familiarity with the pitch, or the crowd? From June 2020 to May 2021, Premier League matches were played with no fans while almost everything else stayed the same. That makes it a **natural experiment**: a rare chance to see what happens to home advantage when the crowd is removed.

As a psychology graduate, I'm especially interested in the social side: do crowds put pressure on referees?

## Data

- **Source:** match-by-match Premier League results and statistics originally compiled by [football-data.co.uk](https://www.football-data.co.uk/), downloaded via the [DataHub mirror](https://datahub.io/football/english-premier-league).
- **Coverage:** 10 seasons, 2015/16 to 2024/25, 380 matches each (3,800 total).
- **Variables used:** date, teams, full-time goals and result, shots, fouls, corners, and yellow and red cards for each side.

The raw CSV files are not included in this repo. To reproduce the analysis, download the ten season files (`season-1516.csv` to `season-2425.csv`) from the link above.

## Method

### 1. Load and clean (SQL, MySQL)

[`01_load_and_clean.sql`](01_load_and_clean.sql) loads all ten seasons into one table and adds:

| Column | Meaning |
|---|---|
| `period` | `pre` (crowds, before June 2020), `closed` (no crowds, June 2020 to May 2021), `post` (crowds back, from August 2021) |
| `home_win` | 1 if the home team won, 0 otherwise |
| `goal_diff` | home goals minus away goals |
| `card_diff` | away yellow cards minus home yellow cards |
| `foul_diff` | away fouls minus home fouls |

The script ends with data checks (matches per season, rows per period) to confirm everything loaded correctly.

### 2. Dashboard (Power BI)

[`premier-league-home-advantage.pbix`](premier-league-home-advantage.pbix) shows home win % by period, home goal advantage per season, and the yellow card differential by period, with the closed-doors period highlighted.

### 3. Statistical testing (Jamovi)

- **Home win rate** was compared across periods with a chi-square test of association.
- **Goal difference** and **card difference** were compared across periods with Welch's one-way ANOVA (which does not assume equal variances), followed by Games-Howell post-hoc comparisons between each pair of periods.
- **Season-level descriptives** were used to check whether the low 2024/25 figure reflected a long-term decline.

## Results

### Averages by period

| Period | Matches | Home win % | Avg goal difference (home − away) | Avg card difference (away − home) |
|---|---|---|---|---|
| Pre (crowds) | 1,808 | 45.7% | +0.34 | +0.16 |
| Closed (no crowds) | 472 | 39.6% | +0.08 | +0.01 |
| Post (crowds back) | 1,520 | 44.5% | +0.26 | +0.23 |

### Home win rate

Home teams won 45.7% of matches before COVID-19, 39.6% behind closed doors and 44.5% after fans returned, but the difference between periods was not statistically significant, χ²(2, N = 3800) = 5.68, p = .058. The pattern is in the expected direction, but win rate is a blunt measure: a draw and a heavy defeat both count as "not a win".

### Goal difference

Goal difference differed between periods, Welch's F(2, 1310) = 3.40, p = .034. Games-Howell comparisons showed home goal advantage was significantly lower behind closed doors (M = 0.08) than before COVID-19 (M = 0.34), p = .028, but not significantly different from after fans returned (M = 0.26), p = .190. The post-COVID average is pulled down by the unusually low 2024/25 season (see below).

### Yellow cards

The yellow card differential also differed between periods, Welch's F(2, 1359) = 3.57, p = .028. Away teams received significantly more yellow cards relative to home teams once crowds returned (M = 0.23) than behind closed doors (M = 0.01), p = .021. The difference from the pre-COVID period (M = 0.16) was not significant, p = .133. This fits the idea that crowd noise puts social pressure on referees, although the data cannot show that this is the reason.

### Season by season

| Season | Avg goal difference |
|---|---|
| 2015/16 | +0.28 |
| 2016/17 | +0.40 |
| 2017/18 | +0.38 |
| 2018/19 | +0.32 |
| 2019/20 | +0.31 |
| **2020/21** | **+0.01** |
| 2021/22 | +0.21 |
| 2022/23 | +0.42 |
| 2023/24 | +0.32 |
| 2024/25 | +0.09 |

Home goal advantage was fairly stable at around 0.3 goals per match, apart from two seasons. 2020/21, the only season played entirely behind closed doors, showed almost no home advantage. However, 2024/25 was nearly as low despite full crowds, which shows that single-season averages are noisy and that a low season can occur for reasons other than crowd absence. There is no sign of a gradual decline: 2022/23 had the highest home advantage of the decade. (2019/20 looks normal because only its final 92 matches were played behind closed doors.)

## Limitations

- **Small effects:** the differences amount to about a quarter of a goal and a fifth of a yellow card per match.
- **Not a perfect experiment:** the closed-doors period also had congested fixtures, five substitutions per team and a summer restart, so crowd absence is not the only thing that changed.
- **Limited closed-doors data:** only 472 matches were played without fans, which limits the power to detect small differences.
- **Team strength not controlled:** the mix of strong and weak teams varies by season. A logistic regression controlling for team strength would be a useful next step.

## Tools

MySQL (MySQL Workbench) · Power BI · Jamovi

## Author

**Pedro Pais**, BSc (Hons) Psychology, Aston University
