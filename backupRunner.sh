#!/bin/sh

# Backup Runner runs the dgraph export and then transfers
# the backup to an S3 backup. 

### Pre-requisites ###

# aws s3 must have been configured before running this script. 
# the backups are created in the ~/dgraph directory.
# the backups are to be transferred to a s3 bucket called backups, in a directory called dgraphbackups

# Run the backup
curl localhost:8280/admin/export

LATEST=$(ls -td ~/dgraph/dgraph.* | head -n 1 | xargs -n 1 basename)

# If there is no backups to transfer, then exit.
if [ ! $LATEST ]; then
    echo "Backup not found!"
    exit 1
fi

s3Exists=$(aws s3 ls s3://backups/dgraphbackups/$LATEST)

# If the backup already exists in the S3 backup. then exit.
if [ ! -z "$s3Exists" ]
then
    echo "$LATEST backup already exists in S3 backup"
    exit 1
fi

# Otherwise send it to the S3 bucket
aws s3 cp ~/dgraph/$LATEST/ s3://backups/dgraphbackups/$LATEST --recursive
