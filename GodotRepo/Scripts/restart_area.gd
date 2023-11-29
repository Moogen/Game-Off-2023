extends Node2D

@onready var restart_area = $Area2D
@onready var SpawnPlayer = $"../../../SpawnPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    for body in restart_area.get_overlapping_bodies():
        if body is Player:
            SpawnPlayer.restart()
        pass

    pass
