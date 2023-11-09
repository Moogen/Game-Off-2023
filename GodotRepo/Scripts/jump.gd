extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State

@export
var jump_force: float = 900.0

var gravity_x : float = 0

func enter(previous_state: State) -> void:
    
    super(previous_state)
    parent.velocity.y = -jump_force
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    if parent.velocity.y > 0:
        return fall_state
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    
    if movement != 0:
        parent.animations.flip_h = movement > 0
        

    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = movement + gravity_velocity_x
    
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
    
    if parent.is_on_floor():
        if movement != 0:
            return move_state
        return idle_state
    
    return null
