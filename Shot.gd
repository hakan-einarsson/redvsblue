extends KinematicBody2D

var speed = 1000
var direction = Vector2()
var source=null
var damage = 10
var knockback = 250



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction.x=speed*delta
	var collision = move_and_collide(direction)
	if collision and collision.collider.name != source:
		call_deferred("queue_free")
		var collision_body = collision.collider
		collision_body.take_damage(damage,self,knockback)
		
func take_damage(amount,something,sometingelse):
	pass
		
