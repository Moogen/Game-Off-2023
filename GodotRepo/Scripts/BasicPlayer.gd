class_name Player extends CharacterBody2D

@onready
var state_machine = $"State Machine"
@onready 
var animations = $"AnimatedSprite2D"

var side_attack_damage = 1 #how much damage should each side attack do
@onready var attack_area : Area2D = $SideAttackArea

#implement some signal functions to pass player data to GUI
func _ready() -> void:
    state_machine.init(self)
    add_to_group("Player Group")
    attack_area.connect("body_entered", self._on_body_entered)

# Pass a reference of the player to the state machine so it can react accordingly
func _unhandled_input(event: InputEvent) -> void:
    state_machine.process_input(event)
    
func _physics_process(delta: float) -> void:
    state_machine.process_physics(delta)
    
func _process(delta: float) -> void:
    state_machine.process_frame(delta)
    
func set_influence(gravity: float, grav_center: Vector2, grav_center_radius:float) -> void:
    state_machine.set_influence(gravity, grav_center, self.global_position, grav_center_radius)

func _on_body_entered(body : PhysicsBody2D) -> void:
    if body.is_in_group("Destroyable"):
        print("do some damage to the object")       
        body.damage_object(side_attack_damage)
    pass
