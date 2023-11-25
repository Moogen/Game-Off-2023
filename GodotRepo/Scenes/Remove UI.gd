extends Area2D
#tween out any ui in the end credits sequence

@onready var ui = $"../../../CanvasLayer/RestartKey"
var faded = false
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not faded:
        for body in self.get_overlapping_bodies():
            if body is Player:
                faded = true
                print("End of game")
                var tween = get_tree().create_tween()
                tween.tween_property(ui, "modulate", Color(0, 0, 0, 0), 3)
       
    pass
