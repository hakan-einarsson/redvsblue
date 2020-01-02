extends Node2D

var counter=0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	counter+=1
	if counter == 10:
		call_deferred("queue_free")
