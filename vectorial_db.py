import ollama
import weaviate
import warnings
import json
import os
from weaviate.classes.config import Property, DataType



class VectorialDB():
    def __init__(self,collection_name,data):
        warnings.simplefilter("ignore", ResourceWarning)
        
        self.ollama_client =  ollama.Client(
                                #follow_redirects=True,
                                headers={
                                    "User-Agent": "ollama-python",
                                    "Content-Type": "application/json",
                                    "Accept": "application/json"
                                },
                                timeout=None
                            )
        self.ollama_client.base_url = "http://172.31.98.243:11434"
        
        self.documents = data
        self.collection_name = collection_name
        self.client =  self.get_weaviate_client()
        self.collection = None
        with self.client as client:
            try:
                self.collection = self.create_collection_if_not_exists(collection_name,self.client)
                self.add_documents_to_collection()  # Añadir esta llamada
            except Exception as e:
                print(f"An error occurred: {e}")

        
        
    def get_weaviate_client(self):
        return weaviate.connect_to_custom(
            http_host="172.31.98.243",
            http_port=8080,
            http_secure=False,
            grpc_host="172.31.98.243",
            grpc_port=50051,
            grpc_secure=False,
            headers={"User-Agent":"weaviate-python-client"}
            
        )


    def create_collection_if_not_exists(self,collection_name,client):
        """
        Crea la colección en Weaviate si no existe.
        """
        print("Checking if collection exists")
        if collection_name not in client.collections.list_all().keys():
            print("Creating collection")
            return client.collections.create(
                name=collection_name,
                properties=[Property(name="text", data_type=DataType.TEXT)],
            )
        return client.collections.get(collection_name)
    

  
    def generate_response(self,data, prompt):
        """
        Genera una respuesta usando el prompt y los datos recuperados de la colección.
        """

        prompt_template = f"Using this data: {data}, respond concisely to this prompt: {prompt}."

        output = self.ollama_client.generate(model="gemma2:9b", prompt=prompt_template, system="You are ...")
        return output['response']

    def collection_exists(self,collection_name):
        return collection_name in self.client.collections.list_all().keys()

    def add_documents_to_collection(self):
        existing_documents = self.collection.query.fetch_objects(limit=len(self.documents)).objects
        existing_texts = [doc.properties['text'] for doc in existing_documents]
        self.documents = [d for d in self.documents if d not in existing_texts]
        
        # Configurar el cliente de Ollama con la dirección IP
        with self.collection.batch.dynamic() as batch:
            for d in self.documents:
                try:
                    response = self.ollama_client.embeddings(model="gemma2:9b", prompt=d)
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
        response = self.ollama_client.embeddings(model="gemma2:9b", prompt=prompt)
        results = self.collection.query.near_vector(near_vector=response["embedding"], limit=1)
        
        # Verificar si la consulta devuelve resultados
        if not results.objects:
            print("No results found")
            return None

        data = results.objects[0].properties['text']
        return data
    
    
if __name__ == "__main__":
    # Define los datos de prueba
    file = open("vectorBase.txt","r",encoding="utf-8")
    text = file.read().split("\n")
    vector = VectorialDB("BanorteDataBase",text)
    file.close()