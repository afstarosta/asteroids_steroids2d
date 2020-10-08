extends Node2D

func update_score(score):
    get_node('scoreText').text = str(score) + 'pts'

func update_lives(lives):
    get_node('lives').pop_one_life()
