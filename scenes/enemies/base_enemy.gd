extends Area2D

class_name BaseEnemy

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

var speed: float = 100
var points: int = 10

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile"):
		call_deferred("_disable_collision")
		speed = 0.0
		animated_sprite_2d.play("die")
		State.app_state["current_score"] = State.app_state["current_score"] + points
		SignalManager.points_scored.emit()
		animated_sprite_2d.animation_finished.connect(func() -> void:
			queue_free()
		)
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		SignalManager.take_damage.emit()
func _disable_collision():
	collision_shape_2d.disabled = false
	
func move(delta: float):
	pass
