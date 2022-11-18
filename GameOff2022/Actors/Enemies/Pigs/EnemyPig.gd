class_name EnemyPig
extends Enemy

#__________SIGNALS__________


#__________ENUMS__________


#__________CONSTANTS__________


#__________VARIABLES__________

#EXPORTED


#PUBLIC


#PRIVATE
var _move_dir: Vector2 = Vector2.RIGHT

#ONREADY
onready var wall_detect = $WallDetect
onready var cliff_detect = $CliffDetect

#__________FUNCTIONS__________

#BUILT-IN
#func _init() -> void:
#	pass
#
#func _ready() -> void:
#	pass
#
#func _process(delta) -> void:
#	pass
#
func _physics_process(_delta) -> void:
	if _alive:
		if is_on_floor():
			if _detect_wall() || _detect_cliff():
				_move_dir.x *= -1
	# warning-ignore:return_value_discarded
			do_action(_move_dir)
	



#PUBLIC


#PRIVATE
func _detect_wall() -> bool:
	return wall_detect.is_colliding() && wall_detect.get_collider() is TileMap

func _detect_cliff() -> bool:
	return !(cliff_detect.is_colliding() && cliff_detect.get_collider() is TileMap)

