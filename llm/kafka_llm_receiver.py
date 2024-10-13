from AiResponse import AiRequests, Objective
import json


class KafkaLLMReceiver():
    def __init__(self, data):
        self.data = data
        self.set_model()
        
        

    def set_model(self):
        objective = self.data['model']
        if objective == "sample":
            self.model = AiRequests(Objective.DUMMY, "You must generate dummy data for testing")
        elif objective == "game_banorte_ai":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI, "You must give financial advice, and help the user to improve their financial knowledge. Be respectful and do not provide false/unverified information.")
        elif objective == "game_banorte_ai_question":
            self.model =  AiRequests(Objective.GAME_BANORTE_AI_QUESTION, "You are guiding the player through the game. You must generate questions for the game")
        elif objective == "summary":
            self.model =  AiRequests(Objective.CONTEXT_DATA_SUMMARIZER_AND_CATEGORIZE, "You must summarize and categorize the data")
        elif objective == 'banorte_ai':
            self.model =  AiRequests(Objective.BANORTE_ASSISTANT, "You must give financial advice, and help the user to improve their financial knowledge. Be respectful and do not provide false/unverified information.")
        else:
            self.model = None
            
    def summarize(self):
        if self.data['model'] == 'summary':
            return self.model.segment_context_data()
        
    def generate_questions(self):
        if self.data['model'] == 'game_banorte_ai_question':
            return self.model.generate_questions_with_json(self.data['values'])
        
    def banortea_ai(self):
        if self.data['model'] == 'banorte_ai':
            return self.model.make_prompt_with_from_json_use_context(self.data['values'])
        
    def game_banorte_ai(self):
        if self.data['model'] == 'game_banorte_ai':
            return self.model.make_prompt_with_from_json_use_context(self.data['values'])
        
    def dummy(self):
        if self.data['model'] == 'sample':
            return self.model.make_prompt_with_from_json(self.data['values'])



    
