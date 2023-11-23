extends "res://Scripts/DestroyableObject.gd"

@export var object_health : float = 0

@onready var lever = $".."
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
    print("interact with parent")
    lever._on_player_interaction()
    
    pass
