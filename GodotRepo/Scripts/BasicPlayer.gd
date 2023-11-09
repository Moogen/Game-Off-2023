class_name Player extends CharacterBody2D

@onready
var state_machine = $"State Machine"
@onready 
var animations = $"AnimatedSprite2D"


#implement some signal functions to pass player data to GUI
func _ready() -> void:
	state_machine.init(self)

# Pass a reference of the player to the state machine so it can react accordingly
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
func _add_gravity():
	print("Adding gravity")
	pass
	
func _remove_gravity():
	print("Removing gravity")
	pass


