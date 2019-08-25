provider "google" {
  credentials = "${file("terrakvmtest.json")}"
  project     = "terrakvmtest"
  region      = "europe-west2"
}

resource "google_compute_disk" "base_debian" {
  name  = "debian-base"
  type  = "pd-ssd"
  zone  = "europe-west2-a"
  image = "debian-9"
}

resource "null_resource" "vmx_debian" {
  provisioner "local-exec" {
    command = "gcloud compute images create vmx-debian --source-disk ${google_compute_disk.base_debian.name} --source-disk-zone ${google_compute_disk.base_debian.zone} --licenses 'https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx'"
  }
}

resource "google_compute_disk" "base_ubuntu" {
  name  = "ubuntu-base"
  type  = "pd-ssd"
  zone  = "europe-west2-a"
  image = "ubuntu-1804-lts"
}

resource "null_resource" "vmx_ubuntu" {
  provisioner "local-exec" {
    command = "gcloud compute images create vmx-ubuntu --source-disk ${google_compute_disk.base_ubuntu.name} --source-disk-zone ${google_compute_disk.base_ubuntu.zone} --licenses 'https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx'"
  }
}

resource "google_compute_disk" "base_centos" {
  name  = "centos-base"
  type  = "pd-ssd"
  zone  = "europe-west2-a"
  image = "centos-7"
}

resource "null_resource" "vmx_centos" {
  provisioner "local-exec" {
    command = "gcloud compute images create vmx-centos --source-disk ${google_compute_disk.base_centos.name} --source-disk-zone ${google_compute_disk.base_centos.zone} --licenses 'https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx'"
  }
}
