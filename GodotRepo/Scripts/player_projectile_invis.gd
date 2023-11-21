extends Node2D

@onready var projectile_body = $RigidBody2D
@onready var projectile_area = $RigidBody2D/CollisionArea
@onready var projectile_shape = $RigidBody2D/CollisionShape2D
var new_velocity
var delay_time = 0.15
var kill_time = 0.075
# Called when the node enters the scene tree for the first time.
func _ready():
    
    projectile_shape.disabled = true
    #set up the kill_timer for when we want to delete the well
    var kill_timer = Timer.new()
    kill_timer.wait_time = delay_time + kill_time
    kill_timer.autostart = true
    kill_timer.connect("timeout", on_Timer_timeout)
    add_child(kill_timer)
    
    #this delay prevents the "attack" from kicking in before the player animation
    var delay_timer = Timer.new()
    delay_timer.wait_time = delay_time
    delay_timer.autostart = true
    delay_timer.connect("timeout", on_Delay_timeout)
    add_child(delay_timer)
    
    projectile_body.connect("body_entered", self.on_body_entered)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var bodies = projectile_body.get_colliding_bodies()
    for body in bodies:
        if body.is_in_group("Destroyable"):
            queue_free()
    pass

func on_Timer_timeout():
    queue_free()
    
func on_Delay_timeout():
    projectile_shape.disabled = false
    projectile_body.linear_velocity = new_velocity

func set_velocity(new_velocity : Vector2):
    self.new_velocity = new_velocity
    pass
    
func on_body_entered(body):
    pass

