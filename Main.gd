extends Node2D

@onready var player := $World/Player
@onready var oxygen_label := $UI/OxygenLabel
@onready var currency_label := $UI/CurrencyLabel

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    set_process(true)

func _process(delta: float) -> void:
    if player:
        oxygen_label.text = "Oxygen: %0.1f" % player.oxygen
        currency_label.text = "$%d" % player.currency
