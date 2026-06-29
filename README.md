# NYC TLC Borough Analytics Pipeline

A data pipeline using NYC's public taxi trip data to figure out which borough has the highest average fare and longest average trip duration.

I built this to get actual hands-on practice with the DE tools I'd only read about — cloud storage, a data warehouse, SQL transformations, and an orchestrator that ties it all together. I'm a Software Test Analyst doing my Computer Science Honours, and this was my way of building something real instead of just doing tutorials.

## How it works

1. A Python script downloads the January 2024 yellow taxi trip data and the taxi zone lookup table from the public TLC dataset, and uploads both to Google Cloud Storage
2. Both files get loaded into BigQuery as raw tables
3. A SQL query joins the trip data to the zone lookup table (so every trip has a borough attached) and calculates trip duration in minutes
4. A second query averages fare and duration per borough
5. Kestra runs all of this on a schedule, so it's not something I have to trigger by hand

## Stack

Python, Google Cloud Storage, BigQuery, Terraform, Kestra, Docker

## Repo layout

```
nyc-tlc-pipeline/
├── terraform/         provisions the GCS bucket and BigQuery dataset
├── extraction/         the download + upload script
├── transformation/     the two SQL queries (build clean_trips, then analyse it)
├── orchestration/      the Kestra flow
├── docker-compose.yml  spins up Kestra locally
└── requirements.txt
```

## About the data

I didn't commit the raw files since they're too big for git. The script pulls them straight from TLC's public S3 bucket:

- yellow_tripdata_2024-01.parquet
- taxi_zone_lookup.csv

## The tables

Pretty standard star schema setup:

- `raw_trips` — the trip data, untouched
- `dim_zones` — the zone lookup table, maps each location ID to a borough
- `clean_trips` — the two joined together, plus a `trip_duration_minutes` column I calculated from the pickup/dropoff timestamps

The final query just groups `clean_trips` by borough and averages everything.

## Visualisation

I hooked the `clean_trips` table up to Google Data Studio and made two bar charts — average fare and average trip duration, both by borough.

https://datastudio.google.com/s/p5NdRK10BcU

Worth flagging: EWR (Newark Airport) has the highest average fare by a wide margin but one of the shortest average durations. That's not really a "trip" in the normal sense — it's a flat airport rate, so it skews things if you're comparing it directly to actual NYC boroughs.

## Running it

**1. Spin up the infrastructure**
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

**3. Run the SQL**

The two queries in `transformation/` need to be run against BigQuery — either paste them into the BigQuery console or use the `bq` CLI.

**4. Run the Kestra flow**
```bash
docker-compose up -d
```
Open `localhost:8080`, upload the project files as namespace files under the `nyc.tlc` namespace, then import `orchestration/nyc_tlc_pipeline.yml`.

