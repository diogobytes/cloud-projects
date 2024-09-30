# This script will be a one-shot script designed to fully destroy the entire environment.

# Prerequisites
# Authentication with: `gcloud auth application-default login`


# Ensure script exits on any command failure
set -e 


destroy_cloudfunctions(){
    echo "[*] Deleting Cloud Function Get Movies..."
    if ! gcloud functions delete get_movies; then
        echo "Something wrong happened, maybe the cloud function get movies does not exist."
        exit 1
    fi
    echo "[*] Deleted function get_movies successfully"
    echo "[*] Deleting Cloud Function Get Movies By year..."
    if ! gcloud functions delete get_movies_by_year; then
        echo "Something wrong happened, maybe the cloud function get movies by year does not exist."
        exit 1
    fi
    echo "[*] Deleted function get_movies_by_year successfully"
}

main() {
    destroy_cloudfunctions

}
main