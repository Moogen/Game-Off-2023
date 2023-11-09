class_name GravityWell
extends Node2D

@onready var grav_area          : Area2D            = $Blackhole
@onready var grav_center_area   : Area2D            = $Center
@onready var grav_shape         : CollisionShape2D  = $Blackhole/CollisionShape2D
@onready var grav_center_shape  : CollisionShape2D  = $Center/CollisionShape2D
@onready var blackhole_sprite   : Sprite2D          = $BlackholeSprite
#all the variables for scaling the black hole

const blackhole_gravity : float = 3000
const blackhole_size    : float = 83*5
const center_size       : float = 10
const click_timer_scale : float = .001 #.1 seconds is = the base size of the black hole
const sprite_scale      : float = 0.025

var click_time = 0
var mass_cost = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Super massive black hole")
	grav_area.gravity = blackhole_gravity * (click_timer_scale * click_time)
	grav_shape.shape.radius = blackhole_size * click_timer_scale * click_time
	grav_center_shape.shape.radius = center_size * click_timer_scale * click_time
	blackhole_sprite.scale = Vector2(sprite_scale * click_timer_scale * click_time, sprite_scale * click_timer_scale * click_time)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_gravity():
	grav_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	grav_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	grav_center_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	grav_center_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	pass
	
func set_size(click_time):
	self.click_time = click_time
	mass_cost = click_time/100 
	pass
	
func get_mass():
	return mass_cost

