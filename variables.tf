variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in."
}

variable "region" {
  type        = string
  description = "The region to host the network in."
}

variable "zone" {
  type        = string
  description = "The zone to host the cluster in."
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP CIDR range to attach resources to."
}

variable "name" {
  type        = string
  description = "The name of the cluster."
}

