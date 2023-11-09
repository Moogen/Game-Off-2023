extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State

	
func enter(previous_state: State) -> void:
	super(previous_state)
	parent.velocity.x = 0
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_right'):
		return move_state
	return null

func process_physics(delta: float, gravity_influence: Vector2) -> State:
	#gravity needs to fall off over time
	if gravity_influence.x == 0:
		parent.velocity.x *= .95
	else:
		parent.velocity.x += gravity_influence.x
		
	var grav_to_use = gravity
	
	if gravity_influence.y != 0:
		grav_to_use = gravity_influence.y
	parent.velocity.y += grav_to_use * delta
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
