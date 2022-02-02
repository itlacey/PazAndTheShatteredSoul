extends KinematicBody2D

onready var player = get_node("../player")
onready var camera = get_node("../player/Camera2D")
onready var sprite = $AnimatedSprite
onready var visiblity = $VisibilityNotifier2D
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var audio_attack = load('res://assets/sound/mossman_attack.mp3')
onready var audio_death = load("res://assets/sound/mossman_death.mp3")
onready var audio_grow = load("res://assets/sound/mossman_spawn.mp3")
onready var soundeffect = $SoundEffect
var can_attack_sound = false

func _ready():
	state_machine.start("off")

func _physics_process(delta):
	var angle = global_position.angle_to_point(player.global_position)
	if abs(angle) > PI/2:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	



func _on_VisibilityNotifier2D_screen_exited():
	state_machine.travel('off')
	can_attack_sound = false


func _on_VisibilityNotifier2D_screen_entered():
	state_machine.start('grow')
	can_attack_sound = true

func audio_attack():
	audio_attack.set_loop(false)
	soundeffect.set_stream(audio_attack)
	if can_attack_sound:
		soundeffect.play()

func audio_death():
	audio_death.set_loop(false)
	soundeffect.set_stream(audio_death)
	soundeffect.play()

func audio_grow():
	audio_grow.set_loop(false)
	soundeffect.set_stream(audio_grow)
	if can_attack_sound:
		soundeffect.play()


func _on_Area2D2_body_entered(body):
	var hit_points = 2
	if body.is_in_group("player"):
		body.do_damage(hit_points)

