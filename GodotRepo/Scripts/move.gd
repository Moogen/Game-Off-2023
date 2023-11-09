extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

func enter(previous_state: State) -> void:
    super(previous_state)

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
        
    return null

func process_physics(delta: float, gravity_influence: Vector2) -> State:
    parent.velocity.y += gravity * delta 
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    
    if movement == 0:
        return idle_state
        
    #gravity needs to fall off over time
    if gravity_influence.x == 0:
        parent.velocity.x *= .90
        
    var grav_to_use = gravity
    
    if gravity_influence.y != 0:
        grav_to_use = gravity_influence.y
    parent.velocity.y += grav_to_use * delta
    
    parent.animations.flip_h = movement > 0
    parent.velocity.x = movement + gravity_influence.x
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
    
    if !parent.is_on_floor():
        return fall_state
    return null
