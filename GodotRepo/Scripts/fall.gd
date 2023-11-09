extends "res://Scripts/State.gd"

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State

@export
var jump_buffer_time : float = 0.5 #amount of time to hold jumps before hitting floor
@export
var coyote_time : float = 0.2
@export
var gravity_time : float = 0.1

@export
var gravity_constant : float = 0.5

var gravity_timer : float = 0
var coyote_timer : float = 0
var jump_buffer_timer: float = 0

var previous_state : State

func enter(previous_state: State) -> void:
	super(previous_state)
	
	parent.animations.play(animation_name)
	
	if(previous_state != jump_state):
		coyote_timer = coyote_time
		get_tree().call_group("Debug Group", "update_coyote_time", true)
	else:
		coyote_timer = 0
		
	gravity_timer = gravity_time
	self.previous_state = previous_state
	pass 
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('ui_accept'):
		if coyote_timer > 0: 
			print("Coyote time activated")
			return jump_state
		else:
			jump_buffer_timer = jump_buffer_time
	
	return
	
func process_physics(delta: float, gravity_influence: Vector2) -> State:
	#gravity needs to fall off over time
	if gravity_influence.x == 0:
		parent.velocity.x *= .9
	else:
		parent.velocity.x += gravity_influence.x
	
	jump_buffer_timer -= delta
	coyote_timer -= delta
	gravity_timer -= delta
	
	var grav_to_use = gravity
	
	if gravity_influence.y != 0:
		grav_to_use = gravity_influence.y
	
	if(gravity_timer > 0):
		parent.velocity.y += grav_to_use * delta
		get_tree().call_group("Debug Group", "update_gravity", grav_to_use)
	else:
		parent.velocity.y += grav_to_use * gravity_constant * delta
		get_tree().call_group("Debug Group", "update_gravity", grav_to_use * gravity_constant)
		
	if(coyote_timer < 0):
		get_tree().call_group("Debug Group", "update_coyote_time", false)
	
		
	var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement > 0
		
	parent.velocity.x = movement
	parent.move_and_slide()
	get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
	
	if parent.is_on_floor():
		get_tree().call_group("Debug Group", "update_coyote_time", false)
		get_tree().call_group("Debug Group", "update_jump_buffer", false)
		get_tree().call_group("Debug Group", "update_gravity", gravity)
		if jump_buffer_timer > 0:
			return jump_state
		if movement != 0:
			return move_state
		return idle_state
	return null
