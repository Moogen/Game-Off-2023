extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
    
    self.connect("body_exited", self._on_body_exited)
    self.connect("body_entered", self._on_body_entered)
    
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_body_entered(body : PhysicsBody2D) -> void:
    if body is Player:
        body.set_grav(false)
    pass

    
func _on_body_exited(body : PhysicsBody2D) -> void:
    if body is Player:
        body.set_grav(true)
    pass
