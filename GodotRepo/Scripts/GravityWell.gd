class_name GravityWell
extends Node2D

@onready var grav_area          : Area2D            = $Blackhole
@onready var grav_center_area   : Area2D            = $Center
@onready var grav_shape         : CollisionShape2D  = $Blackhole/CollisionShape2D
@onready var grav_center_shape  : CollisionShape2D  = $Center/CollisionShape2D
@onready var blackhole_sprite   : Sprite2D          = $BlackholeSprite
#all the variables for scaling the black hole

const blackhole_gravity : float = 3000*10
const blackhole_size    : float = 83*5
const center_size       : float = 83
const click_timer_scale : float = 0.01 #.1 seconds is = the base size of the black hole
const sprite_scale      : float = 0.025*4
#const particle_disappear_coeff  : float = 0.015
const particle_ammount_coef     : float = 100
const particle_center_size      : float = 83/2
const mass_particle_gravity     : float = 250 #controls the force at which the mass particles are attracted to the player

var click_time = 0
var mass_cost = 0

var mass_return_anim_time = 10

@onready var template_particle_emitter : GPUParticles2D = $MassParticles
var particle_emitter : GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
    print("Supermassive black hole")
    set_size(0,0)
    particle_emitter = template_particle_emitter.duplicate(true)
    add_child(particle_emitter)
    #grav_area.connect("body_entered", self._on_body_entered)
    grav_area.connect("body_exited", self._on_body_exited)
    particle_emitter.process_material.set_shader_parameter("attractor_str", mass_particle_gravity)
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    set_particles_direction() #set the particle direction of the emitter
    set_particles_size()
   
    #if we overlap with the player, apply gravity to them
    for body in grav_area.get_overlapping_bodies():
        if body is Player:
            body.set_influence(grav_area.gravity*5, self.global_position, grav_center_shape.shape.radius)
    pass

func remove_gravity():
    grav_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
    grav_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
    grav_center_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
    grav_center_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
    remove_child(grav_center_area)
    remove_child(grav_area)

    blackhole_sprite.visible = false
#check if we overlap from the player and remove any gravity affects
    for body in grav_area.get_overlapping_bodies():
        if body is Player:
            body.set_influence(0, self.global_position, 0)
            
    particle_emitter.visibility_rect.grow(25)  #programatically adjust this rect
    particle_emitter.emitting = true
    
    pass

func finish_mass_anim():
    queue_free()
    
func set_size(click_time, mass_cost): #set size scales off thes duration of the click
    self.click_time = click_time
    self.mass_cost = mass_cost
    grav_area.gravity = blackhole_gravity * (click_timer_scale * click_time)
    grav_area.gravity_point_unit_distance = center_size * click_timer_scale * click_time
    grav_shape.shape.radius = blackhole_size * click_timer_scale * click_time
    grav_center_shape.shape.radius = center_size * click_timer_scale * click_time
    blackhole_sprite.scale = Vector2(sprite_scale * click_timer_scale * click_time, sprite_scale * click_timer_scale * click_time)
    pass

func set_particles_direction():
    var players = get_tree().get_nodes_in_group("Player Group")
   #@print(players[0].position)
    
    #The force should be = to the players position * gravity intensity
    var particle_vector = players[0].global_position - self.global_position
    var particle_grav = particle_vector.normalized() * mass_particle_gravity
    particle_emitter.process_material.set_shader_parameter("player_loc", players[0].global_position)
   # particle_emitter.lifetime =  players[0].global_position.distance_to(self.global_position) * particle_disappear_coeff
  
    #print(mass_particle_emitter.lifetime)

func set_particles_size(): #set the size of the particles
    particle_emitter.process_material.set_shader_parameter("emission_sphere_radius", particle_center_size * click_timer_scale * click_time)  #use the same math as center size
    particle_emitter.amount = click_time * particle_ammount_coef
    #sparticle_emitter.lifetime = click_time * particle_disappear_coeff
    
func _on_body_exited(body : PhysicsBody2D) -> void:
    if body is Player:
        body.set_influence(0, self.global_position, 0)
    pass
    
func get_mass():
    return mass_cost

