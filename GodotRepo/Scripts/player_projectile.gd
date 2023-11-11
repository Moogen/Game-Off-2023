extends Node2D

@onready var projectile_body = $RigidBody2D
@onready var projectile_area = $RigidBody2D/CollisionArea

var damage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    #set up the kill_timer for when we want to delete the well
    var kill_timer = Timer.new()
    kill_timer.wait_time = 2
    kill_timer.autostart = true
    kill_timer.connect("timeout", on_Timer_timeout)
    add_child(kill_timer)
    
    projectile_area.connect("body_entered", self.on_body_entered)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func on_Timer_timeout():
    queue_free()

func set_velocity(new_velocity : Vector2):
    projectile_body.linear_velocity = new_velocity
    print("set velocity")
    pass
    
func on_body_entered(body):
    
    if body.is_in_group("Destroyable"):
        print("do some damage to the object")       
        body.damage_object(damage)
    
        queue_free()
    pass
