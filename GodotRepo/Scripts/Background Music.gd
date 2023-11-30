extends Node

@onready var sound_effect_stream = $AudioStreamPlayer
@onready var background_music_stream = $BackgroundMusic
@onready var rolling_effect_stream = $RollingStream
var play_background = true
var play_growing = false
var play_rolling = false

# Example of a specific sound function
func play_jump_sound():
    play_sound_effect_file("res://Sounds/retro_jump_bounce_13.wav", -10)

func play_shoot():
    play_sound_effect_file("res://Sounds/Shoot.wav", -10)
    
func play_collision():
    play_sound_effect_file("res://Sounds/Collision.wav", -10)
    
func play_attack():
    play_sound_effect_file("res://Sounds/retro_misc_various_sounds_85.wav",-10)

func play_freeze():
    play_sound_effect_file("res://Sounds/retro_misc_bass_sound_03.wav" , -10)
    
func play_die():
    play_sound_effect_file("res://Sounds/retro_damage_hurt_ouch_11.wav",-10)
    
func play_bounce():
    play_sound_effect_file("res://Sounds/retro_laser_gun_shoot_33.wav",-10)
    
func play_enter_rolling():
    play_sound_effect_file("res://Sounds/retro_move_walk_tick_01.wav",-10)

func play_returning_well():
    play_sound_effect_file("res://Sounds/retro_magic_spell_cast_08.wav",-10)

func player_rolling(crouching : bool):
    play_rolling = crouching
    play_enter_rolling()
    
func play_sound_effect_file(sound_file : String, volume_db : int):
    var stream = load(sound_file)
    sound_effect_stream.set_stream(stream)
    sound_effect_stream.volume_db = volume_db
    sound_effect_stream.play()
    
func _process(delta: float) -> void:
    if(background_music_stream.playing == false and play_background):
        background_music_stream.playing = true
    elif play_background == false:
        background_music_stream.playing = false
        
    if(rolling_effect_stream.playing == false and play_rolling):
        rolling_effect_stream.playing = true
    elif play_rolling == false:
        rolling_effect_stream.playing = false
