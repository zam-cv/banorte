import firebase_admin
from firebase_admin import credentials, firestore
import json


# Initialize the Firebase Admin SDK
def initialize_firebase():
    # Path to your service account key file
    cred = credentials.Certificate("auth.json")
    firebase_admin.initialize_app(cred)

# Get Firestore client
def get_firestore_client():
    return firestore.client()

# Add data to Firestore
def add_data(collection_name, document_id, data):
    db = get_firestore_client()
    db.collection(collection_name).document(document_id).set(data)
    print(f"Document {document_id} added to {collection_name} collection.")

# Read data from Firestore
def read_data(collection_name, document_id):
    db = get_firestore_client()
    doc = db.collection(collection_name).document(document_id).get()
    if doc.exists:
        print(f"Document data: {doc.to_dict()}")
    else:
        print(f"No such document in {collection_name} collection.")

if __name__ == "__main__":
    # Initialize Firebase
    initialize_firebase()

    # Example usage
    collection_name = "users"
    document_id = "user_123"
    data = {
        "name": "John Doe",
        "email": "john.doe@example.com",
        "age": 30
    }

    # Add data to Firestore
    add_data(collection_name, document_id, data)

    # Read data from Firestore
    read_data(collection_name, document_id)