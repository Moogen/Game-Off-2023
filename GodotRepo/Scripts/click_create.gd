extends Node2D


var gravity_createable = true;

var max_wells = 12;
var delete_distance = 10;
var well_strength = 10000;
var max_well_distance = 75;

var all_wells = []

var gravity_well_template = preload("res://Scenes/gravity_well.tscn")

var gravity_bar
var player_reference

var player_base_position
var timer = 0

var spawning_well #holds a black hole that is currently spawning
var well_spawning_flag = 0 #used by the class to determine if a black hole is spawning
var well_size = 0 #this class scales these objects to create black hole objects
var mass_cost = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
    all_wells = []
    player_reference=get_node("../Player")
    gravity_bar=get_node("../CanvasLayer/GravityBar")
    player_base_position = player_reference.position
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if(well_spawning_flag): #if we're currently spawning a well
        var click_time = Time.get_ticks_msec() - timer
        
        # Click position is adjusted by player movement so we must place our gravity well accordingly
        spawning_well.position = get_global_mouse_position() 
        # print("Time elapsed: ", click_time)
        
        if(click_time >= 10): #every 0.1 seconds add to the size 
            timer = Time.get_ticks_msec()
            if(gravity_bar.has_mass(1)):
                gravity_bar.spend_mass(1)
                well_size += 1
                mass_cost += 1
                spawning_well.set_size(well_size, mass_cost)
            else:
                #out of mass, so we place the well
                well_spawning_flag = 0
                all_wells.append(spawning_well)
                print("Out of mass to add")
                
                
                
        # Check if we have any more mass to add to the size
        
        #if we do, spend the mass and increase the well size
        
        #if we don't do nothing (play a noise later)
        
        # if(gravity_bar.spend_mass(int(click_time/100))):
        # create a new well                  
    pass
    
func _physics_process(delta):
    pass
    

        
func _input(event: InputEvent) -> void:
    
    if Input.is_action_just_pressed('delete_wells'):
        var temp_wells = all_wells.duplicate()
        #so that we're not iterating through an array that is actively being deleted create a temp 
        
        for well in temp_wells: #search the temp array for all wells
            gravity_bar.modify_mass(well.get_mass()) #remove the wells and return them to the player
            well.remove_gravity()
            #remove_child(well)
            all_wells.erase(well)
            
    if event is InputEventMouseButton and gravity_createable:
        # Right click deletes
        
        if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():

            for well in all_wells:
                # Look I know this is complicated, and I'm sorry
                # We're comparing the click position against each well position, but because click position
                # is adjusted by player movement we must adjust our calculation accordingly
                
                if (get_global_mouse_position().distance_to(well.position) < delete_distance):
                    gravity_bar.modify_mass(well.get_mass())
                    well.remove_gravity()
                    #remove_child(well)
                    all_wells.erase(well)
                else:
                    #probably we want to trigger a failure noise here
                    pass
            pass
        
        # Left click creates
        if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
            # Start a timer to start figuring out the size of the black hole
            print("click down")
            timer = Time.get_ticks_msec()
            spawning_well = gravity_well_template.instantiate().duplicate()
            add_child(spawning_well)
            mass_cost = 0
            well_spawning_flag = 1
            well_size = 0
        elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and (all_wells.size() < max_wells):
            all_wells.append(spawning_well)
            well_spawning_flag = 0  

                  
                

    pass
    
