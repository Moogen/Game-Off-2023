extends Sprite2D

# Rotation speed in radians per second
var rotation_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):
    rotation += rotation_speed * delta
    pass
