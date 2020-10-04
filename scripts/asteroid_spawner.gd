extends Node2D
var rng = RandomNumberGenerator.new()
onready var asteroid_scene = load('res://scenes/asteroid.tscn')
var cooldown = 0
var spawn_cooldown = 10

var screen_size

func _ready():
    screen_size = get_viewport_rect().size
    spawn_asteroid()
    
func _process(delta):
    spawn_cooldown = adjust_difficulty()
    cooldown += 1 * delta
    if(cooldown > spawn_cooldown):
        cooldown = 0
        spawn_asteroid()
    
func adjust_difficulty():
    var score = get_node('/root/main/gameManager').current_score
    return 0.5 + (4.5 * (100 - score)/100)
    
    
func spawn_asteroid():
    var point = random_points()
    var new_asteroid = asteroid_scene.instance()
    var player = get_parent().get_node_or_null("spaceship")
    if(is_instance_valid(player)) :
        var player_position = player.global_position
        add_child(new_asteroid)
        new_asteroid.position = point
        new_asteroid.look_at(player_position)
        new_asteroid.rotation_degrees += rng.randi_range(-15, 15)
        new_asteroid.init(2)

func random_points():
    var point = Vector2(rng.randi_range(0, screen_size.x), rng.randi_range(0, screen_size.y))
    
    var rand1 = rng.randf() 
    var rand2 = rng.randf()
    if rand1 >= 0.5:
        if rand2 >= 0.5:
            point.x = -100
        else:
            point.x = screen_size.x + 100
    else:
        if rand2 >= 0.5:
            point.y = -100
        else:
            point.y = screen_size.y + 100

    return point
