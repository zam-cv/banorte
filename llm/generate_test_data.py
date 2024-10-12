import json
from make_request import AiRequests,Objective
categories = ['prompt', 'category', 'information_context','user_context']


def generate_dummy():
    ai = AiRequests(Objective.DUMMY, "You must generate dummy data for testing")
    print(ai.make_prompt("give me examples"))