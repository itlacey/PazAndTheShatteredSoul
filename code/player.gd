extends KinematicBody2D

onready var soundeffect = $SoundEffect
onready var _animated_sprite = get_node("AnimatedSprite/AnimationPlayer")
onready var sprite = get_node( "AnimatedSprite" )
onready var state_machine = $AnimatedSprite/AnimationTree.get("parameters/playback")
onready var attack_slice_col = $AnimatedSprite/SwordHit/AttackSliceCollision
onready var attack_chop_col = $AnimatedSprite/SwordChopHit/AttackChopCollision
onready var health_label = get_node('../player/Camera2D/Label')
onready var final_boss_health = get_node("../finalboss/Area2D").final_boss_health




onready var run_audio_1 = load('res://assets/sound/footsteps/footsteps-001.mp3')
onready var run_audio_2 = load('res://assets/sound/footsteps/footsteps-002.mp3')
onready var run_audio_3 = load('res://assets/sound/footsteps/footsteps-003.mp3')
onready var run_audio_4 = load('res://assets/sound/footsteps/footsteps-004.mp3')
onready var run_audio_5 = load('res://assets/sound/footsteps/footsteps-005.mp3')
onready var run_audio_6 = load('res://assets/sound/footsteps/footsteps-006.mp3')
onready var run_audio_7 = load('res://assets/sound/footsteps/footsteps-007.mp3')
onready var run_audio_8 = load('res://assets/sound/footsteps/footsteps-008.mp3')
onready var run_audio_9 = load('res://assets/sound/footsteps/footsteps-009.mp3')
onready var run_audio_10 = load('res://assets/sound/footsteps/footsteps-010.mp3')
onready var jump_audio_1 = load("res://assets/sound/jumpland/jumpland-001.mp3")
onready var jump_audio_2 = load("res://assets/sound/jumpland/jumpland-002.mp3")
onready var jump_audio_3 = load("res://assets/sound/jumpland/jumpland-003.mp3")
onready var jump_audio_4 = load("res://assets/sound/jumpland/jumpland-004.mp3")
onready var jump_audio_5 = load("res://assets/sound/jumpland/jumpland-005.mp3")
onready var jump_audio_6 = load("res://assets/sound/jumpland/jumpland-006.mp3")
onready var jump_audio_7 = load("res://assets/sound/jumpland/jumpland-007.mp3")
onready var jump_audio_8 = load("res://assets/sound/jumpland/jumpland-008.mp3")
onready var jump_audio_9 = load("res://assets/sound/jumpland/jumpland-009.mp3")
onready var jump_audio_10 = load("res://assets/sound/jumpland/jumpland-010.mp3")
onready var spike_death_audio = load('res://assets/sound/spikedeath.mp3')
onready var hurt_audio = load('res://assets/sound/playerdamage.mp3')
onready var slice_audio = load("res://assets/sound/swordslash.mp3")
onready var chop_audio = load("res://assets/sound/swordchop.mp3")
onready var dash_audio = load("res://assets/sound/dash.mp3")

const UP = Vector2(0,-1)
var motion = Vector2()
export var speed = 200
export var gravity = 20
export var jumpForce = 400
export var dash_speed = 400
var slide_gravity = 85

var current_portal = false
var portal_bot_1_to_2 = false
var portal_bot_2_to_1 = false
var portal_mid_1_to_2 = false
var portal_mid_2_to_1 = false

var jump_counter = 0
var jump_ability = false
var has_double_jumped = false
var dash_ability = false
var is_dashing = false
var slide_ability = true
var has_wall_jumped = false
var no_jump_collision = false
var health = 20
var currently_dying = false

var rng = RandomNumberGenerator.new()
var foottimer = Timer.new()

var respawn_point = Vector2()

func _ready():
	attack_slice_col.set_disabled(true)
	attack_chop_col.set_disabled(true)

func _physics_process(delta):
	health_label.text = 'Health: '+str(health)
	get_input()
	motion = move_and_slide(motion, UP)

func get_input():
	rng.randomize()
	motion.y += gravity
	motion.x = 0
	var current = state_machine.get_current_node()
	
	if not currently_dying:
		
		if motion.x == 0 and is_on_floor():
			state_machine.travel("idle")
		if motion.x != 0 and motion.y == gravity:
			state_machine.travel('run')
			
		if Input.is_action_pressed("ui_right"):
			sprite.scale.x = 1
			motion.x = speed
			state_machine.travel('run')
			
		if Input.is_action_just_pressed("ui_dash") and dash_ability and not sprite.is_flipped_h():
			_animated_sprite.stop(true) 
			state_machine.travel('dash')
			motion.x = speed * 60
		if Input.is_action_just_pressed("ui_dash") and dash_ability and sprite.is_flipped_h():
			_animated_sprite.stop(true) 
			state_machine.travel('dash')
			motion.x = - speed * 60
			
		if Input.is_action_pressed("ui_left"):
			sprite.scale.x = -1
			motion.x = -speed
			state_machine.travel('run')
			if Input.is_action_just_pressed("ui_dash") and dash_ability:
				is_dashing = true
				_animated_sprite.stop(true) 
				state_machine.travel('dash')
				motion.x = -speed * 60
				
		if Input.is_action_pressed("ui_attack"):
			state_machine.travel('slice')
			motion.x = 0
			return
		if Input.is_action_pressed("ui_chop"):
			state_machine.travel('chop')
			motion.x = 0
			return
			
				
		if Input.is_action_just_pressed("ui_up"):
			state_machine.travel('jump')
			if is_on_floor():
				audio_jump()
				jump()
			elif not(has_double_jumped) and jump_ability:
				state_machine.travel('jump')
				audio_dash()
				jump()
				has_double_jumped = true

	if is_on_floor():
		has_double_jumped = false
	
	
func jump():
	motion.y = -jumpForce
	## add wall slide timer
	
func wall_jump():
	motion.y = -jumpForce * 10
	

### portals
func _on_BottomPoral1_body_entered(body):
	var destination = get_node("../Portals/BottomPoral2")
	if not current_portal:
		self.set_position(destination.position)
		current_portal = true
		portal_bot_1_to_2 = true
		
func _on_BottomPoral2_body_entered(body):
	var destination = get_node("../Portals/BottomPoral1")
	if not current_portal:
		self.set_position(destination.position)
		current_portal = true
		portal_bot_2_to_1 = true

func _on_BottomPoral1_body_exited(body):
	if not portal_bot_1_to_2:
		current_portal = false
	portal_bot_1_to_2 = false

func _on_BottomPoral2_body_exited(body):
	if not portal_bot_2_to_1:
		current_portal = false
	portal_bot_2_to_1 = false

func _on_MidPortal1_body_entered(body):
	var destination = get_node("../Portals/MidPortal2")
	if not current_portal:
		self.set_position(destination.position)
		current_portal = true
		portal_mid_1_to_2 = true

func _on_MidPortal2_body_entered(body):
	var destination = get_node("../Portals/MidPortal1")
	if not current_portal:
		self.set_position(destination.position)
		current_portal = true
		portal_mid_2_to_1 = true
	
func _on_MidPortal1_body_exited(body):
	if not portal_mid_1_to_2:
		current_portal = false
	portal_mid_1_to_2 = false

func _on_MidPortal2_body_exited(body):
	if not portal_mid_2_to_1:
		current_portal = false
	portal_mid_2_to_1 = false

### spikebox deaths
func _on_lowerspikehitbox_body_entered(body):
	if body.name == "player":
		spike_death_audio.set_loop(false)
		soundeffect.set_stream(spike_death_audio)
		soundeffect.play()
		state_machine.travel("die")
func _on_lowerspikehitbox1_body_entered(body):
	if body.name == "player":
		spike_death_audio.set_loop(false)
		soundeffect.set_stream(spike_death_audio)
		soundeffect.play()
		state_machine.travel("die")
func _on_lowerspikehitbox2_body_entered(body):
	if body.name == "player":
		spike_death_audio.set_loop(false)
		soundeffect.set_stream(spike_death_audio)
		soundeffect.play()
		state_machine.travel("die")
func _on_lowerspikehitbox3_body_entered(body):
	if body.name == "player":
		spike_death_audio.set_loop(false)
		soundeffect.set_stream(spike_death_audio)
		soundeffect.play()
		state_machine.travel("die")



func audio_run():
	var number = rng.randi_range(0, 10)
	var sfx = run_audio_1.set_loop(false)
	if number == 1:
		run_audio_1.set_loop(false)
		sfx = run_audio_1
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 2:
		run_audio_2.set_loop(false)
		sfx = run_audio_2
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 3:
		run_audio_3.set_loop(false)
		sfx = run_audio_3
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 4:
		run_audio_4.set_loop(false)
		sfx = run_audio_4
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 5:
		run_audio_5.set_loop(false)
		sfx = run_audio_5
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 6:
		run_audio_6.set_loop(false)
		sfx = run_audio_6
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 7:
		run_audio_7.set_loop(false)
		sfx = run_audio_7
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 8:
		run_audio_8.set_loop(false)
		sfx = run_audio_8
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 9:
		run_audio_9.set_loop(false)
		sfx = run_audio_9
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 10:
		run_audio_10.set_loop(false)
		sfx = run_audio_10
		soundeffect.set_stream(sfx)
		soundeffect.play()

func audio_jump():
	var number = rng.randi_range(0, 10)
	var sfx = jump_audio_1.set_loop(false)
	if number == 1:
		jump_audio_1.set_loop(false)
		sfx = jump_audio_1
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 2:
		jump_audio_2.set_loop(false)
		sfx = jump_audio_2
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 3:
		jump_audio_3.set_loop(false)
		sfx = jump_audio_3
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 4:
		jump_audio_4.set_loop(false)
		sfx = jump_audio_4
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 5:
		jump_audio_5.set_loop(false)
		sfx = jump_audio_5
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 6:
		jump_audio_6.set_loop(false)
		sfx = jump_audio_6
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 7:
		jump_audio_7.set_loop(false)
		sfx = jump_audio_7
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 8:
		jump_audio_8.set_loop(false)
		sfx = jump_audio_8
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 9:
		jump_audio_9.set_loop(false)
		sfx = jump_audio_9
		soundeffect.set_stream(sfx)
		soundeffect.play()
	if number == 10:
		jump_audio_10.set_loop(false)
		sfx = jump_audio_10
		soundeffect.set_stream(sfx)
		soundeffect.play()

func _on_SwordHit_area_entered(area):
	var hit_points = 1
	if area.is_in_group("enemies"):
		area.do_damage(hit_points)

func _on_SwordChopHit_area_entered(area):
	var hit_points = 2
	if area.is_in_group("enemies"):
		area.do_damage(hit_points)

func wall_slide_jump_helper():
	no_jump_collision = true


func audio_slice():
	slice_audio.set_loop(false)
	soundeffect.set_stream(slice_audio)
	soundeffect.play()

func audio_chop():
	chop_audio.set_loop(false)
	soundeffect.set_stream(chop_audio)
	soundeffect.play()


func do_damage(hit_points):
	sprite.modulate = Color( 1, 0, 0, 1 )
	health = health - hit_points
	hurt_audio.set_loop(false)
	soundeffect.set_stream(hurt_audio)
	soundeffect.play()
	if health <= 0:
		state_machine.travel("die")
	yield(get_tree().create_timer(.1), "timeout")
	sprite.modulate = Color( 1, 1, 1, 1 )
		
func respawn():
	self.set_position(respawn_point)
	final_boss_health = 15
	health = 20
	_animated_sprite.play("reverse_die")

func audio_dash():
	dash_audio.set_loop(false)
	soundeffect.set_stream(dash_audio)
	soundeffect.play()

func start_death():
	currently_dying = true
	
func end_death():
	currently_dying = false

