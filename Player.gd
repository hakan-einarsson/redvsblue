extends KinematicBody2D

# Declare member variables here. Examples:
var gravity = 500
var speed = Vector2()
var run_speed = 150
var is_on_floor = false
var is_shooting=false
var shoot_timer=3
var health = 100
var shot_instance=load("res://Shot.tscn")
var smoke_puff_scene=load("res://SmokePuff.tscn")
var player_red=load("res://Assets/RedPlayer.png")
var player_blue=load("res://Assets/RedPlayer.png")
onready var anim_player=$Sprite/AnimationPlayer
onready var sprite = $Sprite
onready var on_ground_cast = $OnGroundCast
onready var timer = $Timer
var player_color= [load("res://Assets/RedPlayer.png"),
					load("res://Assets/BluePlayer.png")]

# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	sprite.set_texture(player_color[randi()%2])
	pass # Replace with function body.
	
func _input(event):
	
	if event.is_action_pressed("ui_quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_up") and is_on_floor:
		speed.y=0
		speed.y-=325
		
	if Input.is_action_pressed("ui_accept") and not is_shooting:
		is_shooting=true
		timer.start()
		anim_player.play("Shoot")	
		shoot()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		death()
	speed.x=run_speed*(int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))
	if on_ground_cast.is_colliding() and on_ground_cast.get_collider().name=="Map":
		is_on_floor=true
	else:
		is_on_floor=false
	speed.y+=gravity*delta
	if not is_shooting:
		run_animation()
	speed=move_and_slide(speed,Vector2(0,-1))
	
func run_animation():
	if speed.x < 0:
		sprite.set_flip_h(true)
	else:
		if speed.x !=0:
			sprite.set_flip_h(false)
	if speed.y < 0:
		anim_player.play("Jump")
	else:
		if is_on_floor:
			if speed.x != 0:
				anim_player.play("Walk")
			else:
				anim_player.play("Idle")
		else:
			anim_player.play("Falling")
			
func death():
	call_deferred("queue_free")


func _on_Timer_timeout():
	shoot_timer-=1
	if shoot_timer==0:
		is_shooting=false
		shoot_timer=3
		timer.stop()
		
func take_damage(amount):
	health-=amount
		
func shoot():
	var shot = shot_instance.instance()
	var smoke_puff=smoke_puff_scene.instance()
	get_parent().call_deferred("add_child",smoke_puff)
	get_parent().call_deferred("add_child",shot)
	shot.source=name
	if sprite.is_flipped_h():
		shot.speed*=-1
		shot.position = Vector2(position.x-25,position.y+3)
		smoke_puff.position = Vector2(position.x-25,position.y+3)
	else:
		shot.position = Vector2(position.x+25,position.y+3)
		smoke_puff.position = Vector2(position.x+25,position.y+3)