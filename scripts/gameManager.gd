extends Node2D

var current_score = 0

onready var spaceship_scene = load('res://scenes/spaceship.tscn')
onready var asteroid_spawner_scene = load('res://scenes/asteroid_spawner.tscn')
onready var game_ui_scene = load('res://scenes/game_ui.tscn')
onready var start_screen_scene = load('res://scenes/game_start_scene.tscn')
onready var end_screen_scene = load('res://scenes/game_end_scene.tscn')

var spaceship
var asteroid_spawner
var game_ui
var is_game_running = false
var start_screen
var end_screen

func _ready():
    start_screen = start_screen_scene.instance()
    get_parent().call_deferred("add_child", start_screen)

func _process(_delta):
    if(!is_game_running):
        if(Input.is_action_just_pressed("ui_fire")):
            is_game_running = true
            start_game()

func score():
    current_score += 1
    game_ui.update_score(current_score)

func update_lives(lives):
    game_ui.update_lives(lives)

func end_game():
    spaceship.queue_free()
    yield(get_tree().create_timer(3),"timeout")
    is_game_running = false
    asteroid_spawner.queue_free()
    game_ui.queue_free()
    
    end_screen = end_screen_scene.instance()
    get_parent().add_child(end_screen)
    end_screen.set_score_text(current_score)

func start_game():
    is_game_running = true
    var screen_size = get_viewport_rect().size
    spaceship = spaceship_scene.instance()
    get_parent().add_child(spaceship)
    spaceship.position = screen_size / 2
    asteroid_spawner = asteroid_spawner_scene.instance()
    get_parent().add_child(asteroid_spawner)
    game_ui = game_ui_scene.instance()
    get_parent().add_child(game_ui)

    if(is_instance_valid(start_screen)):
        start_screen.queue_free()
    
    if(is_instance_valid(end_screen)):
        end_screen.queue_free()

    game_ui.update_score(0)
    current_score = 0
    game_ui.update_lives(5)
    
