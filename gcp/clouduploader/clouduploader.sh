#!/bin/bash


# This script aims to be a bash-based CLI tool that allows users to quickly upload files to a specified cloud storage solution, providing a seamless upload experience similar to popular storage services.

# This bash script is specially made for Google Cloud
# Also, this is just to learn Bash scripting

# Use examples
# ./clouduploader.sh <FILE_PATH> <STORAGE_BUCKET_NAME>

echo "Welcome To Google Cloud Storage Uploader cli"


# Prequisites: authenticate with Gcloud
# gcloud auth login
# gcloud config set project <PROJECT_ID>

FILE_PATH=$1
STORAGE_BUCKET_NAME=$2
re='^[0-9]+$'

if [[ $FILE_PATH =~ $re ]]; then
    echo "error: file path argument cannot be a number" >&2 exit 1
fi

if [[ -f $FILE_PATH ]]; then
    echo "File: $FILE exists" 
else
    echo "Incorrect file path.. $FILE does not exist."
fi
#gcloud storage cp $FILE_PATH gs://$STORAGE_BUCKET_NAME
