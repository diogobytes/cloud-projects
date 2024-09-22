import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json

def get_movies_by_year():
  print("Initialize")