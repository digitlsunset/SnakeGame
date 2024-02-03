extends Control


func PlayPressed():
	get_tree().change_scene_to_file("res://Scenes/Snake.tscn")


func ExitPressed():
	get_tree().quit()
