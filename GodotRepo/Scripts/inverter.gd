extends "res://Scripts/InteractableOutput.gd"
#Inherits from the interactable class

@export var logic_outputs : Array[InteractableOutput] = []

func _ready():
    pass
    
func _activate():
    for output in logic_outputs:
        output.call_deferred("_deactivate")
        
    pass
    
func _deactivate():
    for output in logic_outputs:
        output.call_deferred("_activate")
    pass


