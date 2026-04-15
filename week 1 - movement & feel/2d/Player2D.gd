class_name Player2D
extends CharacterBody2D

@export var animation: AnimatedSprite2D

@export_group("Player Data")
@export var move_speed: float = 200
@export var run_multiplier: float = 2.0
@export var jump_force: float = 350
@export var friction: float = 20
@export var acceleration: float = 30

@export_group("Movement Multiplier")
@export var gravity_mult: float = 1
@export var jump_mult : float = 1

@export_group("Movement Feel")
@export var coyote_time: float = 0.2
@export var jump_buffer: float = 0.2
@export var double_tap_time: float = 0.25

@export_group("Shooting System")
@export var scene_peluru_biasa: PackedScene
@export var scene_peluru_api: PackedScene
@export var muzzle: Marker2D # Jangan lupa hubungkan node Muzzle di Inspector!

var _daftar_peluru: Array = []
var _indeks_peluru_aktif: int = 0

var _direction: float = 0
var _coyote_timer: float = 0
var _jump_buffer_timer: float = 0

var _last_left_tap: float = 0
var _last_right_tap: float = 0

var _is_running: bool = false

func _ready() -> void:
	_daftar_peluru = [scene_peluru_biasa, scene_peluru_api]
	
func _process(_delta: float) -> void:
	_animation()


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_mult
		_coyote_timer -= delta
	else:
		_coyote_timer = coyote_time

	# Jump buffer
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer

	_jump_buffer_timer -= delta

	_check_double_tap()
		
	if Input.is_action_just_pressed("tembak"):
		_tembak()
	# --------------------------

	_move()
	_jump()

	move_and_slide()


func _move() -> void:

	_direction = Input.get_axis("left", "right")

	var current_speed = move_speed

	if _is_running:
		current_speed *= run_multiplier

	if _direction != 0:
		velocity.x = move_toward(
			velocity.x,
			current_speed * _direction,
			acceleration
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			friction
		)


func _jump() -> void:

	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		velocity.y = -jump_force * jump_mult
		_jump_buffer_timer = 0
		_coyote_timer = 0


func _check_double_tap() -> void:

	if Input.is_action_just_pressed("right"):
		if Time.get_ticks_msec() - _last_right_tap < double_tap_time * 1000:
			_is_running = true
		_last_right_tap = Time.get_ticks_msec()

	if Input.is_action_just_pressed("left"):
		if Time.get_ticks_msec() - _last_left_tap < double_tap_time * 1000:
			_is_running = true
		_last_left_tap = Time.get_ticks_msec()

	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		_is_running = false


func _animation() -> void:

	if is_on_floor():
		if _direction != 0:
			if _is_running:
				animation.play("Move")
				animation.speed_scale = abs(velocity.x) / move_speed
				animation.speed_scale = 2.0
			else:
				animation.play("Move")
				animation.speed_scale = abs(velocity.x) / move_speed
				animation.speed_scale = 1.0
		else:
			animation.play("Idle")
			animation.speed_scale = 1.0
	else:
		if velocity.y > 0:
			animation.play("Fall")
		elif velocity.y < 0:
			animation.play("Jump")

	_facing_direction()


func _facing_direction() -> void:

	if _direction > 0:
		animation.flip_h = false
		if muzzle != null:
			muzzle.position.x = abs(muzzle.position.x) 
			
	elif _direction < 0:
		animation.flip_h = true
		if muzzle != null:
			muzzle.position.x = -abs(muzzle.position.x)

func _tembak() -> void:
	if _daftar_peluru.is_empty() or _daftar_peluru[_indeks_peluru_aktif] == null or muzzle == null:
		print("ERROR: Array peluru kosong!")
		return

	var peluru_baru = _daftar_peluru[_indeks_peluru_aktif].instantiate()
	
	var arah_tembakan = Vector2.LEFT if animation.flip_h else Vector2.RIGHT
	
	if "arah" in peluru_baru:
		peluru_baru.arah = arah_tembakan
		
		if arah_tembakan == Vector2.LEFT:
			peluru_baru.scale.x = -1 

	peluru_baru.global_position = muzzle.global_position
	
	_indeks_peluru_aktif += 1
	
	if _indeks_peluru_aktif >= _daftar_peluru.size():
		_indeks_peluru_aktif = 0
	
	get_tree().current_scene.add_child(peluru_baru)
