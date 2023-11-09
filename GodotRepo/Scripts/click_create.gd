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

# Called when the node enters the scene tree for the first time.
func _ready():
	all_wells = []
	player_reference=get_node("../Player")
	gravity_bar=get_node("../CanvasLayer/GravityBar")
	player_base_position = player_reference.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):

#	var gravity_impact = Vector2(0,0)
#
#	for well in all_wells:
#		var x_distance_to_player = abs(player_reference.position.x - well.position.x)
#		var y_distance_to_player = abs(player_reference.position.y - well.position.y)
#
#		if((x_distance_to_player < max_well_distance) && (y_distance_to_player < max_well_distance)):
#
#			var normalized_angle = (well.position - player_reference.position).normalized()
#
#			#fighting gravity is hard, let's give the vertical impact a boost
#			normalized_angle.y *= 25
#			normalized_angle.x *= 10
#
#			#keep things from getting too silly
#			var square_distance_ish = pow(player_reference.position.distance_to(well.position),2)
#			#if square_distance_ish < 10:
#			#	square_distance_ish = 10
#
#			gravity_impact += (well_strength * delta * normalized_angle * (1/square_distance_ish))

	var gravity_impact = Vector2(0,0)
	
	pass
	
#	#some final sanity checks
#	if(abs(gravity_impact.y) < .1): gravity_impact.y = 0
#	if(abs(gravity_impact.x) < .1): gravity_impact.x = 0
#
#	if all_wells.size() == 0 || gravity_impact == Vector2(0,0):
#		player_reference.get_node("State Machine").set_gravity(Vector2(0,0))
#	else:
#		player_reference.get_node("State Machine").set_gravity(gravity_impact)
#	return null
		
func _input(event: InputEvent) -> void:
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
					remove_child(well)
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
			
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and (all_wells.size() < max_wells):
			#This checks if we have enough mass to spend!
			var click_time = Time.get_ticks_msec() - timer
			print("Time elapsed: ", click_time)
			
			if(gravity_bar.spend_mass(int(click_time/100))):
				# create a new well
				var gravity_well = gravity_well_template.instantiate().duplicate()
				
				gravity_well.set_size(click_time)
				# Click position is adjusted by player movement so we must place our gravity well accordingly
				gravity_well.position = get_global_mouse_position()
				all_wells.append(gravity_well)
				add_child(gravity_well)
	pass
	
