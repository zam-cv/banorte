import vertexai
import enum
from CONSTS import *

from vertexai.generative_models import (
    GenerationConfig,
    GenerativeModel,
    HarmBlockThreshold,
    HarmCategory
)

class Objective(enum.Enum):
    TRANSLATE = "You are a helpful translator."
    SUMMARIZE = "You are a helpful text summarizer."
    SENTIMENT_ANALYSIS =  "You are a helpful sentiment analyzer."
    QUESTION_ANSWERING = "You are a helpful question answerer."
    CODE_GENERATION = "You are a helpful code generator."
    TEXT_GENERATION = "You are a helpful text generator."
    FINANCIAL_TEACHER = "YOU ARE A FINANCE TEACHER"

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


if __name__ == "__main__":
    ai = AiRequests(Objective.TRANSLATE,"You must translate to spansih")
    print(ai.make_prompt("I like bagels."))