extends "res://code/Actor.gd"

#onready var stomp_area: Area2D = $StompArea2D
onready var _animated_sprite = $AnimatedSprite
onready var player = get_node("../player")
var rat_direction = true
onready var rat = get_node("Area2D")
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var audio_attack = load('res://assets/sound/rat_attack.mp3')
onready var soundeffect = $SoundEffect
var currently_dying = false

func _ready() -> void:
	state_machine.start('run')
	set_physics_process(false)
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	if not currently_dying:
		var distance2Hero =  rat.global_position.distance_to(player.global_position)
		state_machine.travel('run')
		if distance2Hero < 45:
			state_machine.travel('attack')
		_velocity.x *= -1 if is_on_wall() else 1
		if _velocity.x > 0 :
			rat_direction = true 
		else:
			rat_direction = false
		get_node( "AnimatedSprite" ).set_flip_h(rat_direction)
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die() -> void:
	queue_free()

func audio_attack():
	audio_attack.set_loop(false)
	soundeffect.set_stream(audio_attack)
	soundeffect.play()

func _on_Area2D_body_entered(body):
	var hit_points = 1
	if body.is_in_group("player"):
		body.do_damage(hit_points)
