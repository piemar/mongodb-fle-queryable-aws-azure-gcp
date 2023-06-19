provider "google" {
  project = var.project_id
  region = var.region
  credentials = file("/root/.config/gcloud/application_default_credentials.json")
}