-- =========================================================
-- Teamfight Tactics Analytics
-- Player & Challenger Analysis
-- =========================================================
-- Queries used to compare player performance and analyze
-- Challenger players across the collected TFT matches.
-- =========================================================


-- ---------------------------------------------------------
-- Player performance summary
-- Only players with at least 10 analyzed matches are included
-- to reduce the impact of very small samples.
-- ---------------------------------------------------------

SELECT
    riot_name,
    COUNT(*) AS games,
    ROUND(AVG(placement), 2) AS avg_placement,
    ROUND(
        AVG(
            CASE
                WHEN placement <= 4 THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS top4_pct,
    ROUND(AVG(total_damage_to_players), 2) AS avg_damage,
    ROUND(AVG(level), 2) AS avg_level
FROM tft_match_participants_euw
GROUP BY riot_name
HAVING COUNT(*) >= 10
ORDER BY avg_placement ASC, top4_pct DESC;


-- ---------------------------------------------------------
-- Win rate by player
-- ---------------------------------------------------------

SELECT
    riot_name,
    COUNT(*) AS games,
    ROUND(
        AVG(
            CASE
                WHEN placement = 1 THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS winrate_pct
FROM tft_match_participants_euw
GROUP BY riot_name
HAVING COUNT(*) >= 10
ORDER BY winrate_pct DESC, games DESC;


-- ---------------------------------------------------------
-- Overall Top 4 rate for Challenger players
-- ---------------------------------------------------------

SELECT
    COUNT(*) AS games,
    ROUND(
        AVG(
            CASE
                WHEN p.placement <= 4 THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS top4_pct
FROM tft_match_participants_euw p
JOIN tft_challenger_euw c
    ON c.puuid = p.puuid;


-- ---------------------------------------------------------
-- Percentage of matches where at least one Challenger
-- player reached the Top 4
-- ---------------------------------------------------------

SELECT
    COUNT(*) AS matches_with_challengers,
    ROUND(
        AVG(challenger_in_top4) * 100,
        2
    ) AS pct_matches_where_any_challenger_top4
FROM (
    SELECT
        p.match_id,
        MAX(
            CASE
                WHEN p.placement <= 4 THEN 1
                ELSE 0
            END
        ) AS challenger_in_top4
    FROM tft_match_participants_euw p
    JOIN tft_challenger_euw c
        ON c.puuid = p.puuid
    GROUP BY p.match_id
) AS challenger_match_summary;


-- ---------------------------------------------------------
-- Number of Challenger players in each lobby
-- ---------------------------------------------------------

SELECT
    p.match_id,
    SUM(
        CASE
            WHEN c.puuid IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS challengers_in_lobby
FROM tft_match_participants_euw p
LEFT JOIN tft_challenger_euw c
    ON c.puuid = p.puuid
GROUP BY p.match_id
ORDER BY challengers_in_lobby DESC;


-- ---------------------------------------------------------
-- Challenger vs non-Challenger average placement
-- ---------------------------------------------------------

SELECT
    CASE
        WHEN c.puuid IS NOT NULL THEN 'Challenger'
        ELSE 'Non-Challenger'
    END AS player_group,
    COUNT(*) AS player_records,
    ROUND(AVG(p.placement), 2) AS avg_placement,
    ROUND(
        AVG(
            CASE
                WHEN p.placement <= 4 THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS top4_pct
FROM tft_match_participants_euw p
LEFT JOIN tft_challenger_euw c
    ON c.puuid = p.puuid
GROUP BY player_group
ORDER BY avg_placement;
