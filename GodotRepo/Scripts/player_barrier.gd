extends "res://Scripts/InteractableOutput.gd"
#Inherits from the interactable class

enum State {
    Off,
    On
}

var current_state = State.On
@onready var field_shape : CollisionShape2D =$"forcefield animation/StaticBody2D/CollisionShape2D"
@export var deactivated_animation : String = "Off"
func _ready():
    super._ready()
    field_shape.disabled = false 
    pass
    
func _activate():
    current_state = State.On
    field_shape.disabled = true
    update_anim()
    pass
    
func _deactivate():
    current_state = State.Off
    field_shape.disabled = false
    update_anim()
    pass
    
func update_anim() -> void:
    if(current_state == State.Off):
        animations.play(animation_name)
    else:
        animations.play(deactivated_animation)
    pass	

