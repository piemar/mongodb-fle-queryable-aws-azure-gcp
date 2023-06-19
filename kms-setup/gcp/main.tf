resource "google_kms_key_ring" "keyring" {

  name = var.keyring_name

  location = var.region

}


resource "google_kms_crypto_key" "key" {

  name = var.key_name

  key_ring = google_kms_key_ring.keyring.id

  rotation_period = var.rotation_period


  version_template {

    algorithm = var.algorithm

  }


  lifecycle {

    prevent_destroy = false

  }

}


data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"

    members = [
      "user:pierre@thinkworks.se",
    ]
  }
}

resource "google_kms_key_ring_iam_policy" "key_ring" {
  key_ring_id = google_kms_key_ring.keyring.id
  policy_data = data.google_iam_policy.admin.policy_data
}



resource "google_project_service" "gcp_services" {
  project = var.project_id
  service = "cloudkms.googleapis.com"

  disable_dependent_services = false
}
