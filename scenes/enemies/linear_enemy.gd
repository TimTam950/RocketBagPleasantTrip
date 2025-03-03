extends Area2D

@export var speed := 200.0
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile"):
		set_process(false)
		call_deferred("_disable_collision")
		speed = 0.0
		animated_sprite_2d.play("die")
		animated_sprite_2d.animation_finished.connect(func() -> void:
			queue_free()
		)
		
func _disable_collision():
	collision_shape_2d.disabled = false
