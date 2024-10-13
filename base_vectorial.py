import ollama
import weaviate
import warnings
import json
import os
from weaviate.classes.config import Property, DataType

warnings.simplefilter("ignore", ResourceWarning)

# Conectar al cliente de Weaviate usando 'with' para garantizar que se cierre automáticamente
def get_weaviate_client():
    return weaviate.connect_to_local()

# Lista de documentos para añadir a la colección
documents = []

current_directory = os.path.dirname(__file__)
documents_path = os.path.join(current_directory, 'documents.json')

with open(documents_path) as f:
    documents = json.load(f)

files_directory = os.path.join(current_directory, 'files')

for file in os.listdir(files_directory):
    if file.endswith('.txt'):
        file_path = os.path.join(files_directory, file)
        with open(file_path) as f:
            documents.append(f.read())

collection_name = "Docs"

def create_collection_if_not_exists(client, collection_name):
    """
    Crea la colección en Weaviate si no existe.
    """
    if collection_name not in client.collections.list_all().keys():
        return client.collections.create(
            name=collection_name,
            properties=[Property(name="text", data_type=DataType.TEXT)],
        )
    return client.collections.get(collection_name)
  
def generate_response(data, prompt):
    """
    Genera una respuesta usando el prompt y los datos recuperados de la colección.
    """

    prompt_template = f"Using this data: {data}, respond concisely to this prompt: {prompt}."
    output = ollama.generate(model="gemma2:27b", prompt=prompt_template, system="You are ...")
    return output['response']

def add_documents_to_collection(collection, documents):
    """
    Añade documentos a la colección en lotes dinámicos con embeddings generados.
    """
    existing_documents = collection.query.fetch_objects(limit=len(documents)).objects
    existing_texts = [doc.properties['text'] for doc in existing_documents]
    documents = [d for d in documents if d not in existing_texts]
    
    with collection.batch.dynamic() as batch:
        for d in documents:
            response = ollama.embeddings(model="all-minilm", prompt=d)
            if 'embedding' in response:
                batch.add_object(properties={"text": d}, vector=response["embedding"])
            else:
                print(f"Error generating embedding for document: {d}")

def query_collection(collection, prompt):
    """
    Genera un embedding para el prompt y recupera el documento más relevante de la colección.
    """
    response = ollama.embeddings(model="all-minilm", prompt=prompt)
    results = collection.query.near_vector(near_vector=response["embedding"], limit=1)
    
    # Verificar si la consulta devuelve resultados
    if not results.objects:
        print("No results found")
        return None

    data = results.objects[0].properties['text']
    return data

def main():
    with get_weaviate_client() as client:
        try:
            collection = create_collection_if_not_exists(client, collection_name)
            add_documents_to_collection(collection, documents)  # Añadir esta llamada
            prompt = input("❯ ")
            data = query_collection(collection, prompt)
            if data:
                response = generate_response(data, prompt)
                print(response)
            else:
                print("No data found")
        except Exception as e:
            print(f"An error occurred: {e}")

if __name__ == "_main_":
    main()