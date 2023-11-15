extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var idle_state: State

@export var landing_animation_name : String
var gravity_x = 0
    
func enter(previous_state: State) -> void:
    super(previous_state) 

    if(previous_state != self):
        parent.velocity.x = 0
    get_tree().call_group("Debug Group", "update_velocity",Vector2(69,69))

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
    if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
        return move_state
    if !Input.is_action_pressed('crouch'):
        return idle_state
    return null

     
func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    if(parent.animations.frame == 2): #essentially check if animation is finished
         parent.animations.play(animation_name)
    pass
    
    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = gravity_velocity_x
    parent.move_and_slide()
    
    if !parent.is_on_floor():
        return fall_state
    return null

