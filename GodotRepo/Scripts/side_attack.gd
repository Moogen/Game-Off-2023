extends "res://Scripts/State.gd"

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var idle_state: State

var main_scene
var gravity_x = 0
const attack_area_size : float = 10
const attack_duration : float = 0.4
var anim_complete = 0
var damage_delay_time = 0.2
@onready var attack_timer = $Attack_Timer
@onready var damage_delay_timer = $Damage_Delay_Timer
@onready var side_attack_area : Area2D = $"../../SideAttackArea"
@onready var side_attack_area_shape : CollisionShape2D = $"../../SideAttackArea/CollisionShape2D"
var projectile_template_invis = preload("res://Scenes/player_projectile_invis.tscn")

func enter(previous_state: State) -> void:
    
    main_scene = get_tree().get_root().get_child(0)
    #create a projectile to perform the physics portion of the player attack
    var shooting_projectile = projectile_template_invis.instantiate()
    main_scene.add_child(shooting_projectile)   
    #using parent.animations.flip_h to determine the side we'll attack on
    if(parent.animations.flip_h):
        side_attack_area_shape.position.x = -attack_area_size
        shooting_projectile.global_position = parent.global_position + Vector2(-13,0)
        var shooting_vector = Vector2(-100,0)
        shooting_projectile.set_velocity(shooting_vector)
    else:
        side_attack_area_shape.position.x = attack_area_size
        shooting_projectile.global_position = parent.global_position + Vector2(13,0)
        var shooting_vector = Vector2(100,0)
        shooting_projectile.set_velocity(shooting_vector)

    super(previous_state)
    anim_complete = 0 #set the animation complete sflag to 0
    
    #start an animation timer to change the state when the animation is completed
    attack_timer.wait_time = attack_duration
    attack_timer.connect("timeout", attack_timeout)
    attack_timer.start()
    
    #start a timer to check for overlapping bodies and do damage to them
    damage_delay_timer.wait_time = damage_delay_time
    damage_delay_timer.connect("timeout", on_damage_delay_timeout)
    damage_delay_timer.start()
    

        

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
        parent.animations.flip_h = false
    elif(movement < 0):
        parent.animations.flip_h = true
        
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
    
func on_damage_delay_timeout():
    damage_delay_timer.stop()
    #do damage to overlapping bodies
    for body in side_attack_area.get_overlapping_bodies():
        if body.is_in_group("Destroyable"):
            body.damage_object(parent.side_attack_damage)
        pass
    
func attack_timeout():
    attack_timer.stop()
    #deactivate the attack area
    anim_complete = 1 #set the anim_complete flag
