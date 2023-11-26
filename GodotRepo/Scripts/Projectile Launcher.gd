class_name projectile_launcher extends Node2D

var projectile_template = preload("res://Scenes/player_projectile.tscn")
@onready var Player = $".."

# Get the main scene, which is typically the first child of the root
var main_scene
var shooting_magnitude = 200 #velocity magnitude at which projectiles are launched
var gravity_bar
@export var shooting_offset : Vector2
@onready var state_machine = $"../State Machine"
@export
var idle_state: State
@export
var move_state: State

var aiming_cursor = load("res://sprites/cursor.png")
var not_aiming_cursor = load("res://sprites/cursor-export.png")

# Called when the node enters the scene tree for the first time.
func _ready():
    main_scene = get_tree().get_root().get_child(0)
    gravity_bar = get_node("../../CanvasLayer/GravityBar")
    pass # Replace with function body.
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    var aiming_angle = 0
    var is_aiming    = false
    
    #Determine aiming angle, pass these to the main player
    if GlobalOptions.is_using_controller():
        var joystick_x = Input.get_action_strength("joystick_horizontal") - Input.get_action_strength("joystick_horizontal_back")
        var joystick_y =  Input.get_action_strength("joystick_vertical") - Input.get_action_strength("joystick_vertical_back")
        var joystick_vector = Vector2(-joystick_x, -joystick_y)
        aiming_angle = joystick_vector.angle()
        Player.aiming_angle = aiming_angle
        #if joystick is aiming
 
        if(joystick_x != 0 or joystick_y != 0):
            is_aiming = true
    else:
        var shooting_vector = get_global_mouse_position() - Player.global_position
        aiming_angle = shooting_vector.angle()
        if Input.is_action_pressed("aim_mouse"):
            is_aiming = true
        else:
            is_aiming = false
            
    Player.aiming_angle = aiming_angle
    Player.is_aiming    = is_aiming
    
    if(is_aiming):
        Input.set_custom_mouse_cursor(aiming_cursor)       
    else:
        Input.set_custom_mouse_cursor(not_aiming_cursor)

    if Input.is_action_just_pressed('shoot') and gravity_bar.has_mass(1): # and (state_machine.current_state == idle_state or state_machine.current_state == move_state):
        Player.shooting = true
        
        if not is_aiming:
            Player.process_non_aiming_offset() #set the player's projectile origin to a flip horizontal direction
      
        gravity_bar.spend_mass(1)
        var shooting_projectile = projectile_template.instantiate()
        
        shooting_projectile.global_position = Player.global_position + Player.shooting_offset
        shooting_projectile.damage = Player.shooting_damage
        
        
        var x = cos(aiming_angle)
        var y = sin(aiming_angle)
    
        if not is_aiming:
            if Player.animations.flip_h:
                x = -1
                y = 0
            if not Player.animations.flip_h:
                x = 1
                y = 0
                
        var launch_velocity = Vector2(x, y).normalized()  * shooting_magnitude + Player.velocity
        
        main_scene.add_child(shooting_projectile) #add projectiles to the main scene so they arent affected by player movement
        shooting_projectile.set_velocity(launch_velocity)

    elif not Input.is_action_pressed('shoot'):
        Player.shooting = false
        
    pass
    
    
    


