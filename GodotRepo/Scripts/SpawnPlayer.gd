extends Node

@onready var player_node = $"../Player"
@onready var loading_sprite = $"../CanvasLayer/ReloadScreen"
# Called when the node enters the scene tree for the first time.
func _ready():
    
    #on restart of a level set the player position to their checkpoint position
    #player_node.global_position = GlobalOptions.get_checkpoint_pos()
    var tween = get_tree().create_tween()
    loading_sprite.visible = true
    tween.tween_property(loading_sprite, "modulate", Color.WHITE, 1)
    tween.tween_property(loading_sprite, "modulate", Color(0, 0, 0, 0), 1)
    
    pass
    
func _process(delta):
    if Input.is_action_just_pressed('restart'): #reload the scene
        restart()
    pass
    
func on_Timer_timeout():
    get_tree().reload_current_scene()
#get_tree().change_scene_to_file("res://Scenes/Game End.tscn")

func restart():
    var tween = get_tree().create_tween()
    tween.tween_property(loading_sprite, "modulate", Color.WHITE, 1)
    var kill_timer = Timer.new()
    kill_timer.wait_time = 1
    kill_timer.autostart = true
    kill_timer.connect("timeout", on_Timer_timeout)
    add_child(kill_timer)    
