extends Node2D

@export var speed := 220.0
@export var lifetime := 6.0
@export var target: NodePath

var _t := 0.0
var _target_node := null

func _ready() -> void:
    set_process(true)
    if target and has_node(target):
        _target_node = get_node(target)

func _process(delta: float) -> void:
    _t += delta
    if _t >= lifetime:
        queue_free(); return
    if _target_node:
        var dir = (_target_node.position - position).normalized()
        position += dir * speed * delta
    else:
        # simple idle swim right
        position.x += speed * 0.2 * delta

func _draw() -> void:
    # simple dolphin: arc body and tail
    draw_circle(Vector2.ZERO, 8, Color(0.4,0.7,0.9))
    draw_circle(Vector2(6,-2), 4, Color(0.2,0.5,0.8))
    draw_line(Vector2(-6,0), Vector2(-12,-4), Color(0.2,0.5,0.8), 2)
