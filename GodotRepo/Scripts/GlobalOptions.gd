extends Node

# Global variable to store if the player is using a controller
var using_controller = false

func set_using_controller(is_using: bool):
    using_controller = is_using

func is_using_controller() -> bool:
    return using_controller
