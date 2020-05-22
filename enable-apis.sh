#!/bin/bash

project_name=$1

# enable apis
gcloud services enable compute.googleapis.com --project=$project_name
gcloud services enable servicenetworking.googleapis.com --project=$project_name
gcloud services enable cloudresourcemanager.googleapis.com --project=$project_name
gcloud services enable container.googleapis.com --project=$project_name