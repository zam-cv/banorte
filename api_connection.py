from fastapi import FastAPI,File, UploadFile
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import uvicorn
from fastapi.encoders import jsonable_encoder
from llm.FastApi_llm_receiver import FastApiLLMReceiver
import json
from fastapi.responses import JSONResponse
from achivos_proc import archivo_procesado
from vectorial_db import VectorialDB
import random



app = FastAPI()



# Define a Pydantic model for request body
class Item(BaseModel):
    '''Defines the structure for the values '''
    prompt: str
    category: str
    information_context: str
    user_context: str

class GeneralFormat(BaseModel):
    '''Defines the structure for the request body'''
    model: str
    values: Item

class Question(BaseModel):
    '''Defines the structure for the request body'''
    category: str





@app.get("/model/selection/data")
def get_web_scraping():
    '''Get the data from the web scraping'''
    llm_fast_api = FastApiLLMReceiver({"model":"summary","values":{"prompt":"web scraping"}})
    value = VectorialDB("Banorte",'')
    if value.collection_exists("Banorte",value.get_weaviate_client()):
        value = VectorialDB("Banorte","web scraping")
        result = {"response":value.query_collection("Banorte","web scraping")}
    else:
        result = llm_fast_api.summarize()
    return JSONResponse(content=result)
    


@app.post("/model/selection/questions")

def create_question(question: Question):
    '''Create a question based on the category'''
    
    temp_dict = dict(jsonable_encoder(question))
    temp_dict["model"] = "game_banorte_ai_question"
    information_context = VectorialDB("BanorteDataBase",f'Dame información de la categoría {temp_dict["category"]}')
    information_context.client.connect()
    temp_dict["information_context"] = information_context.query_collection(f'Dame información de la categoría {temp_dict["category"]}')
    information_context.client.connect()
    llm_fast_api = FastApiLLMReceiver(temp_dict)
    result = llm_fast_api.generate_questions()
    return JSONResponse(content=result)

@app.get("/model/selection/questions/situation")
def create_situation():
    '''Create a question based on the category'''
    temp_dict = {"model":"banorte_ai_question","category":"Situación"}
    
    categorias = ['Salud Financiera','Resiliencia Financiera','Educación Financiera','Situación','Inversiones','Ahorro','Crédito','Seguros','Banca Digital','Banca Móvil','Banca en Línea','Banca Personal','Banca Empresarial','Banca Corporativa','Banca de Inversión','Banca Privada','Banca Patrimonial']
    valor = random.choice(categorias)
    
    value = VectorialDB("BanorteDataBase",f'Dame información para realizar una pregunta sobre la categoría {valor}')
    value.client.connect()
    temp_dict["information_context"] = value.query_collection(f'Dame información para realizar una pregunta sobre la categoría {valor}. La información me ha de permitir plantear una situación')
    llm_fast_api = FastApiLLMReceiver(temp_dict)
    result = llm_fast_api.generate_questions()
    return JSONResponse(content=result)


@app.post("/model/selection/publish/web_scraping")
def set_web_scraping(general_format: GeneralFormat):
    '''Set the data from the web scraping'''
    general_format_json = jsonable_encoder(general_format)
    llm_fast_api = FastApiLLMReceiver(general_format_json)
    if general_format.model == 'summary':
        result = llm_fast_api.summarize()
    return JSONResponse(content=result)

# Create a new item
@app.post("/model/selection/")
def create_item(general_format: GeneralFormat):
    '''Set the model and values for the request'''
    # Convert general_format to JSON-compatible format
    temp_dict = dict(jsonable_encoder(general_format))
    print(temp_dict)
    print("---------------")
    llm_fast_api = FastApiLLMReceiver(temp_dict)
    if temp_dict['model'] == 'banorte_ai':
        values = temp_dict["values"]
        value = VectorialDB("BanorteDataBase",f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]}')
        value.client.connect()
        temp_dict["values"]["information_context"] += value.query_collection(f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]} con la información de la categoría {values["information_context"]} y de usuario {values["user_context"]} ')
        value.client.connect()
        llm_fast_api = FastApiLLMReceiver(temp_dict)
        result = llm_fast_api.banortea_ai()
            
    elif temp_dict['model'] == 'game_banorte_ai':
        values = temp_dict["values"]
        value = VectorialDB("BanorteDataBase",f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]}')
        value.client.connect()
        temp_dict["values"]["information_context"] += value.query_collection(f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]} con la información de la categoría {values["information_context"]} y de usuario {values["user_context"]} ')
        value.client.connect()
        result = llm_fast_api.game_banorte_ai()
            
    elif temp_dict['model'] == 'sample':
        values = temp_dict["values"]
        value = VectorialDB("BanorteDataBase",f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]}')
        value.client.connect()
        temp_dict["values"]["information_context"] += value.query_collection(f'Responde mi pregunta {values["prompt"]} para la categoría {values["category"]} con la información de la categoría {values["information_context"]} y de usuario {values["user_context"]} ')
        value.client.connect()
        result = llm_fast_api.dummy()
    else:
        raise HTTPException(status_code=400, detail="Invalid model")
    
    return JSONResponse(content=result)


@app.post("/archivo/")

async def upload_file(file: UploadFile = File(...)):
    '''Upload a file to the server'''
    contents = await file.read()
    processed_content = archivo_procesado(contents)
    return {"content": processed_content}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)