class_name Door extends Node3D

@onready var animPlayer:AnimationPlayer = $AnimationPlayer

const CLOSE="DoorClose"
const OPEN="DoorOpen"

var status = 0

func interact():
	if(!animPlayer.is_playing()):
		if(status == 0):
			animPlayer.play(OPEN)
			status = 1
		else:
			animPlayer.play(CLOSE)
			status = 0
