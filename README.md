# Teamfight Tactics Data Analytics

A personal data analytics project based on real Teamfight Tactics match data collected from the Riot Games API.

The project covers the complete data analysis workflow — from collecting and storing raw data, through SQL transformation and data modeling, to building an interactive Power BI dashboard.

## Project Overview

The main goal of this project was to analyze high-level Teamfight Tactics matches from the EUW server and explore player performance, lobby strength and the effectiveness of different traits and synergies.

The analysis is based on approximately 200 matches and more than 1,500 player records.

The project focuses on three main areas:

- **Lobby Strength** – comparison of player performance using metrics such as average placement, Top 4 rate and number of games.
- **Trait & Synergy Analysis** – analysis of the popularity and effectiveness of different TFT traits.
- **Challenger Leaderboard** – comparison of players from the EUW Challenger ladder.


## Technologies & Tools

- **Python** – collecting data from the Riot Games API and loading it into the MySQL database
- **Riot Games API** – source of Challenger player and match data
- **MySQL** – storage of collected match, player and trait data
- **SQL** – data transformation, joins, aggregations and creation of analytical views
- **Power Query** – data preparation before loading data into the report
- **Power BI** – data modeling, visualization and dashboard development
- **DAX** – creation of measures and calculated metrics used in the analysis

 ## Data Pipeline

The project follows an end-to-end data workflow:

**Riot Games API → Python → MySQL → SQL → Power BI → DAX → Dashboard**

1. Match and Challenger player data was retrieved from the **Riot Games API** using Python.
2. Python scripts processed the API responses and loaded the collected data into a **MySQL database**.
3. **SQL** was used to join tables, aggregate data and create views prepared for analysis.
4. The prepared data was loaded into **Power BI**, where additional transformations and data modeling were performed.
5. **DAX measures** were created to calculate analytical metrics such as Average Placement, Top 4 Rate and Games Played.
6. The final results were presented in an interactive **Power BI dashboard**.
