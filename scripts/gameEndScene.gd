extends Node2D

func set_score_text(score):
    get_node("scoreText").text = 'Final score: ' + str(score)
