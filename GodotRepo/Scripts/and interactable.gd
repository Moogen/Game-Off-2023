extends "res://Scripts/InteractableOutput.gd"
#Inherits from the interactable class

@export var logic_outputs : Array[InteractableOutput] = []

@export var logic_inputs : Array[Interactable] = []

var cur_state = false
#array of potential inputs

func _ready():
    pass

func _process(delta):
    
    var state = true #check if any of the inputs are false
    for inputs in logic_inputs:
        if(inputs.state == false):
            state = false
    
    #detect if state has changed
    if cur_state != state:
        if(state):
            _activate()
        else:
            _deactivate()
    
    cur_state = state
    pass
    
func _activate():
    for output in logic_outputs:
        output.call_deferred("_activate")
    pass
    
func _deactivate():
    for output in logic_outputs:
        output.call_deferred("_deactivate")
    pass


