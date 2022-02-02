extends KinematicBody2D

onready var player = get_node("../player")
onready var sprite = $AnimatedSprite
onready var spriteattack = $AnimatedAttack
var final_boss_cut_over = false
var initial_cut_over = false
var attack_cycle_number = 1
var target = Vector2()
var is_dying = false
onready var _animation_player = $AnimatedSprite/AnimationPlayer
onready var state_machine = $AnimatedSprite/AnimationTree.get("parameters/playback")
onready var _attack_animation = $AnimatedAttack/AnimationPlayer
onready var soundeffect = $SoundEffect
onready var tw = $Tween
var timer
var timers
var rng = RandomNumberGenerator.new()
var on_platform = false
var off_platform = true
onready var audio_attack1 = load("res://assets/sound/boss_attack1.mp3")
onready var audio_attack2 = load("res://assets/sound/boss_attack2.mp3")
onready var audio_attack3 = load("res://assets/sound/boss_attack3.mp3")
onready var audio_attack1alt = load("res://assets/sound/boss_attack1_bombs.mp3")
onready var audio_attack2alt = load("res://assets/sound/boss_attack2_groundspikes.mp3")
onready var audio_attack3alt = load("res://assets/sound/boss_attack3_lightning.mp3")
onready var audio_death = load("res://assets/sound/boss_death.mp3")
onready var audio_transform = load("res://assets/sound/boss_transform.mp3")
onready var audio_damage = load("res://assets/sound/boss_damage.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.start("monkey")
	timer = Timer.new()
	timer.set_wait_time(4) #value is in seconds: 600 seconds = 10 minutes
	timer.set_one_shot(true)
	add_child(timer) 
	timers = Timer.new()
	timers.set_wait_time(4) #value is in seconds: 600 seconds = 10 minutes
	#for testing uncomment below
	#timers.set_wait_time(100) #value is in seconds: 600 seconds = 10 minutes
	timers.set_one_shot(true)
	add_child(timers) 
	

func _physics_process(delta):
	if is_dying:
		yield()
	if final_boss_cut_over and not initial_cut_over:
		timers.start()
		state_machine.travel("fly")
		initial_cut_over = true
	if initial_cut_over:
		attack_cycle()
	var angle = global_position.angle_to_point(player.global_position)
	if abs(angle) > PI/2:
		sprite.scale.x = -1
		spriteattack.scale.x = -1
	else:
		sprite.scale.x = 1
		spriteattack.scale.x = 1
		
		
func attack_cycle():
	var number = rng.randi_range(2090, 2430)
	var boss_health = get_node("Area2D").final_boss_health
	if boss_health <= 5:
		timer.set_wait_time(2)
	if attack_cycle_number == 1 and timer.get_time_left() == 0 and timers.get_time_left() == 0:
		state_machine.travel("attack1")
		if off_platform:
			target = Vector2(number,-290)
		else:
			target = player.get_position()
		tw.interpolate_property( self, "position", position, target , 3, Tween.TRANS_QUINT, Tween.TRANS_SINE)
		tw.start()
		timer.start() 
		attack_cycle_number = 2
	elif attack_cycle_number == 2 and timer.get_time_left() == 0:
		state_machine.travel("attack2")
		if off_platform:
			target = Vector2(number,-290)
		else:
			target = player.get_position()
		tw.interpolate_property( self, "position", position, target , 3, Tween.TRANS_QUINT, Tween.TRANS_SINE)
		tw.start()
		timer.start() 
		attack_cycle_number = 3
	elif attack_cycle_number == 3 and timer.get_time_left() == 0:
		state_machine.travel("attack3")
		if off_platform:
			target = Vector2(number,-290)
		else:
			target = player.get_position()
		tw.interpolate_property( self, "position", position, target , 3, Tween.TRANS_QUINT, Tween.TRANS_SINE)
		tw.start()
		timer.start() 
		attack_cycle_number = 1
	

func attack1():
	_attack_animation.play("bomb")
func attack2():
	_attack_animation.play("ground")
func attack3():
	_attack_animation.play("lightning")





func _on_Area2Dbomb_body_entered(body):
	var hit_points = 4
	if body.is_in_group("player"):
		body.do_damage(hit_points)


func _on_Area2Dlightning_body_entered(body):
	var hit_points = 5
	if body.is_in_group("player"):
		body.do_damage(hit_points)


func _on_Area2Dground_body_entered(body):
	var hit_points = 3
	if body.is_in_group("player"):
		body.do_damage(hit_points)

func _on_Area2D_body_entered(body):
	var hit_points = 3
	if body.is_in_group("player"):
		body.do_damage(hit_points)


func _on_leftplatform_body_entered(body):
	if body.is_in_group("player"):
		on_platform = true
		off_platform = false

func _on_middleplatform_body_entered(body):
	if body.is_in_group("player"):
		on_platform = true
		off_platform = false

func _on_rightplatform_body_entered(body):
	if body.is_in_group("player"):
		on_platform = true
		off_platform = false


func _on_leftplatform_body_exited(body):
	if body.is_in_group("player"):
		on_platform = false
		off_platform = true


func _on_middleplatform_body_exited(body):
	if body.is_in_group("player"):
		on_platform = false
		off_platform = true


func _on_rightplatform_body_exited(body):
	if body.is_in_group("player"):
		on_platform = false
		off_platform = true
		
func audio_attack1():
	audio_attack1.set_loop(false)
	soundeffect.set_stream(audio_attack1)
	soundeffect.play()
func audio_attack1alt():
	audio_attack1alt.set_loop(false)
	soundeffect.set_stream(audio_attack1alt)
	soundeffect.play()
func audio_attack2():
	audio_attack2.set_loop(false)
	soundeffect.set_stream(audio_attack2)
	soundeffect.play()
func audio_attack2alt():
	audio_attack2alt.set_loop(false)
	soundeffect.set_stream(audio_attack2alt)
	soundeffect.play()
func audio_attack3():
	audio_attack3.set_loop(false)
	soundeffect.set_stream(audio_attack3)
	soundeffect.play()
func audio_attack3alt():
	audio_attack3alt.set_loop(false)
	soundeffect.set_stream(audio_attack3alt)
	soundeffect.play()
func audio_death():
	audio_death.set_loop(false)
	soundeffect.set_stream(audio_death)
	soundeffect.play()
func audio_transform():
	audio_transform.set_loop(false)
	soundeffect.set_stream(audio_transform)
	soundeffect.play()
func audio_damage():
	audio_damage.set_loop(false)
	soundeffect.set_stream(audio_damage)
	soundeffect.play()
