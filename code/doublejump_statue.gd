extends Area2D

var active = true

func _ready():
	connect("body_entered", self, "_on_doublejump_statue_body_entered")
	connect("body_exited", self, "_on_doublejump_statue_body_entered")

func _on_doublejump_statue_body_entered(body):
	if body.name == "player" and active:
		if get_node_or_null('DialogNode')== null:
			if active:
				get_tree().paused = true
				var dialog = Dialogic.start("/jump")
				dialog.pause_mode = Node.PAUSE_MODE_PROCESS
				dialog.connect('timeline_end', self, 'unpause')
				add_child(dialog)
				active = false
				body.respawn_point = self.position
				body.jump_ability = true
	
func unpause(timeline_name):
	get_tree().paused = false

