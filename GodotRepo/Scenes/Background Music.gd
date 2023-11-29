extends Node

@onready var sound_effect_stream = $SoundEffectStream

# Example of a specific sound function
func play_jump_sound():
    play_sound_effect_file("res://Sounds/retro_jump_bounce_07.wav", 1)

func play_shoot():
    play_sound_effect_file("res://Sounds/retro_laser_gun_shoot_02.wav", 1)


func play_sound_effect_file(sound_file : String, volume_db : int):
    var stream = load(sound_file)
    sound_effect_stream.set_stream(stream)
    sound_effect_stream.volume_db = volume_db
    sound_effect_stream.play()
