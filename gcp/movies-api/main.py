import firebase_admin
from firebase_admin import firestore

# Application Default credentials are automatically created.
app = firebase_admin.initialize_app()
db = firestore.client()

movies_db = db.collection("movies")

print(movies_db)