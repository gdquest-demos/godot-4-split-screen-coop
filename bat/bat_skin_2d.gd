extends Node2D

@onready var _animation_player: AnimationPlayer = %AnimationPlayer

var velocity := Vector2.ZERO


func play(animation: String) -> void:
	_animation_player.play(animation)


func _physics_process(_delta: float) -> void:
	var horizontal_direction := signf(velocity.x)
	if not is_zero_approx(horizontal_direction):
		scale.x = sign(horizontal_direction)

	var is_hanging := velocity.is_zero_approx()
	if is_hanging:
		_animation_player.play("hang")
	else:
		_animation_player.play("fly")
