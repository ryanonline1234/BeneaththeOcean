extends Node2D

@export var speed := 80.0
@export var patrol_range := 160.0
@export var hit_cooldown := 1.0
@export var alert_distance := 100.0
@export var player_path: NodePath

var start_x := 0.0
var dir := 1
var last_hit := -999.0
var player := null

func _ready() -> void:
    start_x = position.x
    set_process(true)
    if player_path and has_node(player_path):
        player = get_node(player_path)

func _process(delta: float) -> void:
    position.x += dir * speed * delta
    if abs(position.x - start_x) > patrol_range:
        dir = -dir
        position.x = clamp(position.x, start_x - patrol_range, start_x + patrol_range)
    update()

func _draw() -> void:
    # simple enemy body
    draw_circle(Vector2.ZERO, 10, Color(0.6,0.2,0.2))
    draw_line(Vector2(-6,0), Vector2(-12,-4), Color(0.2,0.2,0.2), 2)
    # alert indicator if player is nearby
    if player:
        var dist = position.distance_to(player.position)
        if dist <= alert_distance:
            var p = Vector2(0, -18)
            draw_circle(p, 4, Color(1,0.2,0.2))
            draw_line(p + Vector2(-2, -2), p + Vector2(2, -6), Color(1,1,1), 2)
