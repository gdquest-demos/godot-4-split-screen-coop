extends CharacterBody2D

@export var speed := 600.0
@export var gravity := 4500.0
@export var jump_strengths := [1400.0, 1000.0]

@export var controls: Resource = null

var _jump_number := 0

@onready var _skin := %Skin2D


func _ready() -> void:
	if not controls:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis(controls.move_left, controls.move_right)
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta

	var is_jumping := Input.is_action_just_pressed(controls.jump)
	var is_jump_cancelled := Input.is_action_just_released(controls.jump) and velocity.y < 0.0

	if is_jumping and _jump_number < jump_strengths.size():
		velocity.y = -jump_strengths[_jump_number]
		_jump_number += 1
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_on_floor():
		_jump_number = 0

	move_and_slide()
	_skin.velocity = velocity
