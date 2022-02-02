extends Area2D

onready var camera = get_node("../MainCamera")

export var camera_x = 185
export var camera_y = 96*3

var camera_position = Vector2(camera_x,camera_y)

func _on_body_entered(body):
	camera.set_position(camera_position)
