extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var crouch_state: State
@export
var crouch_move_state: State

@export var landing_animation_name : String
@export var standing_animation_name : String
@export var aiming_animation_name : String
var gravity_x = 0
var previous_state
    
func enter(previous_state: State) -> void:
    super(previous_state) 
    self.previous_state = previous_state
    
    if(previous_state == fall_state):   
        parent.animations.play(landing_animation_name)                
    elif(previous_state == crouch_state or previous_state == crouch_move_state):   
        parent.animations.play(standing_animation_name)      
        
    if(previous_state != self):
        parent.velocity.x = 0
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)

func process_input(event: InputEvent) -> State:
    if Input.is_action_just_pressed('ui_accept') and parent.is_on_floor():
        return jump_state
    if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
        return move_state
    if Input.is_action_pressed('crouch'):
        return crouch_state
    return null

     
func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    #bit of a janky way to queue up animations after the "enter ide"
    #operate animations
    if(parent.animations.get_animation() == landing_animation_name and parent.animations.frame < 1):   
        # do nothing, we're still processing the animation 
        print("do nothing falling")    
    if(parent.animations.get_animation() == standing_animation_name and parent.animations.frame < 5):   
        # do nothing, we're still processing the animation   
        print("do nothing")
    else:
        
        if(parent.is_aiming): #then if we aren't processing a fall animation
            parent.process_aiming_animation(false)
        elif(parent.shooting):
            print("parent is shooting")
            parent.animations.play(aiming_animation_name)
        else:
            parent.animations.play(animation_name) 
            
    pass


    
    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = gravity_velocity_x
    parent.move_and_slide()
    

    if !parent.is_on_floor():
        return fall_state
    return null

