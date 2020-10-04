extends Node2D

func update_score(score):
    get_node('scoreText').text = 'score' + str(score)

func update_lives(lives):
    get_node('livesText').text = 'lives\n' + str(lives)
