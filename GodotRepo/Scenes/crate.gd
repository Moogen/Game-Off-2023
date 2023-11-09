extends "res://Scripts/DestroyableObject.gd"

@onready var template_particle_emitter : GPUParticles2D = $"../MassParticles"
var particle_emitter : GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    cur_health = 1
    max_health = 1
    particle_emitter = template_particle_emitter.duplicate(true)
    add_child(particle_emitter)
    pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    set_particles_direction() #set the particle direction of the emitter
    pass
    
func destroy_self():
    #super.destroy_self()
   # particle_emitter.emitting = true
    #+ also activate the animation
    
    pass
    
func set_particles_direction():
    var players = get_tree().get_nodes_in_group("Player Group")
    particle_emitter.process_material.set_shader_parameter("player_loc", players[0].global_position)
    pass
