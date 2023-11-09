extends "res://Scripts/EnemyState.gd"

@export
var idle_state: EnemyState
@export
var move_state: EnemyState

@export
var coyote_time : float = 0.2
@export
var gravity_time : float = 0.1

@export
var gravity_constant : float = 0.5

var gravity_timer : float = 0

var previous_state : EnemyState

func enter(previous_state: EnemyState) -> void:
	super(previous_state)
	
	#parent.animations.play(animation_name)
		
	gravity_timer = gravity_time
	self.previous_state = previous_state
	pass 
	
func process_input(event: InputEvent) -> EnemyState:	
	return
	
func process_physics(delta: float, gravity_influence: Vector2) -> EnemyState:
	#gravity needs to fall off over time
	if gravity_influence.x == 0:
		parent.velocity.x *= .9
	else:
		parent.velocity.x += gravity_influence.x
	
	gravity_timer -= delta
	
	var grav_to_use = gravity
	
	
	if gravity_influence.y != 0:
		grav_to_use = gravity_influence.y
	
	if(gravity_timer > 0):
		parent.velocity.y += gravity * delta
		get_tree().call_group("Debug Group", "update_gravity", gravity)
	else:
		parent.velocity.y += gravity * gravity_constant * delta
		get_tree().call_group("Debug Group", "update_gravity", gravity * gravity_constant)
	
	#TODO make this not this
	var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement > 0
		
	print("Enemy velocity: ", parent.velocity)
	parent.velocity.x = movement
	parent.move_and_slide()
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
	
	if parent.is_on_floor():
		get_tree().call_group("Debug Group", "update_coyote_time", false)
		get_tree().call_group("Debug Group", "update_jump_buffer", false)
		get_tree().call_group("Debug Group", "update_gravity", gravity)
		if movement != 0:
			return move_state
		return idle_state
	return null
