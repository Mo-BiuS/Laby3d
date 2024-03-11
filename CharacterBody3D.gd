extends Node3D

const NORTH = 0
const EAST = 1
const SOUTH = 2
const WEST = 3

var direction:int = NORTH;
var destMvm:Vector3
var destRot:float

const MVM_SPEED = 1.5
const ROT_SPEED = 2

@onready var frontCast:RayCast3D = $FrontCast
@onready var backCast:RayCast3D = $BackCast
@onready var frontCastBackward:RayCast3D = $FrontCastBackward
@onready var backCastBackward:RayCast3D = $BackCastBackward

signal action(pos:Vector3,frontPos:Vector3)

func _ready():
	destMvm = position
	destRot = rotation.y

func _process(delta):
	handleInput()
	handleMvm(delta)
	handleRotation(delta)

func handleMvm(delta):
	if(destMvm != position):
		var distX = position.x-destMvm.x
		if(distX != 0):
			if(distX > 0):
				position.x = position.x-delta*MVM_SPEED
				if(position.x-destMvm.x < 0):position=destMvm
			if(distX < 0):
				position.x = position.x+delta*MVM_SPEED
				if(position.x-destMvm.x > 0):position=destMvm
		var distZ = position.z-destMvm.z
		if(distZ != 0):
			if(distZ > 0):
				position.z = position.z-delta*MVM_SPEED
				if(position.z-destMvm.z < 0):position=destMvm
			if(distZ < 0):
				position.z = position.z+delta*MVM_SPEED
				if(position.z-destMvm.z > 0):position=destMvm

func handleRotation(delta):
	if(destRot != rotation.y):
		if(destRot-rotation.y > 0):
			rotation.y=rotation.y+delta*ROT_SPEED
			if(destRot-rotation.y <= 0):
				rotation.y = destRot
				destRot = rotation.y
		if(destRot-rotation.y < 0):
			rotation.y=rotation.y-delta*ROT_SPEED
			if(destRot-rotation.y >= 0):
				rotation.y = destRot
				destRot = rotation.y

func handleInput():
	if(destMvm == position && destRot == rotation.y):
		if(Input.is_action_pressed("goForward") && !frontCast.is_colliding() && !frontCastBackward.is_colliding()):
			match direction:
				NORTH:destMvm.z=destMvm.z-1
				SOUTH:destMvm.z=destMvm.z+1
				EAST:destMvm.x=destMvm.x+1
				WEST:destMvm.x=destMvm.x-1
		elif(Input.is_action_pressed("goBackward") && !backCast.is_colliding() && !backCastBackward.is_colliding()):
			match direction:
				NORTH:destMvm.z=destMvm.z+1
				SOUTH:destMvm.z=destMvm.z-1
				EAST:destMvm.x=destMvm.x-1
				WEST:destMvm.x=destMvm.x+1
		elif(Input.is_action_pressed("turnLeft")):
			destRot=destRot+PI/2
			match direction:
				NORTH:direction=WEST
				SOUTH:direction=EAST
				EAST:direction=NORTH
				WEST:direction=SOUTH
		elif(Input.is_action_pressed("turnRight")):
			destRot=destRot-PI/2
			match direction:
				NORTH:direction=EAST
				SOUTH:direction=WEST
				EAST:direction=SOUTH
				WEST:direction=NORTH
func _input(event):
	if(destMvm == position && destRot == rotation.y && event.is_action_pressed("action")):
		match direction:
			NORTH:action.emit(position+Vector3(0,-0.5,0), position+Vector3(0,-0.5,-1))
			SOUTH:action.emit(position+Vector3(0,-0.5,0), position+Vector3(0,-0.5,1))
			EAST:action.emit(position+Vector3(0,-0.5,0), position+Vector3(1,-0.5,0))
			WEST:action.emit(position+Vector3(0,-0.5,0), position+Vector3(-1,-0.5,0))
