resource "google_container_cluster" "k8s" {
  name       = var.name
  network    = google_compute_network.k8s.name
  subnetwork = google_compute_subnetwork.k8s_subnet.self_link
  location   = var.zone

  initial_node_count       = 1
  remove_default_node_pool = true

  logging_service    = "none"
  monitoring_service = "none"

  release_channel = "stable"

  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  depends_on = [google_compute_network.k8s, google_compute_subnetwork.k8s_subnet]
}

resource "google_container_node_pool" "k8s_ingress_nodes" {
  name               = "ingress-node-pool"
  location           = var.zone
  cluster            = google_container_cluster.k8s.name
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_size_gb = 10

    taint {
      key    = "app.kubernetes.io/name"
      value  = "ingress-nginx"
      effect = "NO_SCHEDULE"
    }

    oauth_scopes = []

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = [var.name, "ingress"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  depends_on = [google_container_cluster.k8s]
}


resource "google_container_node_pool" "k8s_common_nodes" {
  name               = "common-node-pool"
  location           = var.zone
  cluster            = google_container_cluster.k8s.name
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_size_gb = 10

    oauth_scopes = []

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = [var.name, "common"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  depends_on = [google_container_cluster.k8s]
}
