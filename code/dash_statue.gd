extends Area2D

var active = true
#func _ready():
#	connect("body_entered", self, "_on_BirdSection1_body_entered")
#	connect("body_exited", self, "_on_BirdSection1_body_exited")

func _on_dash_statue_body_entered(body):
	if body.name == "player" and active:
		if get_node_or_null('DialogNode')== null:
			if active:
				get_tree().paused = true
				var dialog = Dialogic.start("/dash")
				dialog.pause_mode = Node.PAUSE_MODE_PROCESS
				dialog.connect('timeline_end', self, 'unpause')
				add_child(dialog)
				active = false
				body.respawn_point = self.position
				body.dash_ability = true
	
func unpause(timeline_name):
	get_tree().paused = false

