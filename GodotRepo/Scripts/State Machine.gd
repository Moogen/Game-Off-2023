class_name StateMachine extends Node

@export
var starting_state: State
@export
var current_state: State
@export
var previous_state: State

var timestop = false

var gravity_influence = Vector2(0,0)

	
# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent

	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		
	previous_state = current_state 
	current_state = new_state
	current_state.enter(previous_state)
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta, gravity_influence)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)

	if Input.is_action_just_pressed('timestop'): #time slows when pressing F4 as a debug feature
		timestop = !timestop
		if(timestop):
			Engine.set_time_scale(0.1)
		else:
			Engine.set_time_scale(1)
	pass
	
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func set_gravity(influence: Vector2) -> void:
	gravity_influence = influence
	get_tree().call_group("Debug Group", "update_gravity_influence", gravity_influence)
	pass
