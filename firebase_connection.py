

import firebase_admin
from firebase_admin import credentials, firestore
from llm.CONSTS import PROJECT_ID
# Initialize the Firebase Admin SDK
def initialize_firebase():
    # Use the application default credentials
    cred = credentials.ApplicationDefault()

    firebase_admin.initialize_app(
        cred, {
        'projectId': PROJECT_ID,
        'databaseURL': f"https://hack-banorte.firebaseio.com",
        
    })

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
    collection_name = "user_data"
    document_id = "B0nDZBfLZrqkcT1eycX4"
    data = {
        "name": "John Doe",
        "email": "john.doe@example.com",
        "age": 30
    }

    # Add data to Firestore
    #add_data(collection_name, document_id, data)

    # Read data from Firestore
    read_data(collection_name, document_id)