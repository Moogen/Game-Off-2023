extends Node2D

var max_mass = 100;
var cur_mass = 100;

@onready var mass_bar : ProgressBar = $MassBar;

# Called when the node enters the scene tree for the first time.
func _ready():
    #mass_bar = get_node("Bar")
    adjust_mass_bar()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    
func _input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_add_mass"):
        modify_mass(1)
    pass
    
func modify_mass(massToAdd: int):
    if(cur_mass + massToAdd <= max_mass && cur_mass + massToAdd >= 0):
        cur_mass += massToAdd
    elif(cur_mass + massToAdd > max_mass):
        cur_mass = max_mass
    else:
        cur_mass = 0
    adjust_mass_bar()
    pass
    
func spend_mass(massToSpend: int) -> bool:
    print(massToSpend)
    if(massToSpend <= 0):
        print("What are you doing you big dummy you can't spend negative mass! You should be using the modify_mass function")
        return false
    elif(massToSpend > cur_mass):
        return false
    else:
        modify_mass(-1*massToSpend)
    return true
    
func adjust_mass_bar():
    #mass_bar.play(str(cur_mass))
    mass_bar.value = (float(cur_mass)/float(max_mass))*100
    pass
