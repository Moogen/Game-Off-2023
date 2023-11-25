extends Node

# Global variable to store if the player is using a controller
var using_controller = false
var player_checkpoint_position : Vector2 = Vector2(-183,47)

func set_using_controller(is_using: bool):
    using_controller = is_using

func is_using_controller() -> bool:
    return using_controller

func set_checkpoint_pos(position : Vector2):
    player_checkpoint_position = position
    pass
    
func get_checkpoint_pos() -> Vector2:
    return player_checkpoint_position
