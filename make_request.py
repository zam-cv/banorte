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
    
    BANORTE_ASSISTANT = "You are a helpful Banorte assistant. "
    

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
    
    def make_prompt_with_from_json(self,prompt:str, context:json)->str:
        prompt :str = f"""
                User input: {prompt}.
                Answer:
                """
        data = json.loads(context)
        category = data["category"]
        document = data["document"]
        history : list[str] = data["history"]
        
        self.contents.append(category)
        self.contents.append(document)
        self.contents.append(history)
        
        self.contents.append(prompt)
        response = self.model.generate_content(
            self.contents,
            generation_config=self.generation_config,
            safety_settings=self.safety_settings,
            )
        return response.text 


if __name__ == "__main__":
    ai = AiRequests(Objective.BANORTE_ASSISTANT,"You must translate to spansih")
    #print(ai.make_prompt("I like bagels."))
    print(ai.make_prompt_with_context("What is financial health","Financial health is about the overall state of your personal finances. It includes having a balanced budget, a manageable level of debt, a good credit score, and an emergency fund. It also involves planning for the future through savings and investments, ensuring you can meet both your short-term and long-term financial goals. Maintaining good financial health means regularly reviewing and managing your finances to keep everything in check. It's like a fitness plan but for your money!"))