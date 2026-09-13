-- =========================================================
-- Teamfight Tactics Analytics
-- Database Schema
-- =========================================================
-- This file contains the main MySQL tables used in the project.
-- Data was collected from the Riot Games API using Python
-- and stored in a MySQL database.
-- =========================================================


-- ---------------------------------------------------------
-- Match list
-- Stores match IDs collected for individual players.
-- ---------------------------------------------------------

CREATE TABLE IF NOT EXISTS tft_matchlist_euw (
    puuid VARCHAR(100) NOT NULL,
    match_id VARCHAR(30) NOT NULL,
    snapshot_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (puuid, match_id)
);


-- ---------------------------------------------------------
-- Match participants
-- Stores participant-level statistics for each TFT match.
-- One row represents one player in one match.
-- ---------------------------------------------------------

CREATE TABLE IF NOT EXISTS tft_match_participants_euw (
    match_id VARCHAR(30) NOT NULL,
    puuid VARCHAR(100) NOT NULL,

    riot_name VARCHAR(100),
    riot_tag VARCHAR(20),

    placement INT,
    level INT,
    last_round INT,

    total_damage INT,
    total_damage_to_players INT,
    players_eliminated INT,

    gold_left INT,
    time_eliminated DOUBLE,

    game_datetime BIGINT,
    game_length DOUBLE,
    set_tag VARCHAR(20),

    snapshot_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (match_id, puuid)
);


-- ---------------------------------------------------------
-- Match traits
-- Stores traits used by each participant in each match.
-- ---------------------------------------------------------

CREATE TABLE IF NOT EXISTS tft_match_traits_euw (
    match_id VARCHAR(30) NOT NULL,
    puuid VARCHAR(100) NOT NULL,
    trait_name VARCHAR(80) NOT NULL,

    num_units INT,
    tier_current INT,
    tier_total INT,
    style INT,

    snapshot_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (match_id, puuid, trait_name),

    INDEX idx_trait (trait_name),
    INDEX idx_match (match_id),
    INDEX idx_puuid (puuid)
);
