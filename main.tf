terraform {
  backend "remote" {
    organization = "confy"
    workspaces {
      name = "Nizuri"
    }
  }
}
provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = var.google_credentials
}

resource "google_container_registry" "nizuri" {
  project  = var.project_name
  location = var.location
}

resource "google_project_iam_custom_role" "nizuri" {
  role_id     = "nizuri"
  title       = "Nizuri Admin"
  description = "The necessary perms for nizuri"
  permissions = ["storage.buckets.create", "storage.buckets.delete", "storage.buckets.get", "storage.buckets.getIamPolicy", "storage.buckets.list", "storage.buckets.setIamPolicy", "storage.buckets.update",
  "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.getIamPolicy", "storage.objects.list", "storage.objects.setIamPolicy", "storage.objects.update"]
}


resource "google_service_account" "nizurisa" {
  account_id   = "nizurisa"
  display_name = "Nizuri Service admin"
}

resource "google_project_iam_binding" "nizbinding" {
  role = "projects/${var.project_name}/roles/${google_project_iam_custom_role.nizuri.role_id}"

  members = [
    "serviceAccount:${google_service_account.nizurisa.email}",
  ]
}

# resource "google_compute_instance" "docker" {
#   count = 1

#   name         = "tf-docker-${count.index}"
#   machine_type = "f1-micro"
#   zone         = "${var.region_zone}"
#   tags         = ["docker-node"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160602"
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       # Ephemeral
#     }
#   }

#   metadata {
#     ssh-keys = "root:${file("${var.public_key_path}")}"
#   }


#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("${var.private_key_path}")}"
#       agent       = false
#     }

#     inline = [
#       "sudo curl -sSL https://get.docker.com/ | sh",
#       "sudo usermod -aG docker `echo $USER`",
#       "sudo docker run -d -p 80:80 nginx"
#     ]
#   }

#   service_account {
#     scopes = ["https://www.googleapis.com/auth/compute.readonly"]
#   }
# }

# resource "google_compute_firewall" "default" {
#   name    = "tf-www-firewall"
#   network = "default"

#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }

#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["docker-node"]
# }