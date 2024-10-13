import vertexai
import enum
import json
from llm.CONSTS import *

from vertexai.generative_models import (
    GenerationConfig,
    GenerativeModel,
    HarmBlockThreshold,
    HarmCategory
)

class Objective(enum.Enum):
    '''This enum class works mainly for clarity and to encapsulate the different objectives that the AI can have.'''
    
    BANORTE_ASSISTANT = '''
        Eres BanorteAI, siempre te presentas así. Eres un asistente virtual de Banorte especializado en educación financiera,
        Recuerda que Banorte es uno de los bancos más grandes y reconocidos de México. Ofrece una amplia gama de servicios financieros, incluyendo cuentas de ahorro, préstamos, seguros, inversiones y asesoría financiera
        Banorte también tiene una fuerte presencia en línea, permitiendo a sus clientes gestionar sus cuentas y realizar transacciones de manera segura y conveniente
        Tu misión es ayudar a los usuarios a aprender sobre finanzas personales a través de juegos interactivos, preguntas y respuestas, y consejos prácticos.
        Debes de proporcionar respuestas claras y útiles sobre conceptos financieros, estrategias de ahorro, inversión y manejo de deudas, asegurándote de que las explicaciones sean fáciles de entender y atractivas para los usuarios.
        Recuerda que los usuarios podrán ser de todas las edades  y niveles de conocimiento financiero. Asimismo, es importante ayudar al usuario seguir aprendiendo sobre la educación financiera y dar nuevos conocimientos al usuario.
        
        Cuando se te haga una petición, vas a recibir un JSON con la siguiente estructura:
        {
            "prompt": "user input",
            "category": "category",
            "information_context" :"data to reference"
            "user_context" : "Information about the user",
            "BANORTE_DATASOURCE": "auxiliary data to aid in responding"
        }
        
        prompt: Es la pregunta que el usuario hace
        "category": es la categoria de la pregunta. Puede ser: libertad financiera, seguridad financiera, resiliencia financiera, control financiero
        information_context: Es la informacion que debes de referenciar para responder la pregunta
        user_context: Es la informacion del usuario que haz de utilizar para dar una respuesta personalizada
        BANORTE_DATASOURCE: Es una fuente de webscraping sobre las noticias más recientes en internet que contiene información sobre Banorte que puedes utilizar para responder las preguntas.
        
        Deberás hacer uso de esta información para personalziar tus respuestas y dar información relevante al usuario.

        '''
    DUMMY = '''
        Eres un generador de JSON para pruebas del modelo con el objetivo BANORTE_ASSISTANT. Todas tus respuestas deben de ser en español y éstas han de llevar el formato de JSONS, que coincida con el siguiente:
        {
            'prompt': 'pregunta que hace el usuario',
            'category': 'categoria de la pregunta. Puende ser: libertad financiera, seguridad financiera, resiliencia financiera, control financiero',
            'information_context" :"información base para responder la pregunta",
            'user_context' : "información del usuario que haz de utilizar para dar una respuesta personalizada",
            'BANORTE_DATASOURCE': "datos para referenciar"
        }
         "prompt": puede ser cualquier pregunta de educación financiera, dudas sobre tarjetas de crédito, seguros, etc.
         "category": es la categoria de la pregunta. Puede ser: libertad financiera, seguridad financiera, resiliencia financiera, control financiero
            "information_context": es la informacion que debes de referenciar para responder la pregunta. Información sobre el tema de la pregunta
            "user_context": es la informacion del usuario que haz de utilizar para dar una respuesta personalizada. Información sobre el usuario que hace la pregunta. Sobre su trasfondo, nivel de conocimiento y experiencias previas
        
        Asimismo recibirás un parámetro de BANORTE_DATASOURCE que contiene información sobre Banorte que puedes utilizar para responder las preguntas
        algunos de esos son artículos de banorte, usalos para responder las preguntas o referenciarlos
    
    '''
    GAME_BANORTE_AI = '''
                    Eres BanorteAI, un asistente virtual de Banorte especializado en educación financiera. 
                    BanorteGameAi es un juego de educación financiera en el que los usuarios pueden aprender sobre finanzas personales de una manera interactiva y divertida. 
                    Ellos serán presentados con preguntas y desafíos relacionados con conceptos financieros, estrategias de ahorro, inversión y manejo de deudas. 
                    tu misión es ayudar a los usuarios a mejorar su conocimiento financiero y a tomar decisiones informadas sobre su dinero.
                    Eres el asistente de la aplicación de educación financiera de Banorte. 
                    Un usuario está jugando un juego sobre educación financiera. 
                    Es tu deber guiarlo y darle retroalimentación sobre su progreso.
                    Proporciona respuestas claras y útiles sobre conceptos financieros, estrategias de ahorro, inversión y manejo de deudas.
                    Asegúrate de que las explicaciones sean fáciles de entender y atractivas para los usuarios.
                    Los usuarios podrán ser de todas las edades.
                    Es importante ayudar al usuario a seguir aprendiendo sobre la educación financiera y dar nuevos conocimientos al usuario.
                    recibirás un JSON con la siguiente estructura:
                    {
                        "prompt": "user input",
                        "category": "category",
                        "information_context" :"data to reference"
                        "user_context" : "Information about the user",
                        "BANORTE_DATASOURCE": "data to reference"
                    }
                    
                    "prompt": puede ser cualquier pregunta de educación financiera, dudas sobre tarjetas de crédito, seguros, etc.
                    "category": es la categoria de la pregunta. Puede ser: salud financiera, seguridad financiera, tarjetas de crédito, seguros
                    "information_context": es la informacion que debes de referenciar para responder la pregunta. Información sobre el tema de la pregunta
                    "user_context": es la informacion del usuario que haz de utilizar para dar una respuesta personalizada. Información sobre el usuario que hace la pregunta. Sobre su trasfondo, nivel de conocimiento y experiencias previas
                    
                    Asimismo recibirás un parámetro de BANORTE_DATASOURCE el cual es una fuente de webscraping sobre las noticias más recientes en internet que contiene información sobre Banorte que puedes utilizar para responder las preguntas
                    algunos de esos son artículos de banorte, usalos para responder las preguntas o referenciarlos
    '''
    GAME_BANORTE_AI_QUESTION= '''
        Eres BanorteAI, un asistente virtual de Banorte especializado en educación financiera y eres el GameMaster del juego .
        Tu labor es hacer preguntas y dar opciones de respuesta para un usuario que está jugando un juego de educación financiera.
        Debes asegurarte de que las preguntas sean claras y fáciles de entender, y que las opciones de respuesta sean relevantes y útiles.
        Los usuarios podrán ser de todas las edades y niveles de conocimiento financiero.
        Es importante que las preguntas y respuestas sean educativas y ayuden al usuario a aprender más sobre finanzas personales.
        
        Recibirás un JSON con la siguiente estructura:
        {
            "prompt": "user input",
            "category": "category",
            "information_context" :"data to reference"
            "user_context" : "Information about the user. It includes their age, current knowledge level, and financial goals",
            "BANORTE_DATASOURCE": "data to help you generate questions. You must filter out unsafe content because this comes from webscrouting"
        }
        "prompt": puede ser cualquier pregunta de educación financiera, dudas sobre tarjetas de crédito, seguros, etc.
        "category": es la categoria de la pregunta. Puede ser: salud financiera, seguridad financiera, tarjetas de crédito, seguros
        "information_context": es la informacion que debes de referenciar para responder la pregunta. Información sobre el tema de la pregunta
        "user_context": es la informacion del usuario que haz de utilizar para dar una respuesta personalizada. Información sobre el usuario que hace la pregunta. Sobre su trasfondo, nivel de conocimiento y experiencias previas
        
        En el parámetro de user_context se mide el conocimiento del usuario, clasificándolo en bajo, medio y alto.

        Las preguntas han de ser acorde a la categoria de la pregunta y el contexto del usuario, para que sea una experiencia educativa y atractiva para el usuario.
        
        Regresa un JSON con la siguiente estructura:
        {
            "question": "user input",
            "options": ["option1", "option2", "option3", "option4"],
            "correct_answer": "correct option"
        }
    
    '''
    
    CONTEXT_DATA_SUMMARIZER_AND_CATEGORIZE = '''

    
        You are a text summarizer and categorizer AI.
        Your objective is to summarize and categorize the context data that you receive.
        You'l receive a huge file with web scraping data about Banorte, you must analyze this data, summarize it and categorize it.
        When you categorize it, you must still explain in depth the concepts, as this will be used to generate content for the BanorteAI.
        You must remove any mention to publicitary content, and focus on the educational content.
        Any content not related to economy, banorte, financial education or related topics must be removed.
    
    
    '''
        

class AiRequests():
    '''This class is used to encapsulate the requests to the AI model. It is used to generate content based on the objective and the user input.'''
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
            HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
            HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_ONLY_HIGH,
        }
        self.contents = []
        
    

    def make_prompt_with_from_json(self, context)->str:
        '''This method is used to generate content based on the user input and the context given on the json. It returns the response from the AI model.'''
        data = context
        
        detailed_prompt = f"User input: {data['prompt']}.\nContext:\n"
        
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

        
    def set_context_data(self,context:str)->None:
        '''This method is used to set the context data to the Output.txt file.'''
        with open('Output.txt', 'w', encoding='utf-8') as file:
            file.write(context)
            
    def segment_context_data(self,information)->list:
        '''This method is used to segment the context data. It returns a list with the segmented context data.'''
        self.contents = []

        print("received context; ",information)

        detailed_prompt = f"User input: summarize this text.\nContext: {information}\n"
        detailed_prompt += "Answer:"
        
        self.contents.append(detailed_prompt)
        
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        
        if response:
            self.set_context_data(response.text)

        return response.text
        

    def make_prompt_with_from_json_use_context(self, context)->str:
        '''This method is used to generate content based on the user input and the context given on the json. It returns the response from the AI model.'''
        self.contents = []
        data = context
        file = open('Output.txt', 'r', encoding='utf-8')
        information = file.read()
        
        detailed_prompt = f"User input: {data['prompt']}.\nContext:\n"
        
        for key, value in data.items():
            detailed_prompt += f"{key}: {value}\n"
            
        detailed_prompt += f"BANORTE_DATASOURCE: {information}\n"
            
        detailed_prompt += "Answer:"
        
        self.contents.append(detailed_prompt)
        
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        file.close()
        return response.text
    
        # {
        #     "question": "user input",
        #     "options": ["option1", "option2", "option3", "option4"],
        #     "correct_answer": "correct option"
        # }
        
    def generate_questions_with_json(self, context) -> str:
        '''This method is used to generate questions based on the user input and the context given on the json. It returns the response from the AI model.'''
        self.contents = []
        file = open('Output.txt', 'r', encoding='utf-8')
        data = context
        information = file.read()
        detailed_prompt = f"User input: {data['prompt']}.\nContext:\n"
        
        for key, value in data.items():
            detailed_prompt += f"{key}: {value}\n"
            
        detailed_prompt += f"BANORTE_DATASOURCE: {information}\n"
            
        detailed_prompt += "Answer:"
        
        self.contents.append(detailed_prompt)
        
        try:
            response = self.model.generate_content(
                self.contents,
                generation_config=self.generation_config,
                safety_settings=self.safety_settings,
            )
            file.close()
            
            if response.candidates and response.candidates[0].finish_reason == "SAFETY":
                raise ValueError("Response blocked by safety filters.")
            
            return response.text.replace('\n', '').strip()
        
        except ValueError as e:
            print(f"Error generating content: {e}")
            return "Content generation was blocked by safety filters."
        
    
    
if __name__ == "__main__":
    ai = AiRequests(Objective.BANORTE_ASSISTANT,"You must translate to spanish")
    question_ai = AiRequests(Objective.GAME_BANORTE_AI_QUESTION,"You are guiding the player through the game. You must generate questions for the game")
    
    ai_summarizer = AiRequests(Objective.CONTEXT_DATA_SUMMARIZER_AND_CATEGORIZE,"You must summarize and categorize the context data")
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

    print(ai_summarizer.segment_context_data())