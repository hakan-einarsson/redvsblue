extends Node2D

# Declare member variables here. Examples:
# var a = 2
var count = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	print("smoke")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	count-=1
	if count == 0:
		call_deferred("queue_free")
