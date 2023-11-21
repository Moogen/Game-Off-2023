class_name GravityWell
extends RigidBody2D #make gravity well into a staticbody node instead

@onready var grav_area          : Area2D            = $Blackhole
@onready var grav_center_area   : Area2D            = $Center
@onready var grav_shape         : CollisionShape2D  = $Blackhole/CollisionShape2D
@onready var grav_center_shape  : CollisionShape2D  = $Center/CollisionShape2D
@onready var blackhole_sprite   : Sprite2D          = $BlackholeSprite
@onready var well_collider      : CollisionShape2D  = $WellCollider
#all the variables for scaling the black hole

const blackhole_gravity : float = 3000*10
const blackhole_size    : float = 83*5
const center_size       : float = 83
const click_timer_scale : float = 0.01 #.1 seconds is = the base size of the black hole
const sprite_scale      : float = 0.025*4
#const particle_disappear_coeff  : float = 0.015
const particle_ammount_coef     : float = 200
const particle_dying_coef       : float = 1
const particle_center_size      : float = 83/2
const mass_particle_gravity     : float = 250 #controls the force at which the mass particles are attracted to the player
const well_dying_timer : float = 2000 #lose 1 tick of mass on the well per 2 second
const well_dying_val   : int = 1


var click_time = 0
var mass_cost = 0
var return_dying_mass = false
var mass_return_anim_time = 10
var timer
var well_active
@onready var template_particle_emitter : GPUParticles2D = $MassParticles
var well_affect_player = false
var particle_emitter : GPUParticles2D
var mass_returned
# Called when the node enters the scene tree for the first time.
func _ready():
    print("Supermassive black hole")
   
    add_to_group("Gravity Well Group")
    well_active = true
    mass_returned = false
    timer = Time.get_ticks_msec()

   
    particle_emitter = template_particle_emitter.duplicate(true)
    add_child(particle_emitter)
    #grav_area.connect("body_entered", self._on_body_entered)
    grav_area.connect("body_exited", self._on_body_exited)
    particle_emitter.process_material.set_shader_parameter("attractor_str", mass_particle_gravity)
    if(return_dying_mass):
        lose_mass(well_dying_val)
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #set_size(55,55)
    set_particles_direction() #set the particle direction of the emitter

    #check if the well has collided with anything
    
    var bodies = self.get_colliding_bodies()
    for body in bodies:
        self.freeze = true
   
    #remove mass from the well over time
    if(well_active && Time.get_ticks_msec() - timer > well_dying_timer):
        timer = Time.get_ticks_msec()
        mass_cost -= well_dying_val
        click_time -= well_dying_val
        set_size(click_time, mass_cost)
        if(return_dying_mass):
            get_tree().call_group("Gravity Bar", "modify_mass", well_dying_val)
            
        if(mass_cost == 0):
            remove_gravity() #somehow this needs to be removed from the wells list?
            #maybe the wells collection should just be a group

    #if we overlap with the player, apply gravity to them
    for body in grav_area.get_overlapping_bodies():
        if body is Player and well_affect_player:
            body.set_influence(grav_area.gravity*5, self.global_position, grav_center_shape.shape.radius)
    pass

    
func remove_gravity():
    if mass_returned == false: # prevent the player from returning mass multiple times
        set_particles_size()
        well_active = false
        grav_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
        grav_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
        grav_center_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
        grav_center_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_DISABLED
        remove_child(grav_center_area)
        remove_child(grav_area)
        particle_emitter.explosiveness = 1
        blackhole_sprite.visible = false
    #check if we overlap from the player and remove any gravity affects
        for body in grav_area.get_overlapping_bodies():
            if body is Player:
                body.set_influence(0, self.global_position, 0)
                
        particle_emitter.one_shot = true        
        particle_emitter.visibility_rect.grow(25)  #programatically adjust this rect
        
        if(mass_cost > 0): #if the well dies with 0 mass, don't return any mass particles
            particle_emitter.emitting = true
            
        print("returning well of size %d", mass_cost)
        get_tree().call_group("Gravity Bar", "modify_mass", mass_cost)
        mass_returned = true
        
        #set up the kill_timer for when we want to delete the well
        var kill_timer = Timer.new()
        kill_timer.wait_time = 2
        kill_timer.autostart = true
        kill_timer.connect("timeout", on_Timer_timeout)
        add_child(kill_timer)
    pass
    
func on_Timer_timeout():
    queue_free()

func lose_mass(lost_mass):
    #remove mass, emit particles = to the mass lost in an area = to the total area
    particle_emitter.amount = 0 #this is a janky way to activate the emitter on tick
    particle_emitter.process_material.set_shader_parameter("emission_sphere_radius", particle_center_size * click_timer_scale * click_time)  #use the same math as center size
    particle_emitter.amount = lost_mass * particle_dying_coef
    particle_emitter.explosiveness = 0
    particle_emitter.emitting = true
    particle_emitter.one_shot = false
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
    well_collider.shape.radius = center_size * click_timer_scale * click_time
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
    
#func get_mass():
    #return mass_cost

