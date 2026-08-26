# Drone Delivery Feasibility Dashboard — Hyderabad

Data cleaning (Python) + SQL analysis + Power BI dashboard evaluating drone delivery feasibility across 20 zones in Hyderabad based on weather risk, delivery cost, and safety.

## Overview

This project analyzes whether drone delivery is operationally feasible across different zones of Hyderabad. Using weather logs, delivery cost records, and zone-level attributes (obstacle density, population density, distance from hub), it builds a **safety score** for each zone/day, then aggregates that into rollout priority rankings for decision-making.

## Tools Used

- **Python (pandas, numpy)** — data cleaning and preprocessing
- **SQLite / SQL** — feasibility scoring and aggregation queries
- **Power BI** — interactive dashboard for visual analysis

## Project Workflow

1. **Data Cleaning** (`notebooks/Data_cleaning.ipynb`)
   - Standardized inconsistent zone name formatting
   - Handled missing values (wind speed, visibility, delivery cost) using zone-level averages
   - Detected and corrected bad sensor readings (impossible wind speeds >100 km/h, battery % >100)
   - Fixed sign errors in delivery cost data
   - Removed duplicate records
   - Exported cleaned datasets and loaded them into a SQLite database

2. **Risk & Safety Scoring**
   - Combined wind speed, visibility, and obstacle density into a weighted danger score
   - Converted to a 0–100 safety score (100 = safest)

3. **SQL Analysis** (`sql/analysis_queries.sql`)
   - **Safety vs. Cost by Zone** — joins all tables to compare average safety and cost per zone
   - **Rollout Priority Score** — ranks zones using safety (60%) and cost efficiency (40%)
   - **Safety Consistency** — compares each zone's best vs. worst day to flag volatility
   - **Risky Days per Zone** — counts days per zone falling below the safety threshold

4. **Dashboard** (`dashboard/`)
   - Visualizes rollout priority, risky days, and safety range across all 20 zones in Power BI

## Key Findings

- **Kukatpally, Banjara Hills, and Charminar** rank highest for rollout priority, combining strong safety scores with efficient delivery costs.
- **Shamshabad, Kondapur, and Jubilee Hills** had the highest number of risky days, driven mainly by wind and visibility conditions.
- Safety scores vary significantly day-to-day within the same zone, showing that weather — not just location — is a major driver of feasibility.

## Repository Structure

drone-delivery-feasibility-hyderabad/
├── README.md
├── data/
│ ├── zones.csv
│ ├── weather_logs.csv
│ └── delivery_cost.csv
├── notebooks/
│ └── Data_cleaning.ipynb
├── sql/
│ └── analysis_queries.sql
├── dashboard/
│ └── (Power BI dashboard screenshot)
└── requirements.txt


## How to Run

1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Run `notebooks/Data_cleaning.ipynb` to clean the raw data and build the SQLite database
4. Run the queries in `sql/analysis_queries.sql` against the resulting database
5. Open the Power BI dashboard file (or view the included screenshot) to explore results interactively
