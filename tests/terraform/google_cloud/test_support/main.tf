terraform {
  backend "s3" {}
}

provider "google" {
  credentials = "${file("terrakvmtest.json")}"
  project     = "terrakvmtest"
  region      = "europe-west2"
}

resource "google_compute_instance" "ubuntu" {
  name         = "ubuntu"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-a"
  boot_disk {
    initialize_params {
      image = "vmx-ubuntu"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance" "centos" {
  name         = "centos"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-a"
  boot_disk {
    initialize_params {
      image = "vmx-centos"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance" "debian" {
  name         = "debian"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-a"
  boot_disk {
    initialize_params {
      image = "vmx-debian"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
