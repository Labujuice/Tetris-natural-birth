import json
import os

LEADERBOARD_FILE = "leaderboard.json"

class Leaderboard:
    def __init__(self):
        self.scores = self.load_scores()

    def load_scores(self):
        if not os.path.exists(LEADERBOARD_FILE):
            return []
        try:
            with open(LEADERBOARD_FILE, 'r') as f:
                return json.load(f)
        except:
            return []

    def save_scores(self):
        with open(LEADERBOARD_FILE, 'w') as f:
            json.dump(self.scores, f)

    def add_score(self, name, score):
        self.scores.append({'name': name, 'score': score})
        self.scores.sort(key=lambda x: x['score'], reverse=True)
        self.scores = self.scores[:10] # Keep top 10
        self.save_scores()

    def get_top_scores(self):
        return self.scores
