extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var i_frame_timer: Timer = $IFrameTimer

@export var gravity := 300.0
@export var flight_speed := 250.0
var _current_state = CharacterState.IDLE
var _can_shoot := true
var _can_take_damage := true
var health: int = 3

enum CharacterState {
	IDLE,
	FLYING,
	FALLING,
	FLY_SHOOTING,
	SHOOTING
}

func _ready() -> void:
	SignalManager.take_damage.connect(take_damage)
	health_bar.max_value = health
	
func _physics_process(_delta: float) -> void:
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
			
			animated_sprite_2d.offset.x = 0.0
			velocity.y = -250.0
			if _can_shoot:
				shoot()
				animated_sprite_2d.play("fly_shoot")
		CharacterState.SHOOTING:
			if is_on_floor():
				if _can_shoot:
					shoot()
					animated_sprite_2d.play("ground_shoot")
				velocity.y = 300.0
				animated_sprite_2d.offset.x = 0.0
			else:
				if _can_shoot:
					shoot()
					animated_sprite_2d.play("fly_shoot")
				animated_sprite_2d.offset.x = 0.0
				velocity.y = 300.0
						
func shoot():
	SignalManager.shoot.emit(self.global_position)
	_can_shoot = false
	shoot_timer.start()
	
func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
	
func take_damage():
	if _can_take_damage:
		health -= 1
		health_bar.value = health
		_can_take_damage = false
		i_frame_timer.start()
		if health == 0:
			save()
			get_tree().change_scene_to_file("res://scenes/death_screen/death_screen.tscn")
	
func _on_i_frame_timer_timeout() -> void:
	_can_take_damage = true
	
func save():
	if State.app_state["current_score"] > State.app_state["high_score"]:
		State.app_state["high_score"] = State.app_state["current_score"]
		State.app_state["current_score"] = 0
		var fa = FileAccess.open("user://scores.dat", FileAccess.WRITE)
		fa.store_line(JSON.stringify(State.app_state))
