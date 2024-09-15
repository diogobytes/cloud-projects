#!/bin/bash
set -e
# This script is a simple CLI tool that allows users to upload files to Google Cloud Storage
# Use case: ./clouduploader.sh <FILE_PATH> <STORAGE_BUCKET_NAME>
# It checks for prerequisites and provides informative feedback during the upload process.
echo "Welcome to the Google Cloud Storage Uploader CLI"

# Prerequisites: Authenticate with Google Cloud
# gcloud auth login
# gcloud config set project <PROJECT_ID>

FILE_PATH=$1
STORAGE_BUCKET_NAME=$2
re='^[0-9]+$'

# Validate input arguments
if [[ $FILE_PATH =~ $re ]]; then
    echo "Error: The file path cannot be a number. Please provide a valid file path." >&2 
    exit 1
fi

if [[ $STORAGE_BUCKET_NAME =~ $re ]]; then
    echo "Error: The bucket name cannot be a number. Please provide a valid bucket name." >&2 
    exit 1
fi

# Check if the file exists
if [[ -f $FILE_PATH ]]; then
    
   # Check if the file already exists in the bucket
if gcloud storage ls gs://$STORAGE_BUCKET_NAME/$(basename "$FILE_PATH") > /dev/null 2>&1; then
    echo "Error: The file '$(basename "$FILE_PATH")' already exists in the bucket '$STORAGE_BUCKET_NAME'. Please choose from the following (number) how you want to proceed: "
    echo "[1] Overwrite"
    echo "[2] Skip"
    echo "[3] Rename the file"
    read option
    case $option in

    1)
        echo -n "You chosed to Overwrite"
        ;;

    2)
         echo -n "You chosed to Skip"
         exit 1
        ;;

    3)
         echo -n "You chosed to Rename the file"
         echo "Change the name to...?"
         read file_name
         # TODO: How to change the name here
         exit 1
        ;;

    esac
    
    
fi

    echo "File located: $FILE_PATH"
    echo "Starting file upload to the Google Cloud Storage bucket: $STORAGE_BUCKET_NAME..."

    # Attempt to copy the file to Google Cloud Storage
    pv "$FILE_PATH"  | gcloud storage cp - gs://$STORAGE_BUCKET_NAME/$(basename "$FILE_PATH")

    # Check if the upload was successful
    if [[ $? -eq 0 ]]; then
        echo "Success: The file '$(basename "$FILE_PATH")' has been uploaded to the Google Cloud Storage bucket '$STORAGE_BUCKET_NAME'."
        echo "Share Link: https://storage.cloud.google.com/$STORAGE_BUCKET_NAME/$(basename "$FILE_PATH")"
    else
        echo "Error: The file upload failed. Please check your internet connection, bucket permissions, bucket name and try again."
    fi
    
else
    echo "Error: The file '$FILE_PATH' does not exist. Please provide a correct file path."
fi
