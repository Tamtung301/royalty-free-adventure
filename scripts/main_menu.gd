extends MarginContainer

@onready var start: Button = $HBoxContainer/VBoxContainer/Start
@onready var options: Button = $HBoxContainer/VBoxContainer/Options
@onready var exit: Button = $HBoxContainer/VBoxContainer/Exit


func _on_start_pressed() -> void:
	print("Loading game...")
	get_tree().change_scene_to_file("res://scenes/first_world.tscn")

func _on_options_pressed() -> void:
	print("loading options...")


func _on_exit_pressed() -> void:
	get_tree().quit()
