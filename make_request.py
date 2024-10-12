import vertexai
import enum
import json
from CONSTS import *

from vertexai.generative_models import (
    GenerationConfig,
    GenerativeModel,
    HarmBlockThreshold,
    HarmCategory
)

class Objective(enum.Enum):
    
    BANORTE_ASSISTANT = '''Eres un asistente virtual de Banorte especializado en educación financiera.",
    
        "Tu misión es ayudar a los usuarios a aprender sobre finanzas personales a través de juegos interactivos.",
        
        "Proporciona respuestas claras y útiles sobre conceptos financieros, estrategias de ahorro, inversión y manejo de deudas.",
        
        "Asegúrate de que las explicaciones sean fáciles de entender y atractivas para los usuarios.",
        
        "Los usuarios podrán ser de todas las edades",
        
        "Es importante ayudar al usuario seguir aprendiendo sobre la educación financiera y dar nuevos conocimientos al usuario.
        
        Vas a recibir un JSON con la siguiente estructura:
        {
            "prompt": "user input",
            "category": "category",
            "information_context" :"data to reference"
            "user_context" : "Information about the user"
        }
        
        prompt: Es la pregunta que el usuario hace
        category: Es la categoria de la pregunta, debes responder enfocandote en esta categoria
        information_context: Es la informacion que debes de referenciar para responder la pregunta
        user_context: Es la informacion del usuario que haz de utilizar para dar una respuesta personalizada

        '''
        

class AiRequests():
    
    def __init__(self,objective : Objective,what_should_i_do : str) -> None:
        vertexai.init(project=PROJECT_ID, location=LOCATION)
        
        self.model =  GenerativeModel(
            MODEL_ID,
            system_instruction=[
                objective.value,
                what_should_i_do,
                ],
            )
        self.generation_config = GenerationConfig(
            temperature=0.9,
            top_p=1.0,
            top_k=32,
            candidate_count=1,
            max_output_tokens=8192,
        )
        self.safety_settings = {
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_LOW_AND_ABOVE,
        }
        self.contents = []
        
    def make_prompt(self,prompt : str)->str:
        prompt :str = f"""
                User input: {prompt}.
                Answer:
                """
        self.contents.append(prompt)
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        return response.text
    
    def make_prompt_with_context(self,prompt:str,context:str)->str:
        prompt :str = f"""
                User input: {prompt}.
                Answer:
                """
        self.contents.append(context)
        self.contents.append(prompt)
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        return response.text 
    
    def make_prompt_with_from_json(self, context:json)->str:
        data = json.loads(context)
        
        detailed_prompt = f"User input: {data["prompt"]}.\nContext:\n"
        
        for key, value in data.items():
            detailed_prompt += f"{key}: {value}\n"
            
        detailed_prompt += "Answer:"
        
        self.contents.append(detailed_prompt)
        
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        return response.text 


if __name__ == "__main__":
    ai = AiRequests(Objective.BANORTE_ASSISTANT,"You must translate to spansih")
    # Example JSON context
    json_context = json.dumps(
        {
        "prompt": "¿Por qué es importante manejar bien mis finanzas?",
        "category": "Financial Health",
        "information_context": '''
        Según Banorte, la salud financiera se refiere a la capacidad de una persona para administrar sus finanzas de manera efectiva, asegurando su bienestar económico a corto y largo plazo. Esto incluye la planificación del presupuesto, el ahorro, la inversión y la gestión de deudas1
. Banorte ofrece diversos productos y servicios financieros diseñados para ayudar a sus clientes a mejorar su salud financiera, como cuentas de ahorro, préstamos, seguros y asesoría financiera personalizada1
.

Servicios de Banorte
Cuentas de Ahorro: Ofrecen diferentes tipos de cuentas de ahorro con tasas de interés competitivas.

Préstamos: Incluyen préstamos personales, hipotecas y préstamos comerciales.

Seguros: Banorte ofrece una variedad de seguros, como seguros de vida, salud y hogar.

Asesoría Financiera: Servicios personalizados para ayudar a los clientes a planificar y alcanzar sus objetivos financieros.

Tarjetas de Crédito: Diferentes opciones de tarjetas de crédito con beneficios y recompensas.


        
        ''',
        "user_context": "El usuario eduardo Chavez tiene 25 años y esta interesado en aprender sobre finanzas personales"
    }
    )
    
    print(ai.make_prompt_with_from_json(json_context))