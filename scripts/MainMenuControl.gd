# File: scripts/MainMenuControl.gd
extends Control


func _on_exit_button_pressed() -> void:
	get_tree().quit()  # Exits the application
