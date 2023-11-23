extends Node2D

@onready var generator_area = $Area2D
var gravity_bar
var recharge_timer
const recharge_time = 50
# Called when the node enters the scene tree for the first time.
func _ready():
    gravity_bar = get_node("../../../CanvasLayer/GravityBar")
    recharge_timer = Time.get_ticks_msec()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    var cur_time = Time.get_ticks_msec() - recharge_timer
    
    if (cur_time >= recharge_time):
        recharge_timer = Time.get_ticks_msec()
        for body in generator_area.get_overlapping_bodies():
            if body.is_in_group("Player Group"):
                gravity_bar.modify_mass(1)
            pass
        
    pass
