extends GridMap

@onready var doorList:DoorList = $DoorList

func _on_player_action(pos:Vector3, frontPos:Vector3):
	if(!doorList.activateDoorAt(pos)):
		doorList.activateDoorAt(frontPos)
