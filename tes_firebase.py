from google.cloud import firestore

db = firestore.Client(database='hack-banorte')

doc_ref = db.collection(u'user_data').document(u'B0nDZBfLZrqkcT1eycX4')


for doc in db.collection(u'user_data').stream():
    print(f'{doc.id} => {doc.to_dict()}')