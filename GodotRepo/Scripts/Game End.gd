extends Node2D

# Declare member variables here. Examples:
var tween: Tween
@onready var sprite = $EndOfGameScreen
@onready var text = $RichTextLabel
@onready var ship_sprite = $ShipWPilot

# Called when the node enters the scene tree for the first time.
func _ready():
    # Initialize the tween node
    var tween = get_tree().create_tween()
    tween.pause()
    tween.tween_property(sprite, "modulate", Color.WHITE, 3)
    tween.tween_property(ship_sprite, "position", Vector2(600, 139), 5)
    tween.tween_property(text, "modulate", Color.WHITE, 1)
    tween.set_parallel(true)
    tween.play()
