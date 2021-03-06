#!/bin/bash
# I use this script to remove detached disks from gcloud projects. 

if [ $# -lt  1 ]
    then
        echo "Too few arguments supplied."
        echo "Usage: $0 name-of-gcloud-project"
else
    project=$1

    echo "Listing all detached disks in human-readable format. 
Note: The detach timestamp may have a null value. This means that the disk was 
created, but never attached to an instance."

    gcloud compute disks list \
        --project=$project \
        --filter='-users:*' \
        --format='table[box](name,type,sizeGb,creationTimestamp,lastDetachTimestamp)' \
        --sort-by=lastDetachTimestamp

    echo "Starting deletion"

    for zone in us-central1-a us-central1-b us-central1-c us-west1-a us-west1-b us-west1-c
    do
        for disk in  $(gcloud compute disks list --project=$project --filter="-users:* AND zone:( $zone )" --format="value(name)")
        do
            echo "Processing Disk: $disk"
            gcloud compute --project=$project disks delete $disk --zone "$zone" -q
        done
    done
fi
