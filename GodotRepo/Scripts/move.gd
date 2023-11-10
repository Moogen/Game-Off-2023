extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
var gravity_x : float = 0
func enter(previous_state: State) -> void:
    super(previous_state)

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
        
    return null

func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    
    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = movement + gravity_velocity_x
    
    if(movement > 0):
        parent.animations.flip_h = true
    elif(movement < 0):
        parent.animations.flip_h = false
        
    if movement == 0:
        return idle_state
    
    
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
  
    if !parent.is_on_floor():
        return fall_state
    return null
