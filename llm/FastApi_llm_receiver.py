from llm.AiResponse import AiRequests, Objective
import json

class FastApiLLMReceiver():
    '''Clase que recibe la información de la API y la procesa para enviarla al modelo de LLM'''
    def __init__(self, data : json):
        self.data = data
        self.set_model()
    
    def set_model(self):
        '''Set the AI model configuration  to use'''
        objective = self.data['model']
        if objective == "sample":
            self.model = AiRequests(Objective.DUMMY, "You must generate dummy data for testing. Do it in spanish")
        elif objective == "game_banorte_ai":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI, "Debes de dar consejos financieros y responder preguntas del usuario, debes ayudarlos a mejorar su nivel de conocimiento. Se respetuoso y no proporciones información falsa/no verificada.  Do it in spanish")
        elif objective == "game_banorte_ai_question":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI_QUESTION, "Genera una pregunta para el juego, siguiendo el formato pregunta,opción1,opción2,opción3,opción4,respuesta correcta. SIEMPTE GENERA 6 VALORES. No añadas Pregunta,opción1,opción2,opción3,opción4,respuesta correcta al inicio de la pregunta.  Do it in spanish")
        elif objective == "summary":
            self.model =  AiRequests(Objective.CONTEXT_DATA_SUMMARIZER_AND_CATEGORIZE, "Tu trabajo es resumir contenido y sintetizarlo, enfocándote en los puntos más importantes. ")
        elif objective == 'banorte_ai':
            self.model =  AiRequests(Objective.BANORTE_ASSISTANT, "Debes de dar asesoría financiera. Debes de responder preguntas de manera personalizada, siempre adaptandote al concepto. No des información falsa.")
        elif objective == 'banorte_ai_question':
            self.model = AiRequests(Objective.OPEN_QUESTION_EXAMINATION, "Genera una pregunta para el juego, que se trata de una situación práctica en el que el usario deba de responder. Todas las opciones deben de estar aplicadas a la situación. Debes de darle 4 opciones.  Debes de seguir el formato pregunta | opción1 | opción2 | opción3 | opción4 |respuesta correcta. SIEMPTE GENERA 6 VALORES 1. La pregunta. 2. opción1 | opción2 | opción3 | opción4, 3 la respuesta correcta. No añadas Pregunta,opción1,opción2,opción3,opción4,respuesta correcta al inicio de la pregunta.  Do it in spanish")
        else:
            self.model = None
            
    def summarize(self)->dict:
        '''Summarize the information'''
        if self.data['model'] == 'summary':
            dict_summary = {
                "response": self.model.make_prompt_with_from_json(self.data['values'])
            }
            return dict_summary
        
    def generate_questions(self)->dict:
        '''Generate questions for the game'''
        if self.data['model'] == 'game_banorte_ai_question':
            pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split(",")

            while(len(pregunta)<5):
                pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split(",")
                if len(pregunta) < 5:
                    continue
                else: 
                    break
            dict_pregunta = {
                "question": pregunta[0],
                "options": pregunta[1:5],
                "correct_answer": pregunta[5]
            }

        elif self.data['model'] == 'banorte_ai_question':
            pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split("|")
            print(pregunta)
            while(len(pregunta)<5):
                pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split(",")
                if len(pregunta) < 5:
                    continue
                else:
                    break
            dict_pregunta = {
                "question": pregunta[0],
                "options": pregunta[1:5],
                "correct_answer": pregunta[5]
            }
           
            print(pregunta)
        return dict_pregunta
        
    def banortea_ai(self)->dict:
        '''Generate the response for the user'''
        if self.data['model'] == 'banorte_ai':
            dict_banorte_ai = {
                "response": self.model.make_prompt_with_from_json_use_context(self.data['values'])
            }
            return dict_banorte_ai
        
    def game_banorte_ai(self)->dict:
        '''Generate the response for the game'''
        if self.data['model'] == 'game_banorte_ai':
            dict_game_banorte_ai = {
                "response": self.model.make_prompt_with_from_json_use_context(self.data['values'])
            }
            return dict_game_banorte_ai
        
    def dummy(self)->dict:
        '''Generate dummy data for testing'''
        if self.data['model'] == 'sample':
            dict_dummy = {
                "response": self.model.make_prompt_with_from_json(self.data['values'])
            }
            return dict_dummy
