extends Node2D

@export var speed := 80.0
@export var patrol_range := 160.0
@export var hit_cooldown := 1.0

var start_x := 0.0
var dir := 1
var last_hit := -999.0

func _ready() -> void:
    start_x = position.x
    set_process(true)

func _process(delta: float) -> void:
    position.x += dir * speed * delta
    if abs(position.x - start_x) > patrol_range:
        dir = -dir
        position.x = clamp(position.x, start_x - patrol_range, start_x + patrol_range)
    update()

func _draw() -> void:
    # simple shark/crab like shape
    draw_circle(Vector2.ZERO, 10, Color(0.6,0.2,0.2))
    draw_line(Vector2(-6,0), Vector2(-12,-4), Color(0.2,0.2,0.2), 2)
