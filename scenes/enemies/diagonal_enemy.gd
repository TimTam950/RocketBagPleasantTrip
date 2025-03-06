extends BaseEnemy

var direction_vector: Vector2 = Vector2(-1, -1)

func _ready() -> void:
	speed = 200.0
	points = 20.0

func _process(delta: float) -> void:
	move(delta)
	
func move(delta: float):
	position += direction_vector.normalized() * (speed * delta)

func _on_timer_timeout() -> void:
	direction_vector.y = direction_vector.y * -1
