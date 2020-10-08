extends Node2D

onready var spaceship_sprite = load('res://scenes/spaceship_sprite.tscn')
var sprites = []
var offset = 10

func _ready():
    for i in range(0, 5):
        var sprite = spaceship_sprite.instance()
        print()
        sprite.position.x = (i * sprite.texture.get_size().x) + offset
        add_child(sprite)
        sprites.append(sprite)
           
func pop_one_life():
    var life = sprites.pop_back()
    if(life):
        life.queue_free()
