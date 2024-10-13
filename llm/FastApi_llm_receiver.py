from llm.AiResponse import AiRequests, Objective
import json

class FastApiLLMReceiver():
    def __init__(self, data : json):
        self.data = data
        self.set_model()
        
    def set_model(self):
        objective = self.data['model']
        if objective == "sample":
            self.model = AiRequests(Objective.DUMMY, "You must generate dummy data for testing. Do it in spanish")
        elif objective == "game_banorte_ai":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI, "You must give financial advice, and help the user to improve their financial knowledge. Be respectful and do not provide false/unverified information.  Do it in spanish")
        elif objective == "game_banorte_ai_question":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI_QUESTION, "Genera una pregunta para el juego, siguiendo el formato pregunta,opción1,opción2,opción3,opción4,respuesta correcta. No añadas Pregunta,opción1,opción2,opción3,opción4,respuesta correcta al inicio de la pregunta.  Do it in spanish")
        elif objective == "summary":
            self.model =  AiRequests(Objective.CONTEXT_DATA_SUMMARIZER_AND_CATEGORIZE, "You must summarize and categorize the data.  Do it in spanish")
        elif objective == 'banorte_ai':
            self.model =  AiRequests(Objective.BANORTE_ASSISTANT, "You must give financial advice, and help the user to improve their financial knowledge. Be respectful and do not provide false/unverified information.  Do it in spanish")
        else:
            self.model = None
            
    def summarize(self)->dict:
        if self.data['model'] == 'summary':
            dict_summary = {
                "response": self.model.make_prompt_with_from_json(self.data['values'])
            }
            return dict_summary
        
    def generate_questions(self)->dict:
        if self.data['model'] == 'game_banorte_ai_question':
            pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split(",")
            while(len(pregunta)<5):
                pregunta = self.model.generate_questions_with_json(self.data['information_context']).strip().split(",")
                if len(pregunta) < 5:
                    continue
                dict_pregunta = {
                    "question": pregunta[0],
                    "options": pregunta[1:5],
                    "correct_answer": pregunta[5]
                }
           
            return dict_pregunta
        
    def banortea_ai(self)->dict:
        if self.data['model'] == 'banorte_ai':
            dict_banorte_ai = {
                "response": self.model.make_prompt_with_from_json_use_context(self.data['values'])
            }
            return dict_banorte_ai
        
    def game_banorte_ai(self)->dict:
        if self.data['model'] == 'game_banorte_ai':
            dict_game_banorte_ai = {
                "response": self.model.make_prompt_with_from_json_use_context(self.data['values'])
            }
            return dict_game_banorte_ai
        
    def dummy(self)->dict:
        if self.data['model'] == 'sample':
            dict_dummy = {
                "response": self.model.make_prompt_with_from_json(self.data['values'])
            }
            return dict_dummy
