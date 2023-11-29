extends Node2D

@onready var projectile_body = $RigidBody2D
@onready var projectile_area = $RigidBody2D/CollisionArea

var hit_kill_timer #start timer when projectile hits, delete the projectile when this expires
var damage = 0
var kill_delay_time = 0.02
var lifespan = 5
# Called when the node enters the scene tree for the first time.
func _ready():
    #set up the kill_timer for when we want to delete the projectile
    var kill_timer = Timer.new()
    kill_timer.wait_time = lifespan
    kill_timer.autostart = true
    kill_timer.connect("timeout", on_Timer_timeout)
    add_child(kill_timer)
    
    hit_kill_timer = Timer.new()
    hit_kill_timer.wait_time = kill_delay_time
    hit_kill_timer.connect("timeout", remove_projectile)
    add_child(hit_kill_timer)
    
    projectile_area.connect("body_entered", self.on_body_entered)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func on_Timer_timeout():
    queue_free()

func set_velocity(new_velocity : Vector2):
    projectile_body.linear_velocity = new_velocity
    pass

func remove_projectile():
    queue_free()
    pass
    
func on_body_entered(body):
    if body.is_in_group("Destroyable"):    
        body.damage_object(damage)
        hit_kill_timer.start()
    elif body.is_in_group("Plate Objects") or body.is_in_group("Anti Plate Objects"):
        hit_kill_timer.start()
    else:
        print("didnt hit nothing")
    pass

