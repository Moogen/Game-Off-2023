extends "res://Scripts/InteractableOutput.gd"
#Inherits from the interactable class

enum State {
	Closed,
	Open
}

var current_state = State.Open
@export var activated_animation : String = "Open"
@export var collision_shape : CollisionShape2D

func _activate():
	current_state = State.Open
	collision_shape.disabled = true
	update_anim()
	pass
	
func _deactivate():
	current_state = State.Closed
	collision_shape.disabled = false
	update_anim()
	pass
	
func update_anim() -> void:
	if(current_state == State.Closed):
		animations.play(animation_name)
	else:
		animations.play(activated_animation)
	pass	

