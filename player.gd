extends CharacterBody2D

@export var SPEED = 20
@export var FRICTION = 0.9
@export var TOPSPEED = 100
var grav
const respawnPoint = Vector2(-128, -64)
var underwater = false
var doGravity = true
var inBoat = false
var HP = 100
var breath = 100

func _physics_process(delta: float) -> void:
	if(global_position.y >60):
		grav = 40
		underwater = true
	else:
		grav = 750
		underwater = false
	doGravity = true
	if (not is_on_floor() )and doGravity:
		velocity.y += grav * delta
	if(underwater):
		breath -= 4*delta
	else:
		breath = 100
	if(breath <= 0):
		HP -= 10*delta
	doMotion()
	respawn()
	move_and_slide()
	
func doMotion():
	if(!inBoat):
		visible = true
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x += direction * SPEED
		velocity.x *= FRICTION
		if(abs(velocity.x) < 1):
			velocity.x = 0
		if(abs(velocity.y)>TOPSPEED and underwater):
			velocity.y = TOPSPEED
		if(Input.is_action_pressed("ui_accept") and underwater):
			velocity.y -= 100	
			doGravity = true
		else:
			doGravity = true
	else:
		visible = false
		doGravity = false
		global_position = $"../../Boat".global_position
		if(Input.is_action_just_pressed("ui_down")):
				position.y += 20
				inBoat = false
func respawn():
	if(HP <= 0):
		global_position = respawnPoint
		velocity = Vector2(0,0)
		HP = 100
		
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	doGravity = false
	inBoat = true # Replace with function body.
	
 
