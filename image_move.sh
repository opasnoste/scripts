#!/bin/bash
# I use this script to move images between different gcloud projects. 
# See https://cloud.google.com/sdk/gcloud/reference/compute/images for details.

if [ $# -lt  3 ]
    then
        echo "Too few arguments supplied."
        echo "Usage: $0 source_project dest_project image_name_filter"
else
    source_project=$1
    dest_project=$2
    name_filter=$3
    for image in  $(gcloud compute images list --project $source_project --filter "( name ~ $name_filter)" --format="value(name)")
    do
        echo "Processing Image: $image"
        gcloud compute --project "$dest_project" disks create $image --zone "us-central1-b" --image $image --image-project $source_project
        gcloud compute --project "$dest_project" images create $image --description "EZ stage image" --source-disk $image --source-disk-zone "us-central1-b"
        gcloud compute --project "$dest_project" disks delete $image --zone "us-central1-b" -q
    done
fi
