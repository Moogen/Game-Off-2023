extends "res://Scripts/Interactable.gd"
#Inherits from the interactable class

enum State {
    Off,
    On
}

var current_state = State.Off
@export var activated_animation : String = "On"

func _on_player_interaction() -> void:
    
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
    
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.s
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
