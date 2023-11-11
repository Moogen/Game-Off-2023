class_name projectile_launcher extends Node2D

var projectile_template = preload("res://Scenes/player_projectile.tscn")
@onready var Player = $".."

# Get the main scene, which is typically the first child of the root
var main_scene
var shooting_magnitude = 200 #velocity magnitude at which projectiles are launched
var gravity_bar
# Called when the node enters the scene tree for the first time.
func _ready():
    main_scene = get_tree().get_root().get_child(0)
    gravity_bar = get_node("../../CanvasLayer/GravityBar")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if Input.is_action_just_pressed('shoot') and gravity_bar.has_mass(1):
        gravity_bar.spend_mass(1)
        var shooting_projectile = projectile_template.instantiate()
        shooting_projectile.global_position = Player.global_position
        shooting_projectile.damage = Player.shooting_damage
        var shooting_vector = get_global_mouse_position() - Player.global_position
        var launch_velocity = shooting_vector.normalized() * shooting_magnitude
        
        main_scene.add_child(shooting_projectile) #add projectiles to the main scene so they arent affected by player movement
        shooting_projectile.set_velocity(launch_velocity)
        print("launched projectile")
        
    pass
    
    
    


