resource "google_compute_firewall" "ingress-http" {
  name    = "ingress-http"
  network = google_compute_network.k8s.name

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["ingress"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name          = "${var.name}-${var.region}"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.k8s.self_link

  depends_on = [google_compute_network.k8s]
}

resource "google_compute_network" "k8s" {
  name                    = var.name
  auto_create_subnetworks = false
}
