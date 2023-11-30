extends "res://Scripts/DestroyableObject.gd"

#@onready var template_particle_emitter : CPUParticles2D = $"../MassParticles"
#var particle_emitter : GPUParticles2D
@export var object_health : float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    cur_health = object_health
    max_health = object_health
    #particle_radius = 5
    #particle_amount = 50
    #particle_emitter = template_particle_emitter.duplicate(true)
    #add_child(particle_emitter)
    pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #set_particles_direction() #set the particle direction of the emitter
    pass
    
func destroy_self():
    super.destroy_self()    
    pass
    
func set_particles_direction():
    var players = get_tree().get_nodes_in_group("Player Group")
    #particle_emitter.process_material.set_shader_parameter("player_loc", players[0].global_position)
    pass
