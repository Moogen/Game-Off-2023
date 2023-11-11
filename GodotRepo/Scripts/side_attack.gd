extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var idle_state: State

var gravity_x = 0
const attack_area_size : float = 10
const attack_duration : float = .5
var anim_complete = 0
var timer 
@onready var side_attack_area : Area2D = $"../../SideAttackArea"
@onready var side_attack_area_shape : CollisionShape2D = $"../../SideAttackArea/CollisionShape2D"

func enter(previous_state: State) -> void:
    print("side attacker")
    #activate the attack on 1 side of the player
    side_attack_area_shape.disabled = false
        
    #using parent.animations.flip_h to determine the side we'll attack on
    if(parent.animations.flip_h):
        side_attack_area_shape.position.x = attack_area_size
    else:
        side_attack_area_shape.position.x = -attack_area_size

    super(previous_state)
    anim_complete = 0 #set the animation complete flag to 0
    
    #start an animation timer to change the state when the animation is completed
    timer = Timer.new()
    timer.wait_time = attack_duration
    timer.connect("timeout", attack_timeout)
    add_child(timer)
    timer.start()
    
        

func process_input(event: InputEvent) -> State:
    #if there's any input change the state here
   # if Input.is_action_pressed('ui_accept') and parent.is_on_floor():
   #     return jump_state
   # if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
 #       return move_state
    return null


func process_physics(delta: float, gravity_influence: Vector2, gravity_velocity_x: float) -> State:
    
    #apply movement so we don't lose any
    var movement = Input.get_axis('ui_left', 'ui_right') * move_speed
    parent.velocity.y += gravity * delta + gravity_influence.y * delta
    parent.velocity.x = movement + gravity_velocity_x
    
    if(movement > 0):
        parent.animations.flip_h = true
    elif(movement < 0):
        parent.animations.flip_h = false
        
    get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
    parent.move_and_slide()
  
    if !parent.is_on_floor():
        return fall_state
        
    return null
    
func process_frame(delta) -> State:
    var movement = Input.get_axis('ui_left', 'ui_right')
    if anim_complete == 1 && movement == 0:
        return idle_state
    elif anim_complete == 1:
        return move_state #go to the move state if player is currently moving
        
    return null
    
func attack_timeout():
    
    #deactivate the attack area
    remove_child(timer)
    side_attack_area_shape.disabled = true
    print("leaving state")
    anim_complete = 1 #set the anim_complete flag
