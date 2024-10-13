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

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to FastAPI!"}

# Read item by ID
@app.get("/model/selection/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}

# Create a new item
@app.post("/model/selection/")
def create_item(general_format: GeneralFormat):
    # Convert general_format to JSON-compatible format
    general_format_json = jsonable_encoder(general_format)
    
    llm_fast_api = FastApiLLMReceiver(general_format_json)
    if general_format.model == 'summary':
        result = llm_fast_api.summarize()
    elif general_format.model == 'game_banorte_ai_question':
        result = llm_fast_api.generate_questions()
    elif general_format.model == 'banorte_ai':
        result = llm_fast_api.banortea_ai()
    elif general_format.model == 'game_banorte_ai':
        result = llm_fast_api.game_banorte_ai()
    elif general_format.model == 'sample':
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