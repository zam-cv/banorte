import json
from llm.AiResponse import AiRequests, Objective

categories = ['prompt', 'category', 'information_context', 'user_context']

def generate_dummy():
    '''Generate dummy data for testing'''
    ai = AiRequests(Objective.DUMMY, "You must generate dummy data for testing")
    
    result = ai.make_prompt('''Make json data for testing folowing the format: 
                    {"prompt": "user input",
                    "category": "category",
                    "information_context" :"data to reference"
                    "user_context" : "Information about the user"}

                Separate each json with a | character
                         
                         ''').strip().split("|")
    return result


def validate_json(json_string):
    '''Validate JSON data'''
    try:
        json_data = json.loads(json_string)
        # Check if all required categories are present
        if all(category in json_data for category in categories):
            return json_data
        else:
            print(f"Invalid JSON data: {json_string}")
            return None
    except json.JSONDecodeError:
        print(f"Failed to decode JSON: {json_string}")
        return None

if __name__ == "__main__":
    ai = AiRequests(Objective.GAME_BANORTE_AI, "You must give financial advice, and help the user to improve their financial knowledge. Be respectful and do not provide false/unverified information.")
    question_ai = AiRequests(Objective.GAME_BANORTE_AI_QUESTION,"You are guiding the player through the game. You must generate questions for the game")
    for val in generate_dummy():
        print("----------")
        valid_data = validate_json(val)
        if valid_data:
            print(valid_data)
            # Uncomment the following line if you want to use the valid data with ai.make_prompt_with_from_json
            print(question_ai.generate_questions_with_json(json.dumps(valid_data)))