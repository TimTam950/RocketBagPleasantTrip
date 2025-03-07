extends Control

@onready var high_score: Label = %HighScore


func _ready() -> void:
	var previous_game_state: Dictionary
	if FileAccess.file_exists("user://scores.dat"):
		var fa := FileAccess.open("user://scores.dat", FileAccess.READ)
		var content = fa.get_as_text()
		previous_game_state = JSON.parse_string(content)
		State.app_state = previous_game_state
	
	State.app_state["current_score"] = 0
	high_score.text = "High Score: %d" % State.app_state["high_score"]
	print(State.app_state)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
