import functions_framework
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json

@functions_framework.http
def get_movies(request):
    """
    HTTP-triggered function to retrieve a list of movies from a Firestore database.
    
    This function initializes the Firebase Admin SDK, connects to the Firestore 
    database, and retrieves all documents from the 'movies' collection, converting 
    them into a list of dictionaries. The list is then returned as a JSON response.
    """
    try:
        # Initialize Firebase Admin SDK with default application credentials
        cred = credentials.ApplicationDefault()
        firebase_admin.initialize_app(cred)
        
        # Create a Firestore client
        db = firestore.client()

        # Stream all documents from the 'movies' collection
        movies = db.collection('movies').stream()

        # Store movie data in a list
        list_movies = [movie.to_dict() for movie in movies]

        # Return the list of movies as a JSON response
        return json.dumps(list_movies), 200, {'Content-Type': 'application/json'}

    except Exception as e:
        # Log the error and return an error message as a JSON response
        print(f"Error occurred: {str(e)}")
        return json.dumps({"error": "An error occurred while fetching movies"}), 500, {'Content-Type': 'application/json'}



