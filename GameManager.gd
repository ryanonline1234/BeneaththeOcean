extends Node

@export var collectible_scene: PackedScene = preload("res://Collectible.tscn")
@export var spawn_width := 800
@export var spawn_depth := 1200
@export var initial_spawn := 24
@export var player_path := NodePath("World/Player")

onready var player := get_node_or_null(player_path)
onready var container := get_node_or_null("World/CollectibleContainer")

func _ready() -> void:
    randomize()
    if container == null:
        container = get_node("World").get_node("CollectibleContainer")
    if player == null:
        player = get_node("World").get_node("Player")
    _spawn_initial()
    if player:
        player.connect("surfaced", Callable(self, "_on_player_surfaced"))
        player.connect("collected", Callable(self, "_on_collected"))

func _spawn_initial() -> void:
    for i in range(initial_spawn):
        _spawn_collectible_random()

func _spawn_collectible_random() -> void:
    var c = collectible_scene.instantiate()
    var x = randf_range(-spawn_width/2, spawn_width/2)
    var y = randf_range(40, spawn_depth)
    c.position = Vector2(x, y)
    c.value = randi_range(1, 5)
    c.color = Color(1, 0.8 - randf() * 0.6, 0.2 + randf() * 0.8)
    container.add_child(c)

func _on_collected(amount: int) -> void:
    # placeholder
    pass

func _on_player_surfaced() -> void:
    if not player: return
    var ppos = player.position
    if abs(ppos.x) < 60:
        _sell_all()

func _sell_all() -> void:
    if not player: return
    var gained = player.currency
    player.currency = 0
    if gained > 0:
        player.oxygen_max += int(gained / 20) * 2
        player.oxygen = player.oxygen_max
