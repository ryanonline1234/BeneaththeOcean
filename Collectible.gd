extends Node2D

@export var value: int = 1
@export var radius: float = 18.0
@export var color: Color = Color(1,0.9,0.2)
@export var player_path: NodePath = NodePath("../../Player")

var player: Node = null

func _ready() -> void:
    set_process(true)
    # try to resolve player node; if not found we'll look up every frame
    if has_node(player_path):
        player = get_node(player_path)
    update()

func _process(delta: float) -> void:
    if player == null:
        if has_node(player_path):
            player = get_node(player_path)
    if player:
        var dist = position.distance_to(player.position)
        if dist <= radius + 8: # pickup threshold
            _collect()

func _collect() -> void:
    if player and player.has_method("add_currency"):
        player.call("add_currency", value)
    # simple pop effect could be added here (tween), but free for now
    queue_free()

func _draw() -> void:
    draw_circle(Vector2.ZERO, radius, color)
    draw_circle(Vector2.ZERO, radius*0.6, color.lightened(0.2))
