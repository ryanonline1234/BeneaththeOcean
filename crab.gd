extends CharacterBody2D


@export var SPEED := 100.0
@export var patrol_distance := 120.0
var start_pos: Vector2
var health = 2
var direction := 1.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	start_pos = global_position
	velocity = Vector2.ZERO
	animated_sprite.play("default")


func _physics_process(delta: float) -> void:
	visible = true
	var distance_from_start: float = global_position.x - start_pos.x
	if distance_from_start >= patrol_distance:
		direction = -1.0
	elif distance_from_start <= -patrol_distance:
		direction = 1.0

	velocity.x = SPEED * direction
	move_and_slide()
	

	
