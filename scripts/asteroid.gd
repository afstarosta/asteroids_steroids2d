extends RigidBody2D

var current_scale = 2
var next_asteroid_size
var MOVE_SPEED = 100
var status = 'alive'
var rng = RandomNumberGenerator.new()
onready var explosion_scene_preload = load('res://scenes/explosionEffect.tscn')
var explosion_effect

func _ready():
    self.get_node("Sprite").rotation_degrees = rng.randi_range(0, 360)
    var explosion_scene = explosion_scene_preload.instance()
    explosion_effect = explosion_scene.get_node('CPUParticles2D')
    explosion_effect.hue_variation = 0.91
    add_child(explosion_scene)
    
func init(number):
    if(number > 0):
        apply_forward_impulse()
        current_scale = number      
        self.get_node("Sprite").scale = self.get_node("Sprite").scale * (number/float(2))
        self.get_node("CollisionShape2D").scale = self.get_node("CollisionShape2D").scale * (number/float(2))
    else:  
        status = 'ded'
        queue_free()

func apply_forward_impulse():
    var direction = Vector2(1, 0).rotated(self.rotation) * MOVE_SPEED
    add_central_force(direction)
    
func get_shot():
    get_node('/root/main/gameManager').score()
    explosion_effect.restart()
    get_node('/root/main/explosion').play(0.0)
    status = 'ded'
    shatter()
      
func shatter():
    create_asteroid(1)
    create_asteroid(-1)
    get_node("VisibilityNotifier2D").disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
    queue_free()
  
func create_asteroid(position_offset):      
    var new_asteroid = duplicate()
    get_parent().call_deferred('add_child', new_asteroid)
    var angle = Vector2(cos(self.rotation), sin(self.rotation))
    
    new_asteroid.position.x += angle.y * position_offset
    new_asteroid.position.y += angle.x * position_offset
    
    new_asteroid.rotation_degrees = int(fposmod( (self.rotation_degrees + 90 * position_offset), 360))
    new_asteroid.init(current_scale - 1)

func _on_VisibilityNotifier2D_screen_exited():
    get_node("VisibilityNotifier2D").disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")

    if(status == 'alive'):
        get_parent().spawn_asteroid()
    queue_free()
