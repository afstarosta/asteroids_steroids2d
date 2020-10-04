extends Area2D

var THRUSTER_SPEED = 150
var TURN_SPEED = 180

var ACC = 0.05
var DEC = 0.02

var screen_size
var screen_buffer = 10

var motion = Vector2(0, 0)

var lives = 1

func _ready():
    screen_size = get_viewport_rect().size
    
func _process(delta):
    process_movement(delta)
    
func process_movement(delta):
    if(Input.is_action_pressed("ui_left")):
        turn_left(delta)
    if(Input.is_action_pressed("ui_right")):       
       turn_right(delta)
    if(Input.is_action_pressed("ui_up")):       
        move_forward(delta)
    else:
        move_break(delta)
    adjust_position()

func turn_right(delta):
    self.rotation_degrees += TURN_SPEED * delta

func turn_left(delta):
    self.rotation_degrees -= TURN_SPEED * delta    
    
func move_forward(delta):    
    var direction = Vector2(1, 0).rotated(self.rotation)
    motion = motion.linear_interpolate(direction, ACC)
    self.position += motion * THRUSTER_SPEED * delta 
    
func move_break(delta):    
    motion = motion.linear_interpolate(Vector2(0, 0), DEC)
    self.position += motion * THRUSTER_SPEED * delta 

func adjust_position():
    self.position.x = wrapf(self.position.x, -screen_buffer, screen_size.x + screen_buffer)
    self.position.y = wrapf(self.position.y, -screen_buffer, screen_size.y + screen_buffer)

func take_damage():
    lives -= 1
    get_node('/root/main/gameManager').update_lives(lives)
    if(lives) <= 0:
        get_node('/root/main/gameManager').end_game()


func _on_spaceship_body_shape_entered(_body_id, body, _body_shape, _area_shape):
    if(body.is_in_group('asteroid')):
        body.status = 'ded'
        body.queue_free()
        take_damage()
