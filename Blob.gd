extends KinematicBody2D

var gravity = 350
var speed = 1000
var movement = Vector2()
var jumpSpeed = 200
var health = 30
var damage = 10
var knockback = 250
onready var anim_player = $Sprite/AnimationPlayer
var is_jumping=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <=0:
		death()
	check_for_ray_collision(delta)
	if is_on_floor():
		anim_player.play("Blob")
	movement.y+=gravity*delta
	movement=move_and_slide(movement,Vector2(0,-1))
	
func jump():
	movement.y=-jumpSpeed
	is_jumping=true

func fall():
	movement.y=0
	is_jumping=false

func take_damage(amount,source,knockback):
	health-=amount
	
func death():
	var blob_explosion = load("res://BlobExplosion.tscn").instance()
	get_parent().call_deferred("add_child",blob_explosion)
	blob_explosion.position=position
	call_deferred("queue_free")

func check_for_ray_collision(delta):
	if not $RayLeft.is_colliding():
		movement.x=speed*delta
	if not $RayRight.is_colliding():
		movement.x=-speed*delta

func _on_Area2D_body_entered(body):
	if body != self:
		print(body.name)
		body.take_damage(damage,self,knockback)
