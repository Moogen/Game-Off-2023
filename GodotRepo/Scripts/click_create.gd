extends Node2D


var gravity_createable = true;

var max_wells = 12;
var delete_distance = 10;
var well_strength = 10000;
var max_well_distance = 75;

var all_wells = []

const gravity_well= preload("res://Scenes/gravity_well.tscn")

var gravity_bar
var player_reference

var player_base_position

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
	var gravity_impact = Vector2(0,0)
	
	for well in all_wells:
		var x_distance_to_player = abs(player_reference.position.x - well.position.x)
		var y_distance_to_player = abs(player_reference.position.y - well.position.y)

		if((x_distance_to_player < max_well_distance) && (y_distance_to_player < max_well_distance)):
			
			var normalized_angle = (well.position - player_reference.position).normalized()
			
			#fighting gravity is hard, let's give the vertical impact a boost
			normalized_angle.y *= 25
			normalized_angle.x *= 10
			
			#keep things from getting too silly
			var square_distance_ish = pow(player_reference.position.distance_to(well.position),2)
			#if square_distance_ish < 10:
			#	square_distance_ish = 10
			
			gravity_impact += Vector2(0,0)#(well_strength * delta * normalized_angle * (1/square_distance_ish))
		pass
	
	#some final sanity checks
	if(abs(gravity_impact.y) < .1): gravity_impact.y = 0
	if(abs(gravity_impact.x) < .1): gravity_impact.x = 0
	
	if all_wells.size() == 0 || gravity_impact == Vector2(0,0):
		player_reference.get_node("State Machine").set_gravity(Vector2(0,0))
	else:
		player_reference.get_node("State Machine").set_gravity(gravity_impact)
	return null
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and gravity_createable:
		# Right click deletes
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed and !event.is_released():
			for well in all_wells:
				# Look I know this is complicated, and I'm sorry
				# We're comparing the click position against each well position, but because click position
				# is adjusted by player movement we must adjust our calculation accordingly
				if ((event.position + (player_reference.position - player_base_position)).distance_to(well.position) < delete_distance):
					remove_child(well)
					all_wells.erase(well)
					gravity_bar.modify_mass(1)
				else:
					#probably we want to trigger a failure noise here
					pass
			pass
		
		# Left click creates
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed and !event.is_released() and (all_wells.size() < max_wells):
			#This checks if we have enough mass to spend!
			if(gravity_bar.spend_mass(1)):
				# create a new well
				var gravity_well = gravity_well.instantiate()
				# Click position is adjusted by player movement so we must place our gravity well accordingly
				gravity_well.position = event.position + (player_reference.position - player_base_position)
				all_wells.append(gravity_well)
				add_child(gravity_well)
	pass
	
