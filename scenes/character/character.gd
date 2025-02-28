extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D

@export var gravity := 300.0
@export var flight_speed := 250.0
var _current_state = CharacterState.IDLE
var _can_shoot := true

enum CharacterState {
	IDLE,
	FLYING,
	FALLING,
	FLY_SHOOTING,
	SHOOTING
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fly") and Input.is_action_pressed("shoot"):
		change_state(CharacterState.FLY_SHOOTING)
	elif Input.is_action_pressed("fly"):
		change_state(CharacterState.FLYING)
	elif Input.is_action_pressed("shoot"):
		change_state(CharacterState.SHOOTING)
	else:
		if is_on_floor():
			change_state(CharacterState.IDLE)
		else:
			change_state(CharacterState.FALLING)
	move_and_slide()
	
func change_state(new_state: CharacterState):
	_current_state = new_state
	match _current_state:
		CharacterState.IDLE:
			animated_sprite_2d.play("walking")
			animated_sprite_2d.offset.x = 0.0
		CharacterState.FLYING:
			animated_sprite_2d.play("fly")
			animated_sprite_2d.offset.x = -100.0
			velocity.y = -250.0
		CharacterState.FALLING:
			animated_sprite_2d.play("idle")
			animated_sprite_2d.offset.x = 0.0
			velocity.y = 300
		CharacterState.FLY_SHOOTING:
			animated_sprite_2d.play("fly_shoot")
			animated_sprite_2d.offset.x = 0.0
			velocity.y = -250.0
			if _can_shoot:
				shoot()
		CharacterState.SHOOTING:
			if is_on_floor():
				animated_sprite_2d.play("ground_shoot")
				velocity.y = 300.0
				animated_sprite_2d.offset.x = 0.0
			else:
				animated_sprite_2d.play("fly_shoot")
				animated_sprite_2d.offset.x = 0.0
				velocity.y = 300.0
			if _can_shoot:
				shoot()
				
func shoot():
	SignalManager.shoot.emit(self.global_position)
	_can_shoot = false

func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
