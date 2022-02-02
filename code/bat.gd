extends "res://code/Actor.gd"

onready var player = get_node("../player")
onready var sprite = $AnimatedSprite
var rat_direction = true
onready var rat = get_node("Area2D")
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var audio_attack = load("res://assets/sound/bat_attack.mp3")
onready var soundeffect = $SoundEffect
onready var tw = $Tween
var currently_dying = false
var timer
var timers
var target


func _ready():
	state_machine.start("idle")
	timer = Timer.new()
	timer.set_wait_time(2) #value is in seconds: 600 seconds = 10 minutes
	timer.set_one_shot(true)
	add_child(timer) 
	timers = Timer.new()
	timers.set_wait_time(4) #value is in seconds: 600 seconds = 10 minutes
	#for testing uncomment below
	#timers.set_wait_time(100) #value is in seconds: 600 seconds = 10 minutes
	timers.set_one_shot(true)
	add_child(timers) 
	

func _physics_process(delta):
	timers.start()
	var distance2Hero =  rat.global_position.distance_to(player.global_position)
	if distance2Hero < 200:
		attack_cycle()
	var angle = global_position.angle_to_point(player.global_position)
	if abs(angle) > PI/2:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
		
		
func attack_cycle():
	if timer.get_time_left() == 0 :
		state_machine.travel("attack")
		target = player.get_position()
		target.y =  target.y - 5
		tw.interpolate_property( self, "position", position, target , 1.5, Tween.TRANS_QUINT, Tween.TRANS_SINE)
		tw.start()
		timer.start() 
		target = player.get_position()
		target.y =  target.y - 80
		yield(get_tree().create_timer(.4), "timeout")
		tw.interpolate_property( self, "position", position, target , 4, Tween.TRANS_QUINT, Tween.TRANS_SINE)
		tw.start()
	
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
