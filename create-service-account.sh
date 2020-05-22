#!/bin/bash

service_account_name=$1
project_name=$2

# create service account
gcloud iam service-accounts create $service_account_name --project $project_name

# associate the needed roles
gcloud projects add-iam-policy-binding $project_name --member serviceAccount:$service_account_name@$project_name.iam.gserviceaccount.com --role roles/container.admin --project $project_name
gcloud projects add-iam-policy-binding $project_name --member serviceAccount:$service_account_name@$project_name.iam.gserviceaccount.com --role roles/compute.admin --project $project_name
gcloud projects add-iam-policy-binding $project_name --member serviceAccount:$service_account_name@$project_name.iam.gserviceaccount.com --role roles/iam.serviceAccountUser --project $project_name
gcloud projects add-iam-policy-binding $project_name --member serviceAccount:$service_account_name@$project_name.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin --project $project_name

# create key and save to a file on current directory
gcloud iam service-accounts keys create $service_account_name.json --iam-account=$service_account_name@$project_name.iam.gserviceaccount.com --project $project_name