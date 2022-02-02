extends Node2D

onready var screen_size = OS.get_real_window_size()

func transition(dest) -> void:
	get_tree().paused = true
	
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = dest.position - screen_size / 2
	get_viewport().set_canvas_transform(canvas_transform)

	get_tree().paused = false


