import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json


def getmovies():
  # Initialize Firebase Admin SDK with application default credentials
  cred = credentials.ApplicationDefault()
  firebase_admin.initialize_app(cred)


  # Create a Firestore client to interact with the Firestore database
  db = firestore.client()

  get_movies = db.collection('movies').stream()

  list_movies = list()
  for movie in get_movies:
    list_movies.append(movie.to_dict())


  return json.dumps(list_movies,indent=4)


if __name__ == '__main__':
  getmovies()