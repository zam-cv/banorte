import vertexai
import enum
from CONSTS import *


class Objective(enum):
    TRANSLATE = 1
    SUMMARIZE = 2
    SENTIMENT_ANALYSIS = 3
    QUESTION_ANSWERING = 4
    CODE_GENERATION = 5

from vertexai.generative_models import (
    GenerationConfig,
    GenerativeModel,
    HarmBlockThreshold,
    HarmCategory
)

vertexai.init(project=PROJECT_ID, location=LOCATION)


def whoami(objective : Objective)->str:
    
    if objective==Objective.TRANSLATE:
        return "You are a helpful text summarizer."
    elif objective==Objective.SUMMARIZE:
        return "You are a helpful text summarizer."
    elif objective==Objective.SENTIMENT_ANALYSIS:
        return "You are a helpful sentiment analyzer."
    elif objective==Objective.QUESTION_ANSWERING:
        return "You are a helpful question answerer."
    elif objective==Objective.CODE_GENERATION:
        return "You are a helpful code generator."
    else:
        return "You are a helpful language translator."
        
def create_model(objective : Objective, prompt : str):
    return GenerativeModel(
    MODEL_ID,
    system_instruction=[
        whoami(objective),
        prompt,
    ],
)
    
    
    
