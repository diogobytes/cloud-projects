import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json


def get_movies():
    """
    Function to retrieve a list of movies from a Firestore database.
    
    This function initializes the Firebase Admin SDK, connects to the Firestore 
    database, and retrieves all documents from the 'movies' collection, converting 
    them into a list of dictionaries. The list is then returned in JSON format.
    """

    # Initialize Firebase Admin SDK with default application credentials
    # This allows the function to authenticate and interact with Firebase services
    cred = credentials.ApplicationDefault()
    firebase_admin.initialize_app(cred)

    # Create a Firestore client to interact with Firestore database
    db = firestore.client()

    # Stream all documents from the 'movies' collection in Firestore
    get_movies = db.collection('movies').stream()

    # Initialize an empty list to store movie data
    list_movies = list()

    # Iterate through each movie document retrieved from Firestore
    for movie in get_movies:
        # Convert Firestore document to a Python dictionary and append it to the list
        list_movies.append(movie.to_dict())

    # Return the list of movies in JSON format, formatted with indentation for readability
    return json.dumps(list_movies, indent=4)