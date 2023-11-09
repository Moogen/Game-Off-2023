extends RigidBody2D

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	#apply_force(velocity)
	pass

func set_velocity(sped: Vector2):
	apply_force(sped)
	velocity = sped
