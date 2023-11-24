extends "res://Scripts/Interactable.gd"
#Inherits from the interactable class

enum State {
    Off,
    On
}

var current_state = State.Off
@export var activated_animation : String = "On"
    
func _on_player_interaction() -> void:
    
    print("interacted")
    if(current_state == State.Off):
        current_state = State.On
        _activate_outputs()
    else:
        current_state = State.Off
        _deactivate_outputs()
        
    update_anim()
    pass
    
func update_anim() -> void:
    
    if(current_state == State.Off):
        animations.play(animation_name)
    else:
        animations.play(activated_animation)
    pass



## Called every frame. 'delta' is the elapsed time since the previous frame.
# Overload this so we can just change lever states with damage
func _process(delta):
    pass
