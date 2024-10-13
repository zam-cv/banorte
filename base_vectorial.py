import ollama
import weaviate
import warnings
import json
import os
from weaviate.classes.config import Property, DataType

warnings.simplefilter("ignore", ResourceWarning)

# Conectar al cliente de Weaviate usando 'with' para garantizar que se cierre automáticamente
def get_weaviate_client():
    return weaviate.connect_to_custom(
        http_host="172.31.98.243",
        http_port=8080,
        http_secure=False,
        grpc_host="172.31.98.243",
        grpc_port=50051,
        grpc_secure=False,
        headers={"User-Agent":"weaviate-python-client"}
        
    )

# Lista de documentos para añadir a la colección
file = open("Output.txt", "r")
documents = ["My name is Iker Fuentes and my id is A01749675"]
file.close()
ollama_client = ollama.Client(
    #follow_redirects=True,
    headers={
        "User-Agent": "ollama-python",
        "Content-Type": "application/json",
        "Accept": "application/json"
    },
    timeout=None
)
ollama_client.base_url = "http://172.31.98.243:11434"


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

    output = ollama_client.generate(model="gemma2:9b", prompt=prompt_template, system="You are ...")
    return output['response']


def add_documents_to_collection(collection, documents):
    existing_documents = collection.query.fetch_objects(limit=len(documents)).objects
    existing_texts = [doc.properties['text'] for doc in existing_documents]
    documents = [d for d in documents if d not in existing_texts]
    
    # Configurar el cliente de Ollama con la dirección IP
    with collection.batch.dynamic() as batch:
        for d in documents:
            try:
                response = ollama_client.embeddings(model="gemma2:9b", prompt=d)
                if 'embedding' in response:
                    batch.add_object(properties={"text": d}, vector=response["embedding"])
                else:
                    print(f"Error generating embedding for document: {d}")
            except Exception as e:
                print(f"An error occurred while generating embedding for document: {d}. Error: {e}")



def query_collection(self, prompt):
    """
    Genera un embedding para el prompt y recupera el documento más relevante de la colección.
    """
    response = ollama_client.embeddings(model="gemma2:9b", prompt=prompt)
    results = self.collection.query.near_vector(near_vector=response["embedding"], limit=1)
    
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

if __name__ == "__main__":
    main()