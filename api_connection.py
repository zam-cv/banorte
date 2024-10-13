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


app = FastAPI()



# Define a Pydantic model for request body
class Item(BaseModel):
    prompt: str
    category: str
    information_context: str
    user_context: str

class GeneralFormat(BaseModel):
    model: str
    values: Item

class Question(BaseModel):
    category: str





@app.get("/model/selection/data")
def get_web_scraping():
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
    
    temp_dict = dict(jsonable_encoder(question))
    temp_dict["model"] = "game_banorte_ai_question"
    information_context = VectorialDB("BanorteDataBase",f'Dame información de la categoría {temp_dict["category"]}')
    information_context.client.connect()
    temp_dict["information_context"] = information_context.query_collection(f'Dame información de la categoría {temp_dict["category"]}')
    information_context.client.connect()
    llm_fast_api = FastApiLLMReceiver(temp_dict)
    result = llm_fast_api.generate_questions()
    return JSONResponse(content=result)


@app.post("/model/selection/publish/web_scraping")
def set_web_scraping(general_format: GeneralFormat):
    general_format_json = jsonable_encoder(general_format)
    llm_fast_api = FastApiLLMReceiver(general_format_json)
    if general_format.model == 'summary':
        result = llm_fast_api.summarize()
    return JSONResponse(content=result)

# Create a new item
@app.post("/model/selection/")
def create_item(general_format: GeneralFormat):
    # Convert general_format to JSON-compatible format
    general_format_json = jsonable_encoder(general_format)
    
    llm_fast_api = FastApiLLMReceiver(general_format_json)
    if general_format.model == 'banorte_ai':
        value = VectorialDB("BanorteAI999999", llm_fast_api.banortea_ai())
        value.client.connect()
        result = llm_fast_api.banortea_ai()
            
    elif general_format.model == 'game_banorte_ai':
        value = VectorialDB("GameBanorteAI",general_format.values)
        value.client.connect()
        if value.collection_exists("GameBanorteAI"):
            value = VectorialDB("GameBanorteAI",general_format.values)
            result = {"response":value.query_collection("GameBanorteAI",general_format.values.prompt)}
        else:
            result = llm_fast_api.game_banorte_ai()
            
    elif general_format.model == 'sample':
        value = VectorialDB("Sample",general_format.values)
        value.client.connect()
        if value.collection_exists("Sample"):
            value = VectorialDB("Sample",general_format.values)
            result = {"response":value.query_collection("Sample",general_format.values.prompt)}
        else:
            result = llm_fast_api.dummy()
    else:
        raise HTTPException(status_code=400, detail="Invalid model")
    
    return JSONResponse(content=result)

# Update an item
@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_id": item_id, "item": item}

# Delete an item
@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    return {"message": f"Item {item_id} deleted"}

@app.post("/archivo/")
async def upload_file(file: UploadFile = File(...)):
    contents = await file.read()
    processed_content = archivo_procesado(contents)
    return {"content": processed_content}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)