-- =========================================================
-- Teamfight Tactics Analytics
-- Overview Analysis
-- =========================================================
-- Queries used to calculate the main overview metrics
-- and support the first Power BI dashboard page.
-- =========================================================


-- ---------------------------------------------------------
-- Main dashboard KPIs
-- ---------------------------------------------------------

SELECT
    COUNT(DISTINCT match_id) AS games,
    COUNT(DISTINCT puuid) AS unique_players,
    ROUND(AVG(placement), 2) AS avg_placement,
    ROUND(AVG(total_damage_to_players), 2) AS avg_damage,
    ROUND(AVG(game_length), 2) AS avg_game_length,
    ROUND(AVG(level), 2) AS avg_level
FROM tft_match_participants_euw;


-- ---------------------------------------------------------
-- Overall Top 4 rate
-- ---------------------------------------------------------

SELECT
    ROUND(
        AVG(
            CASE
                WHEN placement <= 4 THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS top4_pct
FROM tft_match_participants_euw;


-- ---------------------------------------------------------
-- Placement distribution
-- ---------------------------------------------------------

SELECT
    placement,
    COUNT(*) AS players_count
FROM tft_match_participants_euw
GROUP BY placement
ORDER BY placement;


-- ---------------------------------------------------------
-- Average damage by final placement
-- ---------------------------------------------------------

SELECT
    placement,
    ROUND(
        AVG(total_damage_to_players),
        2
    ) AS avg_damage
FROM tft_match_participants_euw
GROUP BY placement
ORDER BY placement;


-- ---------------------------------------------------------
-- Average player level by final placement
-- ---------------------------------------------------------

SELECT
    placement,
    ROUND(
        AVG(level),
        2
    ) AS avg_level
FROM tft_match_participants_euw
GROUP BY placement
ORDER BY placement;


-- ---------------------------------------------------------
-- Game length distribution
-- Rounded to full minutes for easier grouping
-- ---------------------------------------------------------

SELECT
    ROUND(game_length / 60, 0) AS game_length_minutes,
    COUNT(*) AS player_records
FROM tft_match_participants_euw
GROUP BY ROUND(game_length / 60, 0)
ORDER BY game_length_minutes;


-- ---------------------------------------------------------
-- Data quality check
-- Check whether damage columns are populated
-- ---------------------------------------------------------

SELECT
    COUNT(*) AS rows_total,
    COUNT(total_damage_to_players) AS filled_total_damage_to_players,
    COUNT(total_damage) AS filled_total_damage
FROM tft_match_participants_euw;


-- ---------------------------------------------------------
-- Data quality check
-- Verify number of participants stored for each match
-- ---------------------------------------------------------

SELECT
    match_id,
    COUNT(*) AS players_in_match
FROM tft_match_participants_euw
GROUP BY match_id
ORDER BY players_in_match ASC;
