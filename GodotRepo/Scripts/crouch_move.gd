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
    parent.player_crouch(true)
    get_tree().call_group("SoundManager", "player_rolling", true)
    
func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        parent.player_crouch(false)
        get_tree().call_group("SoundManager", "player_rolling", false)
        return jump_state
    if !Input.is_action_pressed('crouch'):
        parent.player_crouch(false)
        get_tree().call_group("SoundManager", "player_rolling", false)
        return idle_state        
    return null

func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    
    parent.velocity.y += parent.gravity * delta + gravity_influence.y * delta
    parent.velocity.x = movement + gravity_velocity_x
    
    if(movement > 0):
        parent.animations.flip_h = false
    elif(movement < 0):
        parent.animations.flip_h = true
        
    if movement == 0:
        get_tree().call_group("SoundManager", "player_rolling", false)
        return idle_state
    
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
  
    if !parent.is_on_floor():
        parent.player_crouch(false)
        get_tree().call_group("SoundManager", "player_rolling", false)
        return fall_state
    return null
