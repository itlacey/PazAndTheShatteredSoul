extends Area2D

var active = true

func _on_BirdSection1_body_entered(body):
	if body.name == "player" and active:
		if get_node_or_null('DialogNode')== null:
			if active:
				get_tree().paused = true
				var dialog = Dialogic.start("/BirdSection1")
				dialog.pause_mode = Node.PAUSE_MODE_PROCESS
				dialog.connect('timeline_end', self, 'unpause')
				add_child(dialog)
				body.respawn_point = Vector2(243, 1311)
				active = false
	
func unpause(timeline_name):
	get_tree().paused = false


