#!/bin/bash

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
    echo "File located: $FILE_PATH"
    echo "Starting file upload to the Google Cloud Storage bucket: $STORAGE_BUCKET_NAME..."

    # Attempt to copy the file to Google Cloud Storage
    gcloud storage cp $FILE_PATH gs://$STORAGE_BUCKET_NAME

    # Check if the upload was successful
    if [[ $? -eq 0 ]]; then
        echo "Success: The file '$FILE_PATH' has been uploaded to the Google Cloud Storage bucket '$STORAGE_BUCKET_NAME'."
    else
        echo "Error: The file upload failed. Please check your internet connection, bucket permissions, and try again."
    fi
else
    echo "Error: The file '$FILE_PATH' does not exist. Please provide a correct file path."
fi
