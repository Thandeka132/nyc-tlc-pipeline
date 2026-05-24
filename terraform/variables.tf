variable "credentials" {
  description = "My Credentials"
  default     = "../gcp-creds.json"
}


variable "project" {
  description = "Project"
  default     = "nyc-tlc-pipeline-497315"
}


variable "region" {
  description = "Region"
  default     = "africa-south1"
}


variable "location" {
  description = "Project Location"
  default     = "africa-south1"
}


variable "bq_dataset_name" {
  description = "Name of the BigQuery dataset"
  default     = "tlc_borough_analytics"
}


variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "tlc-borough-analytics-497315-terra-bucket"
}


variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
