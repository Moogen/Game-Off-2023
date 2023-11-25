extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    for body in self.get_overlapping_bodies():
        if body.is_in_group("Gravity Well"):
            print("overlaps")
            body.remove_gravity()
        pass
    pass
