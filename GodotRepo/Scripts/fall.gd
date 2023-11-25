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
var gravity_x : float = 0
var gravity_timer : float = 0
var coyote_timer : float = 0
var jump_buffer_timer: float = 0

var previous_state : State
var fall_state : State

func enter(previous_state: State) -> void:
    super(previous_state)

    
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
    
func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    jump_buffer_timer -= delta
    coyote_timer -= delta
    gravity_timer -= delta
    
    get_tree().call_group("Debug Group", "update_gravity", gravity * gravity_constant)
        
    if(coyote_timer < 0):
        get_tree().call_group("Debug Group", "update_coyote_time", false)
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    
    if(movement > 0):
        parent.animations.flip_h = false
    elif(movement < 0):
        parent.animations.flip_h = true
        
    parent.velocity.y += parent.gravity * delta + gravity_influence.y * delta
    
    parent.velocity.x = movement + gravity_velocity_x
        
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
