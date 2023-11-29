extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    for body in self.get_overlapping_bodies():
        if body is Player:
            print("End of game")
            var wells_in_group = get_tree().get_nodes_in_group("Gravity Well Group")
            # Iterate through each well in the group.
            
            for well in wells_in_group:
            # Ensure the well is not null and has a 'remove_gravity' method.
                if well and well.has_method("remove_gravity"):
                    # Delete (free) the well.()
                    well.remove_gravity()
            get_tree().change_scene_to_file("res://Scenes/Game End.tscn")
        pass
    
    pass
