class_name DoorList extends Node3D

@onready var door = preload("res://3dModel/Scenes/door.tscn")
@onready var map:GridMap = $".."

func _ready():
	var pos:Array[Vector3i] = map.get_used_cells_by_item(6)
	for i in pos:
		var door:Door = door.instantiate();
		door.position = i;
		match(map.get_cell_item_orientation(i)):
			10:door.rotation.y = PI
			16:door.rotation.y = PI/2
			22:door.rotation.y = -PI/2
		add_child(door)

func activateDoorAt(pos:Vector3):
	for i in get_children():
		if(i is Door && i.position == pos):
			i.interact()
