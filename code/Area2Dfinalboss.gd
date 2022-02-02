extends Area2D

var vine_man_health = 4 
var vine_man_health_purple = 6 
var rat_health = 2
onready var sprite = get_node('../AnimatedSprite')
onready var final_boss_health = 15
onready var boss_man = self.get_owner()
onready var _animated_sprite = get_node("../AnimatedSprite/AnimationPlayer")
onready var state_machine = get_parent().get_node("AnimatedSprite/AnimationTree").get("parameters/playback")
onready var audio_damage = load("res://assets/sound/boss_damage.mp3")
onready var audio_death = load("res://assets/sound/boss_death.mp3")
onready var soundeffect = get_node("../SoundEffect")

func do_damage(hit_points):
	audio_damage()
	final_boss_health = final_boss_health - hit_points
	sprite.modulate = Color( 1, 0, 0, 1 )
	if final_boss_health <= 0 :
		sprite.modulate = Color( 1, 1, 1, 1 )
		audio_death()
		state_machine.travel("die")
		boss_man.is_dying = true
		yield(get_tree().create_timer(5.1), "timeout")
		boss_man.queue_free()
		get_tree().change_scene("res://scenes/Screens/credits.tscn")
	yield(get_tree().create_timer(.1), "timeout")
	sprite.modulate = Color( 1, 1, 1, 1 )

func audio_damage():
	audio_damage.set_loop(false)
	soundeffect.set_stream(audio_damage)
	soundeffect.play()

func audio_death():
	audio_death.set_loop(false)
	soundeffect.set_stream(audio_death)
	soundeffect.play()
