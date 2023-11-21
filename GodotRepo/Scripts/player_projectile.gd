extends Node2D

@onready var projectile_body = $RigidBody2D
@onready var projectile_area = $RigidBody2D/CollisionArea

var damage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    #set up the kill_timer for when we want to delete the well
    var kill_timer = Timer.new()
    kill_timer.wait_time = 10
    kill_timer.autostart = true
    kill_timer.connect("timeout", on_Timer_timeout)
    add_child(kill_timer)
    
    projectile_body.connect("body_entered", self.on_body_entered)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var bodies = projectile_body.get_colliding_bodies()
    for body in bodies:
        if body.is_in_group("Destroyable"):    
            body.damage_object(damage)
            queue_free()
    pass

func on_Timer_timeout():
    queue_free()

func set_velocity(new_velocity : Vector2):
    projectile_body.linear_velocity = new_velocity
    pass
    
func on_body_entered(body):
    pass

