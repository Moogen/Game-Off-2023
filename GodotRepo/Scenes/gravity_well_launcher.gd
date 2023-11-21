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

var growing_well
var well_size
const growing_well_start_scale = 0.002
const well_growing_scale = 0.001
const well_start_offset = 25
const well_growing_offset_scale = 0.3
var click_scale_timer
@onready var growing_well_sprite = $"../gravity_well_visualizer"

# Called when the node enters the scene tree for the first time.
func _ready():
    main_scene = get_tree().get_root().get_child(0)
    gravity_bar = get_node("../../CanvasLayer/GravityBar")
    growing_well_sprite.visible = false
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if Input.is_action_just_pressed('grow_well') and gravity_bar.has_mass(1) and (state_machine.current_state == idle_state or state_machine.current_state == move_state):
        #start growing well while the "grow_well" button is pressed
        growing_well = true
        growing_well_sprite.visible = true
        well_size = 1
        click_scale_timer = Time.get_ticks_msec() #start timer
        update_well_sprite()
    elif Input.is_action_pressed('grow_well') and growing_well:
        
        var click_time = Time.get_ticks_msec() - click_scale_timer
        
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
    pass
    
func launch_well():    
    growing_well_sprite.visible = false
    growing_well = false
    
    if Player.is_aiming:
        print("player is aiming, shoot well in that direction")
    else:
        var spawning_well = gravity_well_template.instantiate()
        main_scene.add_child(spawning_well)
        spawning_well.position = growing_well_sprite.global_position
        spawning_well.set_size(well_size, well_size)
    pass
    
func update_well_sprite():
    var scale_val = well_size*well_growing_scale + growing_well_start_scale
    growing_well_sprite.scale = Vector2(scale_val, scale_val)
    var offset_val = well_size*well_growing_offset_scale + well_start_offset
    growing_well_sprite.position = Vector2(0, -offset_val)
