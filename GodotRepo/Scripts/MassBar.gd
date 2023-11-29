extends ProgressBar

var gravity_bar
var last_val
var visible_timer = 0
const visible_timer_val = 2000
@onready var Player = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
    gravity_bar = get_node("../../CanvasLayer/GravityBar")
    self.visible = false
    last_val = gravity_bar.cur_mass
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    value = gravity_bar.cur_mass
    var time_val = Time.get_ticks_msec() - visible_timer
    
    if(Player.is_aiming):
        self.visible = true    
        #v#zisible_timer = Time.get_ticks_msec()    
    elif(last_val != value):
        self.visible = true
        visible_timer = Time.get_ticks_msec()
    elif(self.visible and time_val > visible_timer_val):
        self.visible = false

        
    last_val = value    
    pass
