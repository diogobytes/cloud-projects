# This script will be a one-shot script designed to fully replicate the entire environment.

# Prerequisites
# Authentication with: `gcloud auth application-default login`


# Ensure script exits on any command failure
set -e 

check_gcloud_auth() {
  echo "[*] Check gcloud authentication..."
  gcloud auth application-default print-access-token > /dev/null 2>&1
  if [ $? -ne 0 ]; then
      echo "Error: Not authenticated with gcloud. Run 'gcloud auth application-default login' to authenticate."
      exit 1
  else 
    echo "[*] gcloud is authenticated."
  fi

}
# Add data to the (default) firestore database
handle_data() {
  echo "[*] Processing movie data..."
  if [ ! -d "movie_data_handling" ]; then
    echo "Error: Directory 'movie_data_handling' does not exist."
    exit 1
  fi
  cd movie_data_handling
  if  ! python3 process_movie_data.py ; then
    echo "Error: Failed to process movie data. Ensure Python is installed and the script is correct."
    exit 1
  fi
    echo "[*] Movie data processed successfully."
}

main() {
  check_gcloud_auth
  handle_data
}


main