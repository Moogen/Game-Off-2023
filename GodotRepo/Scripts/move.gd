extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export var aim_move_speed : float
var gravity_x : float = 0

@export var aiming_animation_name : Array[String] = []

func enter(previous_state: State) -> void:
    super(previous_state)

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
        
    return null

func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    var aim_movement = Input.get_axis('ui_left', 'ui_right') * aim_move_speed
    
    if(movement > 0):
        parent.animations.flip_h = false
    elif(movement < 0):
        parent.animations.flip_h = true
    

    
    #operate animations, apply the correct move velocity
    if(parent.is_aiming):
        parent.process_aiming_animation(true)
        parent.velocity.x = aim_movement + gravity_velocity_x
    else:
        parent.animations.play(animation_name)
        parent.velocity.x = movement + gravity_velocity_x
 

    #Update player velocity
    parent.velocity.y += gravity * delta + gravity_influence.y * delta

       
    if movement == 0:
        return idle_state
    
    
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
  
    if !parent.is_on_floor():
        return fall_state
    return null


    
