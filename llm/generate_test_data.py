import json
from make_request import AiRequests,Objective
categories = ['prompt', 'category', 'information_context','user_context']


def generate_dummy():
    ai = AiRequests(Objective.DUMMY, "You must generate dummy data for testing")
    print(ai.make_prompt('''Make json data for testing folowing the format: 
                         
                                 {
            "prompt": "user input",
            "category": "category",
            "information_context" :"data to reference"
            "user_context" : "Information about the user"
        }
                         
                         ''')) 
    
if __name__ == "__main__":
    generate_dummy()