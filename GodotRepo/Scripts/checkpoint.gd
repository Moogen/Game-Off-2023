extends Node2D

@onready var checkpoint_area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    for body in checkpoint_area.get_overlapping_bodies():
        if body is Player:
            GlobalOptions.set_checkpoint_pos(self.global_position)
        pass

    pass
