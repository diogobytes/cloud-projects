import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json
# Use the application default credentials.
cred = credentials.ApplicationDefault()

firebase_admin.initialize_app(cred)
db = firestore.client()




with open('./data.json','r') as f:
  # conver to list
  data = json.load(f)
  for row in data:
    db.collection('movies').document(row['id']).set(
      row
  )
  
  


