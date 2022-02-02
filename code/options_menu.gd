extends Control

func _ready():
	pass # Replace with function body.

func _on_Return_pressed():
	var options = load("res://scenes/options_menu.tscn").instance()
	get_tree().current_scene.remove_child(options)
