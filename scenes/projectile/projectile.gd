extends Area2D

var speed := 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta


func _on_area_entered(area: Area2D) -> void:
	set_process(false)
	call_deferred("_disable_collision")
	animation_player.play("fade")
	animation_player.animation_finished.connect(func(_anim_name) -> void:
		queue_free()
	)

func _disable_collision():
	collision_shape_2d.disabled = false
