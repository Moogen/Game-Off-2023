class_name Enemy extends Node2D

var cur_health
var max_health
var damage
var fireSpeed = 2
var fireTimer = 0

@onready
var projectile = preload("res://Scenes/projectile.tscn")
@onready
var enemy_state_machine = $"EnemyStateMachine"
@onready 
var animations = $"AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
    enemy_state_machine.init(self)
    pass
    
# Pass a reference of the player to the state machine so it can react accordingly
func _unhandled_input(event: InputEvent) -> void:
    enemy_state_machine.process_input(event)
    
func _physics_process(delta: float) -> void:
    enemy_state_machine.process_physics(delta)
    
func _process(delta: float) -> void:
    enemy_state_machine.process_frame(delta)
    fireTimer += delta
    
    if(fireTimer >= fireSpeed):
        var playerPosition = get_node("../Player").position
        var directionToFire = get_angle_to(playerPosition + Vector2(0,25))
        var angle = Vector2(cos(directionToFire), sin(directionToFire))
        print(angle)
        #var space_state = get_world_2d().direct_space_state
        #var query = PhysicsRayQueryParameters2D.create(self.position+Vector2(0,-40), playerPosition)
        #var result = space_state.intersect_ray(query)
        #if(result): print(result.position)
        #else: print(result)
        
        fireTimer = 0
        fireAtPlayer(angle)
    
func move(distanceToMove: Vector2):
    self.global_translate(distanceToMove)
    
func fireAtPlayer(angle: Vector2):
    var laser = projectile.instantiate().duplicate()
    laser.global_position = self.global_position+angle*5
    get_node("../.").add_child(laser)
    laser.set_velocity(angle*50000)
    pass
