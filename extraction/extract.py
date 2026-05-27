import os
import wget
from dotenv import load_dotenv
from google.cloud import storage

# Load environment variables from .env file
load_dotenv()

# Define URLs and local paths for the files to be downloaded
PARQUET_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet"
CSV_URL = "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"

PARQUET_LOCAL_PATH = "data/yellow_tripdata_2024-01.parquet"
CSV_LOCAL_PATH = "data/taxi_zone_lookup.csv"

# Function to download a file from a URL to a local path
def download_file(url, local_path):

    try:
        wget.download(url, local_path)
        print(f"Downloaded {url} to {local_path} successfully.")
    except Exception as e:
        print(f"Error occurred while downloading {url}: {e}")
        raise

# Function to upload a file from local path to Google Cloud Storage
def upload_to_gcs(bucket_name, source_file_name, destination_blob_name):
    
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(destination_blob_name)
        blob.upload_from_filename(source_file_name)
        print(f"File {source_file_name} uploaded to {destination_blob_name}.")
    except Exception as e:
        print(f"Error ocurred while uploading {source_file_name} to GCS: {e}")
        raise

# Main execution block
if __name__ == "__main__":

    bucket_name = os.getenv("GCS_BUCKET_NAME")

    download_file(PARQUET_URL, PARQUET_LOCAL_PATH)
    download_file(CSV_URL, CSV_LOCAL_PATH)

    upload_to_gcs(bucket_name, PARQUET_LOCAL_PATH, "raw/yellow_tripdata_2024-01.parquet")
    upload_to_gcs(bucket_name, CSV_LOCAL_PATH, "raw/taxi_zone_lookup.csv")
