extends "res://Scripts/EnemyState.gd"

@export
var idle_state: EnemyState

var range = 100
var distanceTraveled = 0
var speed = 10
var flipFlag = false
var direction = 1

func enter(previous_state: EnemyState) -> void:
	super(previous_state)

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_physics(delta: float, gravity_influence: Vector2) -> EnemyState:		
	if(flipFlag):
		direction*= -1
		flipFlag = false
		
	var distanceToMove = ceil(delta * speed)*direction
		
	#True if we'd go past our max range
	if(abs(distanceToMove)+distanceTraveled > range):
		distanceToMove = (range-distanceTraveled)*direction
		#So we travel "double" distance back
		distanceTraveled = -1*range
		flipFlag = true
	else:
		distanceTraveled += abs(distanceToMove)
	
	#parent.animations.flip_h = movement > 0
	#parent.velocity.x = movement + gravity_influence.x
	#get_tree().call_group("Debug Group", "update_velocity", parent.velocity)
	parent.move(Vector2(distanceToMove,0))
	return null
