-- =====================================================================
-- Premier League home advantage project
-- Script 01: load the ten season files, combine, clean and check
-- MySQL 8
--
-- BEFORE RUNNING:
--   1. The 10 season files must be in C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/
--
--
--   2. Run the whole script with the lightning bolt.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS football;
USE football;

-- ---------------------------------------------------------------------
-- STEP 1: Raw staging table
-- Everything is loaded as text first, so nothing fails on odd values.
-- We convert to proper types in Step 3.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS raw_matches;
CREATE TABLE raw_matches (
    season          VARCHAR(7),
    match_date_raw  VARCHAR(20),
    home_team       VARCHAR(50),
    away_team       VARCHAR(50),
    fthg VARCHAR(5), ftag VARCHAR(5), ftr VARCHAR(5),
    hthg VARCHAR(5), htag VARCHAR(5), htr VARCHAR(5),
    referee         VARCHAR(60),
    hs VARCHAR(5),  as_ VARCHAR(5),
    hst VARCHAR(5), ast VARCHAR(5),
    hf VARCHAR(5),  af VARCHAR(5),
    hc VARCHAR(5),  ac VARCHAR(5),
    hy VARCHAR(5),  ay VARCHAR(5),
    hr VARCHAR(5),  ar VARCHAR(5)
);

-- ---------------------------------------------------------------------
-- STEP 2: Load each season
-- Column order matches the DataHub files:
-- Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR, HTHG, HTAG, HTR, Referee,
-- HS, AS, HST, AST, HF, AF, HC, AC, HY, AY, HR, AR
-- (AS is renamed as_ because AS is a reserved word in SQL.)
-- ---------------------------------------------------------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-1516.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2015/16';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-1617.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2016/17';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-1718.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2017/18';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-1819.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2018/19';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-1920.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2019/20';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-2021.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2020/21';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-2122.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2021/22';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-2223.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2022/23';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-2324.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2023/24';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/season-2425.csv'
INTO TABLE raw_matches FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(match_date_raw, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr, referee,
 hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SET season = '2024/25';

-- Quick check: should be 3800 rows (10 seasons x 380 matches)
SELECT COUNT(*) AS raw_rows FROM raw_matches;

-- ---------------------------------------------------------------------
-- STEP 3: Clean, typed table
-- - Dates handled whether they arrive as YYYY-MM-DD or DD/MM/YYYY
-- - Text trimmed; stray Windows line-ending characters (\r) removed
-- - Blank numbers become NULL instead of 0
-- - New columns: period, home_win, goal_diff, card_diff, foul_diff
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS matches;
CREATE TABLE matches (
    match_id    INT AUTO_INCREMENT PRIMARY KEY,
    season      VARCHAR(7),
    match_date  DATE,
    period      VARCHAR(6),
    home_team   VARCHAR(50),
    away_team   VARCHAR(50),
    referee     VARCHAR(60),
    fthg INT, ftag INT, ftr CHAR(1),
    hthg INT, htag INT, htr CHAR(1),
    hs INT, as_ INT, hst INT, ast INT,
    hf INT, af INT, hc INT, ac INT,
    hy INT, ay INT, hr INT, ar INT,
    home_win    TINYINT,   -- 1 = home win, 0 = draw or away win
    goal_diff   INT,       -- home goals minus away goals
    card_diff   INT,       -- away yellows minus home yellows (positive = away team booked more)
    foul_diff   INT        -- away fouls minus home fouls
);

INSERT INTO matches (
    season, match_date, home_team, away_team, referee,
    fthg, ftag, ftr, hthg, htag, htr,
    hs, as_, hst, ast, hf, af, hc, ac, hy, ay, hr, ar
)
SELECT
    season,
    CASE
        WHEN TRIM(match_date_raw) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(TRIM(match_date_raw), '%Y-%m-%d')
        WHEN TRIM(match_date_raw) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(TRIM(match_date_raw), '%d/%m/%Y')
        WHEN TRIM(match_date_raw) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$'
            THEN STR_TO_DATE(TRIM(match_date_raw), '%d/%m/%y')
    END,
    TRIM(home_team),
    TRIM(away_team),
    NULLIF(TRIM(referee), ''),
    CAST(NULLIF(TRIM(fthg), '') AS SIGNED),
    CAST(NULLIF(TRIM(ftag), '') AS SIGNED),
    NULLIF(TRIM(ftr), ''),
    CAST(NULLIF(TRIM(hthg), '') AS SIGNED),
    CAST(NULLIF(TRIM(htag), '') AS SIGNED),
    NULLIF(TRIM(htr), ''),
    CAST(NULLIF(TRIM(hs),  '') AS SIGNED),
    CAST(NULLIF(TRIM(as_), '') AS SIGNED),
    CAST(NULLIF(TRIM(hst), '') AS SIGNED),
    CAST(NULLIF(TRIM(ast), '') AS SIGNED),
    CAST(NULLIF(TRIM(hf),  '') AS SIGNED),
    CAST(NULLIF(TRIM(af),  '') AS SIGNED),
    CAST(NULLIF(TRIM(hc),  '') AS SIGNED),
    CAST(NULLIF(TRIM(ac),  '') AS SIGNED),
    CAST(NULLIF(TRIM(hy),  '') AS SIGNED),
    CAST(NULLIF(TRIM(ay),  '') AS SIGNED),
    CAST(NULLIF(TRIM(hr),  '') AS SIGNED),
    CAST(NULLIF(TRIM(REPLACE(ar, '\r', '')), '') AS SIGNED)
FROM raw_matches
WHERE TRIM(home_team) <> '';   -- skips any blank trailing lines

-- Add the derived columns
UPDATE matches
SET period = CASE
                 WHEN match_date <  '2020-06-01' THEN 'pre'     -- normal crowds
                 WHEN match_date <= '2021-05-31' THEN 'closed'  -- behind closed doors
                 ELSE 'post'                                    -- crowds back from Aug 2021
             END,
    home_win  = CASE WHEN ftr = 'H' THEN 1 ELSE 0 END,
    goal_diff = fthg - ftag,
    card_diff = ay - hy,
    foul_diff = af - hf
WHERE match_id > 0;   -- Workbench's safe update mode needs a WHERE on the key column

-- ---------------------------------------------------------------------
-- STEP 4: Data checks
-- Run these one at a time and note anything odd in your write-up.
-- ---------------------------------------------------------------------

-- 4a. Matches per season: every season should show 380
SELECT season, COUNT(*) AS matches
FROM matches
GROUP BY season
ORDER BY season;

-- 4b. Matches per period
SELECT period, COUNT(*) AS matches, MIN(match_date) AS first_match, MAX(match_date) AS last_match
FROM matches
GROUP BY period
ORDER BY first_match;

-- 4c. Missing values in the columns the analysis needs (all should be 0)
SELECT
    SUM(match_date IS NULL) AS missing_date,
    SUM(fthg IS NULL OR ftag IS NULL) AS missing_goals,
    SUM(ftr IS NULL) AS missing_result,
    SUM(hst IS NULL OR ast IS NULL) AS missing_shots_on_target,
    SUM(hf IS NULL OR af IS NULL) AS missing_fouls,
    SUM(hy IS NULL OR ay IS NULL) AS missing_yellows,
    SUM(referee IS NULL) AS missing_referee
FROM matches;

-- 4d. Duplicate matches (should return no rows)
SELECT match_date, home_team, away_team, COUNT(*) AS copies
FROM matches
GROUP BY match_date, home_team, away_team
HAVING COUNT(*) > 1;

-- 4e. Every team name with its seasons: look for spelling variants
--     (e.g. "Man United" vs "Manchester United")
SELECT home_team, COUNT(DISTINCT season) AS seasons, MIN(season) AS first_season, MAX(season) AS last_season
FROM matches
GROUP BY home_team
ORDER BY home_team;

-- 4f. Sanity check: result column agrees with the score (should return no rows)
SELECT match_id, season, home_team, away_team, fthg, ftag, ftr
FROM matches
WHERE (fthg > ftag AND ftr <> 'H')
   OR (fthg < ftag AND ftr <> 'A')
   OR (fthg = ftag AND ftr <> 'D');

-- 4g. First look at the main question
SELECT period,
       COUNT(*) AS matches,
       ROUND(100.0 * AVG(home_win), 1) AS home_win_pct,
       ROUND(AVG(goal_diff), 2)       AS avg_goal_diff,
       ROUND(AVG(card_diff), 2)       AS avg_card_diff
FROM matches
GROUP BY period
ORDER BY FIELD(period, 'pre', 'closed', 'post');
