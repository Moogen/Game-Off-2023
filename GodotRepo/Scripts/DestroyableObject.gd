class_name DestroyableObject extends Node2D
#Destroyable object class that all destroyable objects will be part of


#Set a particle emitter for the destroyable object
var particle_emitter = preload("res://Scenes/normal_emitter.tscn")
@export var particle_color : Color

var particle_radius = 10
var particle_amount = 100
    
#set a mass value for the player to recieve when its destroyed
var object_mass = 10
var cur_health = 10
var max_health = 10
var main_scene
# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("Destroyable")
    main_scene = get_tree().get_root().get_child(0)
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func destroy_self():
    get_tree().call_group("Gravity Bar", "modify_mass", object_mass)
    
    var spawning_emitter = particle_emitter.instantiate()
    main_scene.add_child(spawning_emitter)
    #spawning_emitter.process_material.set_shader_parameter("emission_sphere_radius", particle_radius)  
    spawning_emitter.amount = particle_amount
    spawning_emitter.emitting = true
    spawning_emitter.one_shot = true
    spawning_emitter.global_position = self.global_position
    
    var parent = get_parent()  # This will get the parent of the current node.
    if parent:
        parent.queue_free()  # This will queue the parent for deletion.
    pass
    
    
func damage_object(damage : int):
    cur_health -= damage
    if(damage > cur_health):
        print("object destroyed")
        destroy_self()
    pass
