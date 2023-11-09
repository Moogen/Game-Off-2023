extends "res://Scripts/InteractableOutput.gd"
#Inherits from the interactable class

enum State {
    Off,
    On
}

var current_state = State.Off
@export var activated_animation : String = "On"

func _activate():
    current_state = State.On
    update_anim()
    pass
    
func _deactivate():
    current_state = State.Off
    update_anim()
    pass
    
func update_anim() -> void:
    if(current_state == State.Off):
        animations.play(animation_name)
    else:
        animations.play(activated_animation)
    pass	

