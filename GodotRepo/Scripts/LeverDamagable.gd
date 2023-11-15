extends "res://Scripts/DestroyableObject.gd"

@export var object_health : float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    cur_health = object_health
    max_health = object_health
    pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #set_particles_direction() #set the particle direction of the emitter
    pass
    
func destroy_self():
    # Don't destroy this object
    pass
    
func damage_object(damage : int):
    var lever_parent = get_owner()
    lever_parent._on_player_interaction()
    pass
