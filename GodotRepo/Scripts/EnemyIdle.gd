extends "res://Scripts/EnemyState.gd"

@export
var move_state: EnemyState

	
func enter(previous_state: EnemyState) -> void:
	super(previous_state)
	parent.velocity.x = 0
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_input(event: InputEvent) -> EnemyState:
	#TODO FIX
	if Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_right'):
		return move_state
	return null

func process_physics(delta: float, gravity_influence: Vector2) -> EnemyState:
	#gravity needs to fall off over time
	if gravity_influence.x == 0:
		parent.velocity.x *= .95
	else:
		parent.velocity.x += gravity_influence.x
		
	var grav_to_use = gravity
	
	if gravity_influence.y != 0:
		grav_to_use = gravity_influence.y
	parent.velocity.y += grav_to_use * delta
	
	parent.move(Vector2(0,0))
	return null
