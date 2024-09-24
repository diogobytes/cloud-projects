import functions_framework
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json


@functions_framework.http
def get_movies_by_year(request):

    try:
        # Initialize Firebase Admin SDK with default application credentials
        cred = credentials.ApplicationDefault()
        firebase_admin.initialize_app(cred)

        # Create a Firestore client
        db = firestore.client()

        # Stream all documents from the 'movies' collection
        movies = db.collection("movies").where("release_year", "==", request).stream()

        # Store movie data in a list
        list_movies = [movie.to_dict() for movie in movies]

        # Return the list of movies as a JSON response
        return json.dumps(list_movies), 200, {"Content-Type": "application/json"}
    except Exception as e:
        print(f"Error occurred: {e}")
        return (
            json.dumps({"error": "Failed to fetch movies"}),
            500,
            {"Content-Type": "application/json"},
        )
