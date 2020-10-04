extends Area2D
    
var SPEED = 600

func _process(delta):
    move_forward(delta)
    
func move_forward(delta):    
    var direction = Vector2(1, 0).rotated(self.rotation)
    self.position += direction * SPEED * delta 


func _on_bullet_body_entered(body):    
    if body.is_in_group('shootable'):
        body.get_shot()
        queue_free()

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
