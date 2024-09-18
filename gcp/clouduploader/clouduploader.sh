#!/bin/bash
set -e

# This script is a simple CLI tool that allows users to upload files to Google Cloud Storage.
# Usage: ./clouduploader.sh <FILE_PATH> <STORAGE_BUCKET_NAME>
echo "Welcome to the Google Cloud Storage Uploader CLI"

# Prerequisites: Authenticate with Google Cloud
# gcloud auth login
# gcloud config set project <PROJECT_ID>

# Validate input arguments
if [[ $# -ne 2 ]]; then
    echo "Error: Please provide both a file path and a storage bucket name."
    echo "Usage: ./clouduploader.sh <FILE_PATH> <STORAGE_BUCKET_NAME>"
    exit 1
fi

FILE_PATH="$1"
STORAGE_BUCKET_NAME="$2"
re='^[0-9]+$'

# Validate that FILE_PATH is not a number
if [[ $FILE_PATH =~ $re ]]; then
    echo "Error: The file path cannot be a number. Please provide a valid file path." >&2
    exit 1
fi

# Validate that STORAGE_BUCKET_NAME is not a number
if [[ $STORAGE_BUCKET_NAME =~ $re ]]; then
    echo "Error: The bucket name cannot be a number. Please provide a valid bucket name." >&2
    exit 1
fi

# Check if the file exists
if [[ -f "$FILE_PATH" ]]; then
    # Check if the file already exists in the bucket
    if gcloud storage ls gs://"$STORAGE_BUCKET_NAME"/"$(basename "$FILE_PATH")" > /dev/null 2>&1; then
        echo "Error: The file '$(basename "$FILE_PATH")' already exists in the bucket '$STORAGE_BUCKET_NAME'."
        echo "Please choose how to proceed:"
        echo "[1] Overwrite"
        echo "[2] Skip"
        echo "[3] Rename the file"
        read -r option

        case $option in
            1)
                echo "You chose to Overwrite the existing file."
                ;;
            2)
                echo "You chose to Skip the upload."
                exit 0
                ;;
            3)
                echo "You chose to Rename the file."
                echo "Enter the new file name:"
                read -r new_file_name
                mv "$FILE_PATH" "$(dirname "$FILE_PATH")/$new_file_name"
                FILE_PATH="$(dirname "$FILE_PATH")/$new_file_name"
                ;;
            *)
                echo "Invalid option. Exiting."
                exit 1
                ;;
        esac
    fi

    echo "File located: $FILE_PATH"
    echo "Starting file upload to the Google Cloud Storage bucket: $STORAGE_BUCKET_NAME..."

    # Ask user if they want to encrypt the file
    echo "Do you want to encrypt your file? (yes or no)"
    read -r option_encryption

    if [[ $option_encryption == "no" ]]; then
        pv "$FILE_PATH" | gcloud storage cp - gs://"$STORAGE_BUCKET_NAME"/"$(basename "$FILE_PATH")"
    elif [[ $option_encryption == "yes" ]]; then
        echo "Enter your KMS key resource:"
        read -r kms_key
        if [[ -z $kms_key ]]; then
            echo "Error: KMS key cannot be empty."
            exit 1
        fi
        pv "$FILE_PATH" | gcloud storage cp - gs://"$STORAGE_BUCKET_NAME"/"$(basename "$FILE_PATH")" --encryption-key="$kms_key"
    else
        echo "Error: Invalid choice. Please answer 'yes' or 'no'."
        exit 1
    fi3

    # Check if the upload was successful
    if [[ $? -eq 0 ]]; then
        echo "Success: The file '$(basename "$FILE_PATH")' has been uploaded to the Google Cloud Storage bucket '$STORAGE_BUCKET_NAME'."
        echo "Share Link: https://storage.cloud.google.com/$STORAGE_BUCKET_NAME/$(basename "$FILE_PATH")"
    else
        echo "Error: The file upload failed. Please check your internet connection, bucket permissions, and try again."
    fi
else
    echo "Error: The file '$FILE_PATH' does not exist. Please provide a valid file path."
    exit 1
fi
