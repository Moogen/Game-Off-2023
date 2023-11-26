extends Node2D

@onready var Player = $".."
var main_scene
var gravity_bar
var gravity_well_template = preload("res://Scenes/gravity_well.tscn")
@onready var state_machine = $"../State Machine"
@export
var idle_state: State
@export
var move_state: State

var spawning_well 
var growing_well
var launching_well
var well_size
const growing_well_start_scale = 0.025
const well_growing_scale = 0.01
const well_start_offset = 25
const well_growing_offset_scale = 0.3
const aiming_window = 500
var well_velocity = 100
var click_scale_timer
var aiming_timer = 0 #provides a window where the last aim will be used if the player drops aiming at the last second
@onready var growing_well_sprite = $"../gravity_well_visualizer"


# Called when the node enters the scene tree for the first time.
func _ready():
    main_scene = get_tree().get_root().get_child(0)
    gravity_bar = get_node("../../CanvasLayer/GravityBar")
    growing_well_sprite.visible = false
    launching_well = false
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if Input.is_action_just_pressed('grow_well') and launching_well == false and gravity_bar.has_mass(1): # and (state_machine.current_state == idle_state or state_machine.current_state == move_state):
        #start growing well while the "grow_well" button is pressed
        growing_well = true
        growing_well_sprite.visible = false
        well_size = 1
        click_scale_timer = Time.get_ticks_msec() #start timer
        spawning_well = gravity_well_template.instantiate()
        main_scene.add_child(spawning_well)
        update_well_sprite()
    elif Input.is_action_just_pressed('grow_well') and launching_well:
        launching_well = false
        #send a signal to the spawning well to freeze it
        if(is_instance_valid(spawning_well)): #ensure well was not deleted by an antigrav field
            spawning_well.freeze = true
            spawning_well.well_affect_player = true
            
    elif Input.is_action_pressed('grow_well') and growing_well:
        
        var click_time = Time.get_ticks_msec() - click_scale_timer
        
        if(Player.is_aiming):
            aiming_timer = Time.get_ticks_msec()
        
        if(click_time >= 100): #every 0.1 seconds add to the size 
            click_scale_timer = Time.get_ticks_msec()
            if(gravity_bar.has_mass(1)):
                gravity_bar.spend_mass(1)
                well_size += 1
            else:
                #out of mass, so we place the well
                launch_well()
                print("Out of mass to add")  
        
        update_well_sprite()
    elif !Input.is_action_pressed('grow_well') and growing_well:
        launch_well()
        
        
    #Also delete all wells in this node
    if Input.is_action_just_pressed('return_wells'):
        # Get all objects in the "Gravity Well Group".
        var wells_in_group = get_tree().get_nodes_in_group("Gravity Well Group")

        launching_well = false
        growing_well = false
        # Iterate through each well in the group.
        for well in wells_in_group:
        # Ensure the well is not null and has a 'remove_gravity' method.
            if well and well.has_method("remove_gravity"):
                # Delete (free) the well.()
                well.remove_gravity()
    
         
    pass
    
func launch_well():    
    growing_well_sprite.visible = false
    growing_well = false
    
   
    #spawning_well.position = growing_well_sprite.global_position
   
    var aiming_time =  Time.get_ticks_msec() - aiming_timer
    if aiming_time < aiming_window:
        launching_well = true
        spawning_well.well_launched = true #now the well can collide with walls
        #set velocity of the well as a vector in the direction the player is aiming
        var x = cos(Player.aiming_angle)
        var y = sin(Player.aiming_angle)
                
        var launch_velocity = Vector2(x, y).normalized()  * well_velocity + Player.velocity
        spawning_well.linear_velocity = launch_velocity
    else:
        spawning_well.well_affect_player = true
        spawning_well.well_launched = true #now the well can collide with walls
    pass
    
func update_well_sprite():
    var scale_val = well_size*well_growing_scale + growing_well_start_scale
    growing_well_sprite.scale = Vector2(scale_val, scale_val)
    var offset_val = well_size*well_growing_offset_scale + well_start_offset
    spawning_well.set_size(well_size, well_size)
    spawning_well.position = growing_well_sprite.global_position
    if Player.is_aiming:
        #place the well sprite in line with this angle
        var x = cos(Player.aiming_angle)
        var y = sin(Player.aiming_angle)
                
        var well_sprite_offset = Vector2(x, y).normalized() * offset_val
        growing_well_sprite.position = well_sprite_offset
    else:    
        growing_well_sprite.position = Vector2(0, -offset_val)
