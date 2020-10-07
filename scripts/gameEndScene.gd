extends Node2D

func _ready():
    var screen_size = get_viewport_rect().size
    for children in self.get_children():
        children.rect_position.x = screen_size.x / 2


func set_score_text(score):
    get_node("scoreText").text = 'Final score: ' + str(score)
