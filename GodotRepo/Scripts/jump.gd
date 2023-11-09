extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State

@export
var jump_force: float = 900.0



func enter(previous_state: State) -> void:
	
	super(previous_state)
	parent.velocity.y = -jump_force
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_physics(delta: float, gravity_influence: Vector2) -> State:
	#gravity needs to fall off over time
	if gravity_influence.x == 0:
		parent.velocity.x *= .9
	else:
		parent.velocity.x += gravity_influence.x
	
	var grav_to_use = gravity
	
	if gravity_influence.y != 0:
		grav_to_use = gravity_influence.y
	parent.velocity.y += grav_to_use * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement > 0
	parent.velocity.x = movement
	
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
