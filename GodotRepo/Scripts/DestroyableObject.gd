class_name DestroyableObject extends RigidBody2D
#Destroyable object class that all destroyable objects will be part of


#Set a particle emitter for the destroyable object

#set a mass value for the player to recieve when its destroyed
var object_mass = 10
var cur_health = 10
var max_health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("Destroyable")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func destroy_self():
    get_tree().call_group("Gravity Bar", "modify_mass", object_mass)
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
