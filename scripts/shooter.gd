extends Node2D
var rng = RandomNumberGenerator.new()

var shooting_modes = ['FULL_AUTO','SINGLE', 'MULTI_SHOT']
var mode_index = 0
var shooting_function

onready var bullet_scene = load('res://scenes/bullet.tscn')

var timer

func _ready():
    timer = 0
    set_mode('FULL_AUTO')
    
func set_mode(mode):
    if mode == 'SINGLE':
        shooting_function = 'single_shot'
    if mode == 'FULL_AUTO':
        shooting_function = 'full_auto_shot'      
    if mode == 'MULTI_SHOT':
        shooting_function = 'multi_shot'

func _process(delta):
    call(shooting_function)
    cicle_modes()
    timer += 1 * delta
       
func cicle_modes():
    if(Input.is_action_just_pressed("ui_accept")):
        mode_index = (mode_index + 1) % shooting_modes.size()
        set_mode(shooting_modes[mode_index])
        
func fire(inacuracy=0):
    timer = 0
    var bullet = bullet_scene.instance()
    get_tree().root.get_child(0).add_child(bullet)
    bullet.rotation = self.global_rotation
    if(inacuracy):
        bullet.rotation_degrees += rng.randi_range(-inacuracy, inacuracy)
    bullet.position = self.global_position
    get_node('/root/main/shooting').play(0.0)
    
func single_shot():
    if is_fire_pressed_and_timer(0.1):
        fire()
        
func full_auto_shot():
    if is_fire_held_and_timer(0.1):
        fire(4)

func multi_shot():
    if is_fire_held_and_timer(0.5):
        fire(3)
        fire(3)
        fire(3)
        fire(3)
        fire(3)

func is_fire_pressed_and_timer(timer_limit):
    return Input.is_action_just_pressed("ui_fire") and timer >= timer_limit

func is_fire_held_and_timer(timer_limit):
    return Input.is_action_pressed("ui_fire") and timer >= timer_limit
