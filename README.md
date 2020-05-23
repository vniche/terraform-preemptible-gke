# terraform-preemptible-gke

!!! Not suited for production, recommend only for study and development
This Terraform is intended to deliver a single-zone GKE cluster with a autoscaling preemptible g1-small node-pools based on Padok's article [Kubernetes on Google Cloud Platform: Terraform your first cluster](https://www.padok.fr/en/blog/kubernetes-google-cloud-terraform-cluster)

### Requirements

- terraform (account and CLI)
- gcloud (account and CLI)

### Setup

```shell
gcloud auth login
terraform login
```

### Enabling GCP APIs

TLDR;

```shell
bash enable-apis.sh <project_name>
```

The actual commands:

```shell
project_name=$1

# enable apis
gcloud services enable compute.googleapis.com --project=$project_name
gcloud services enable servicenetworking.googleapis.com --project=$project_name
gcloud services enable cloudresourcemanager.googleapis.com --project=$project_name
gcloud services enable container.googleapis.com --project=$project_name
```

### Create a Service Account

TLDR;

```shell
bash create-service-account.sh <service_account_name> <project_id>
```

The actual script:

```shell
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
```

### Terraforming

First, create a backend configuration file, for example, use a Terraform Cloud remote backend:

```ini
# backend.hcl
workspaces { name = "<workspace_name>" }
hostname     = "app.terraform.io"
organization = "<organization_name>"
```

```shell
terraform init -backend-config=backend.hcl
```

```ini
# eg.: variables.tfvars
name = "premmtible-cluster"
region = "us-east1"
zone = "us-east1-c"
ip_cidr_range = "10.10.0.0/16"
project_id = "terraform-12345"
```

```shell
# plan and confirm output is as expected
terraform plan

# apply the changes pointed out in planning
GOOGLE_CRENDETIALS=$(PWD)/<service_account_name>.json terraform apply
```
