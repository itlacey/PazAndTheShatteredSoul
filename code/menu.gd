extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/level1.tscn")


func _on_OptionsButton_pressed():
	var options = load("res://scenes/options_menu.tscn").instance()
	get_tree().current_scene.add_child(options)

func _on_QuitButton_pressed():
	get_tree().quit()
	
