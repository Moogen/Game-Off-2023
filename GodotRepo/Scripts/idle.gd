extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State

var gravity_x = 0
    
func enter(previous_state: State) -> void:
    super(previous_state)
    if(previous_state != self):
        parent.velocity.x = 0
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
    if Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_right'):
        return move_state
    return null


func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = gravity_velocity_x
    parent.move_and_slide()
    
    if !parent.is_on_floor():
        return fall_state
    return null

