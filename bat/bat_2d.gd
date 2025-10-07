extends CharacterBody2D

@export var max_speed := 300.0
@export var drag_factor := 0.1

var _target: CharacterBody2D = null

@onready var _raycast: RayCast2D = %RayCast2D
@onready var _detect_area: Area2D = %DetectArea2D
@onready var _skin: Node2D = %BatSkin2D

@onready var _collision_shape: CircleShape2D = %CollisionShape2D.shape


func _ready() -> void:
	_detect_area.body_entered.connect(_on_player_entered)
	_detect_area.body_exited.connect(_on_player_exited)


func _physics_process(_delta: float) -> void:
	var direction := Vector2.UP
	if _target:
		_raycast.look_at(_target.global_position)
		_raycast.force_raycast_update()
		if _raycast.get_collider() == _target:
			var to_target := _target.global_position - global_position
			direction = to_target.normalized() if to_target.length() > _collision_shape.radius else Vector2.ZERO

	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor

	if _target == null and is_on_ceiling():
		velocity = Vector2.ZERO

	move_and_slide()
	_skin.velocity = velocity


func _on_player_entered(player: CharacterBody2D) -> void:
	_target = player


func _on_player_exited(_player: CharacterBody2D) -> void:
	_target = null
