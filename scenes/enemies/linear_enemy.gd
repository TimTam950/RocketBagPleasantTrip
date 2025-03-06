extends BaseEnemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	
func move(delta: float):
	position.x -= speed * delta
