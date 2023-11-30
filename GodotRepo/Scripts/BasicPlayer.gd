class_name Player extends CharacterBody2D

@onready
var state_machine = $"State Machine"
@onready 
var animations = $"AnimatedSprite2D"
@onready 
var crouch_collider = $"Crouch Collider"
@onready 
var stand_collider = $"Stand Collider"

var side_attack_damage = 1 #how much damage should each side attack do
var shooting_damage = 1
var aiming_angle = 0.0
var is_aiming = false
var shooting_offset : Vector2
var shooting = true
var gravity_invert = false
var gravity = 980
var floating = false
@export var aiming_shooting_offset : Array[Vector2] = []
@export var aiming_animation_name : Array[String] = []

#implement some signal functions to pass player data to GUI
func _ready() -> void:
    state_machine.init(self)
    add_to_group("Player Group")

# Pass a reference of the player to the state machine so it can react accordingly
#func _unhandled_input(event: InputEvent) -> void:
    
    
func _physics_process(delta: float) -> void:
    state_machine.process_physics(delta)
    
func _process(delta: float) -> void:
    state_machine.process_frame(delta)
    state_machine.process_input(null) # process input here instead
    
func set_influence(gravity: float, grav_center: Vector2, grav_center_radius:float) -> void:
    state_machine.set_influence(gravity, grav_center, self.global_position, grav_center_radius)

func set_inverse(invert: bool) -> void:
    gravity_invert = invert
    
    if(invert):
        gravity = -980
        animations.flip_v = true
    else:
        gravity = 980
        animations.flip_v = false
    pass
    
func set_grav(value: bool) -> void:
    if(value):
        floating = false
        gravity = 980
        #animations.flip_v = false
    else:
        gravity = 980/3
        floating = true
        #animations.flip_v = true
    pass

func player_crouch(crouching: bool) -> void:
    if(crouching):
        stand_collider.disabled = true
        crouch_collider.disabled = false
    else:
        stand_collider.disabled = false
        crouch_collider.disabled = true        
        
        
        
func process_non_aiming_offset():
        if animations.flip_h:
            shooting_offset = aiming_shooting_offset[6]
        else:
            shooting_offset = aiming_shooting_offset[2]
            
        animations.pause()
        
        
func process_aiming_animation(moving: bool):
    
    #normalize the angle ins radians to be within 0 and 2pi
    var angle_in_radians = -fmod(aiming_angle, 2 * PI)

    if angle_in_radians < 0:
        angle_in_radians += 2 * PI
        
    #get the player direction going into this state so this function must always happen after we change player flip
    var player_dir = animations.flip_h
    
    # Determine the direction based on the angle
    if angle_in_radians < PI / 8: #E
        animations.flip_h = false
        animations.play(aiming_animation_name[2])
        shooting_offset = aiming_shooting_offset[2]
    elif angle_in_radians < 3 * PI / 8: #NE
        animations.flip_h = false
        animations.play(aiming_animation_name[1])
        shooting_offset = aiming_shooting_offset[1]
    elif angle_in_radians < 5 * PI / 8: #N
        animations.play(aiming_animation_name[0])
        shooting_offset = aiming_shooting_offset[0]
    elif angle_in_radians < 7 * PI / 8: #NW
        animations.flip_h = true
        animations.play(aiming_animation_name[1])
        shooting_offset = aiming_shooting_offset[7]
    elif angle_in_radians < 9 * PI / 8: #W
        animations.flip_h = true
        animations.play(aiming_animation_name[2])
        shooting_offset = aiming_shooting_offset[6]
    elif angle_in_radians < 11 * PI / 8: #SW
        animations.flip_h = true
        animations.play(aiming_animation_name[3])
        shooting_offset = aiming_shooting_offset[5]
    elif angle_in_radians < 13 * PI / 8: #S
        animations.play(aiming_animation_name[4])
        shooting_offset = aiming_shooting_offset[4]
    elif angle_in_radians < 15 * PI / 8: #SE
        animations.flip_h = false
        animations.play(aiming_animation_name[3])
        shooting_offset = aiming_shooting_offset[3]
    else: #E
        animations.play(aiming_animation_name[2])
        shooting_offset = aiming_shooting_offset[2]

    #then, check if the player is moving
    
    if not moving:
        animations.pause()

    pass
