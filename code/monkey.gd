extends "res://code/Actor.gd"

#onready var stomp_area: Area2D = $StompArea2D
onready var _animated_sprite = $AnimatedSprite/AnimationPlayer
onready var player = get_node("../player")
onready var sprite = $AnimatedSprite


func _ready() -> void:
	_animated_sprite.play('combine')

