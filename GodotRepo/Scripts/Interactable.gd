class_name Interactable extends Node2D
#New state for interactable objects that extends Node

@export var animation_name: String #default animation name
@export var animations : AnimatedSprite2D #Animated sprite for object
@export var collision_area : Area2D #Interactable area
@export var interact_text : RichTextLabel #text that appears when player can interact
@export var logic_outputs : Array[InteractableOutput] = []

var is_interactable = false

# Called when the node enters the scene tree for the first time.
func _ready():
    print(animation_name)
    animations.play(animation_name)
    collision_area.connect("body_entered", self._on_body_entered)
    collision_area.connect("body_exited", self._on_body_exited)
    interact_text.visible = false 
    pass
    
func _on_body_entered(body: PhysicsBody2D) -> void:
    if body is Player:
        interact_text.visible = true
        is_interactable = true

func _on_body_exited(body: PhysicsBody2D) -> void:
    if body is Player:
        interact_text.visible = false
        is_interactable = false

func _input(event: InputEvent) -> void:

    pass

func _activate_outputs() -> void:
    #call activate on all outputs attached to the interactable\
    for output in logic_outputs:
        output.call_deferred("_activate")

    pass
    
func _deactivate_outputs() -> void:
    #call deactivate on all outputs attached to the interactable
    for output in logic_outputs:
        output.call_deferred("_deactivate")
        
    pass

func _on_player_interaction() -> void:
    #main function that will be extended by interactable objects
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed('interact') and is_interactable:
        _on_player_interaction()
    pass
