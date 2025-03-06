extends Control

@onready var label: Label = $Label

func _ready() -> void:
	SignalManager.points_scored.connect(update_score)
	
func update_score():
	label.text = "Current Score: %s" % State.app_state["current_score"]
	
	
