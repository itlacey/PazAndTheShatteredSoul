extends Area2D

var active = true
onready var final_boss = get_node('../finalboss')
onready var animate = get_node('../finalboss/AnimatedSprite/AnimationTree').get("parameters/playback")
onready var player_respawn_point = get_node('../player').respawn_point
onready var song = get_node('../AudioStreamPlayer')
onready var final_boss_song = load("res://assets/sound/boss_music.mp3")


func _on_finalbosscut_body_entered(body):
	if body.name == "player" and active:
		if get_node_or_null('DialogNode')== null:
			if active:
				get_tree().paused = true
				var dialog = Dialogic.start("/finalbosscut")
				dialog.pause_mode = Node.PAUSE_MODE_PROCESS
				dialog.connect('timeline_end', self, 'unpause')
				add_child(dialog)
				body.respawn_point = Vector2(1979, -258)
				active = false
				song.set_stream(final_boss_song)
				song.play()
				animate.travel("transition")
				final_boss.final_boss_cut_over = true
	
func unpause(timeline_name):
	get_tree().paused = false

