# NYC TLC Borough Analytics Pipeline

This is a small end-to-end data pipeline I built to get hands-on practice with the core tools used in data engineering: cloud infrastructure, data warehousing, transformation, and orchestration. It uses the public NYC Taxi & Limousine Commission (TLC) trip data to answer one question:

**Which NYC borough has the highest average taxi fare and longest average trip duration?**

## What it does

The pipeline:

1. Downloads NYC yellow taxi trip data (January 2024) and the official taxi zone lookup table from the public TLC dataset
2. Uploads the raw files to Google Cloud Storage
3. Loads them into BigQuery
4. Joins the trip data with the zone lookup table to attach a borough to every trip, and calculates trip duration
5. Runs an analytical query to get average fare, average trip duration, and trip count per borough
6. Runs all of the above automatically through Kestra, on a weekly schedule

## Stack

- **Python** — extraction script
- **Google Cloud Storage** — raw data landing zone
- **BigQuery** — data warehouse, SQL transformations
- **Terraform** — provisions the GCS bucket and BigQuery dataset
- **Kestra** — orchestrates the pipeline end to end
- **Docker** — runs Kestra locally

## Project structure

```
nyc-tlc-pipeline/
├── terraform/          # provisions GCS bucket + BigQuery dataset
├── extraction/         # Python script: downloads data, uploads to GCS
├── transformation/      # SQL: builds the clean_trips table + the final analysis query
├── orchestration/       # Kestra flow that runs the whole pipeline
├── docker-compose.yml   # spins up Kestra locally
└── requirements.txt
```

## Data

The raw data isn't committed to this repo (it's too large for git). The pipeline downloads it directly from the public source:

- Yellow taxi trip records: https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet
- Taxi zone lookup table: https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv

## How the data model works

It's a basic star schema:

- `raw_trips` — the trip data, loaded in as-is
- `dim_zones` — the zone lookup table, maps a location ID to a borough and zone name
- `clean_trips` — `raw_trips` joined to `dim_zones`, with a calculated `trip_duration_minutes` column added in

The final analysis just groups `clean_trips` by borough and averages fare and duration.

## Running it yourself

**1. Set up GCP infrastructure**

```bash
cd terraform
terraform init
terraform apply
```

**2. Run the extraction script**

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python extraction/extract.py
```

This downloads the data and uploads it to your GCS bucket.

**3. Load into BigQuery and run the transformation**

Run the queries in `transformation/` against your BigQuery dataset — either through the BigQuery console or the `bq` CLI.

**4. Run it through Kestra**

```bash
docker-compose up -d
```

Then open `localhost:8080`, upload the project files as namespace files under `nyc.tlc`, and import the flow from `orchestration/nyc_tlc_pipeline.yml`.

