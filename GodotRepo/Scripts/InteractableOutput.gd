class_name InteractableOutput extends Node2D
#New state for interactable objects that extends Node

@export var animation_name: String #default animation name
@export var animations : AnimatedSprite2D #Animated sprite for object


var is_active = false #what is the state of the logic input to this output


# Called when the node enters the scene tree for the first time.
func _ready():
    print(animation_name)
    animations.play(animation_name)
    pass

func _activate():
    pass
    
func _deactivate():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
