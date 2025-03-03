extends Node2D

const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")

var enemies: Array[PackedScene] = [
	preload("res://scenes/enemies/linear_enemy.tscn")
]

@export var low_spawn: Marker2D
@export var high_spawn: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.shoot.connect(player_shoot)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func player_shoot(spawn_position: Vector2):
	var projectile := PROJECTILE.instantiate()
	projectile.position = spawn_position
	projectile.z_index = 2
	add_sibling(projectile)


func _on_enemy_spawn_timer_timeout() -> void:
	var spawn_location_y = randf_range(low_spawn.position.y, high_spawn.position.y)
	var spawn_location_x = low_spawn.position.x
	var spawn_location = Vector2(spawn_location_x, spawn_location_y)
	
	var enemy = enemies.pick_random().instantiate()
	enemy.position = spawn_location
	add_sibling(enemy)
