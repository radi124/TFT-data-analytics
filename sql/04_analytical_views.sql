-- =========================================================
-- Teamfight Tactics Analytics
-- Analytical Views
-- =========================================================
-- Views created to enrich raw data and prepare
-- reporting-ready datasets for Power BI.
-- =========================================================


-- ---------------------------------------------------------
-- Enriched participants
-- Adds Top 4 and Challenger flags to participant data.
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_tft_participants_enriched AS
SELECT
    p.*,

    CASE
        WHEN p.placement <= 4 THEN 1
        ELSE 0
    END AS is_top4,

    CASE
        WHEN c.puuid IS NOT NULL THEN 1
        ELSE 0
    END AS is_challenger

FROM tft_match_participants_euw p

LEFT JOIN tft_challenger_euw c
    ON c.puuid = p.puuid;


-- ---------------------------------------------------------
-- Match-level summary
-- Aggregates Challenger-related statistics per match.
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_tft_match_summary AS
SELECT
    p.match_id,

    COUNT(*) AS players_in_match,

    SUM(
        CASE
            WHEN c.puuid IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS challengers_in_lobby,

    SUM(
        CASE
            WHEN c.puuid IS NOT NULL
             AND p.placement <= 4 THEN 1
            ELSE 0
        END
    ) AS challenger_top4_count,

    AVG(
        CASE
            WHEN c.puuid IS NOT NULL THEN p.placement
        END
    ) AS avg_challenger_placement,

    AVG(
        CASE
            WHEN c.puuid IS NULL THEN p.placement
        END
    ) AS avg_non_challenger_placement

FROM tft_match_participants_euw p

LEFT JOIN tft_challenger_euw c
    ON c.puuid = p.puuid

GROUP BY p.match_id;


-- ---------------------------------------------------------
-- Player traits enriched with participant information
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_tft_player_traits_enriched AS
SELECT
    t.match_id,
    t.puuid,

    p.riot_name,
    p.set_tag,
    p.game_datetime,

    p.is_challenger,
    p.is_top4,
    p.placement,

    t.trait_name,
    t.num_units,
    t.tier_current,
    t.tier_total

FROM tft_match_traits_euw t

JOIN vw_tft_participants_enriched p
    ON p.match_id = t.match_id
   AND p.puuid = t.puuid;


-- ---------------------------------------------------------
-- Final analytical view used for trait analysis in Power BI
-- Combines trait, participant and lobby-level information.
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_traits_analysis AS
SELECT
    t.match_id,
    t.puuid,

    p.riot_name,
    p.set_tag,
    p.game_datetime,

    p.is_challenger,
    p.is_top4,
    p.placement,

    t.trait_name,
    t.num_units,
    t.tier_current,
    t.tier_total,

    ms.challengers_in_lobby

FROM tft_match_traits_euw t

JOIN vw_tft_participants_enriched p
    ON p.match_id = t.match_id
   AND p.puuid = t.puuid

LEFT JOIN vw_tft_match_summary ms
    ON ms.match_id = t.match_id;
