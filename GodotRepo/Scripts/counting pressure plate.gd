extends "res://Scripts/Interactable.gd"
#Inherits from the interactable class

enum State {
    Off,
    On
}

var current_state = State.Off
@export var activated_animation : String = "On"
@export var object_threshold = 10
@onready var counting_text = $RichTextLabel
@export var plate_group : String = "Anti Plate Objects"

func _ready():
    animations.play(animation_name)
    
func update_anim() -> void:
    
    if(current_state == State.Off):
        animations.play(animation_name)
    else:
        animations.play(activated_animation)
    pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
# Overload this so we can just change lever states with damage
func _process(delta):
    
    var object_count = 0
    
    for body in collision_area.get_overlapping_bodies():
         if body.is_in_group(plate_group):
            object_count += 1

    #update object count
    if object_count >= object_threshold:
        if(current_state == State.Off):
            current_state = State.On
            print("activated pressure plate")
            _activate_outputs()
            update_anim()
    else: 
        if(current_state == State.On):
            current_state = State.Off
            print("deactivated pressure plate")
            _deactivate_outputs()
            update_anim()
            
    #update object count text
    if counting_text and object_threshold - object_count >= 0:
        counting_text.bbcode_text = "%s" % [object_threshold- object_count]
        
    pass
    
