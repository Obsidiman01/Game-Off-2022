class_name Enemy
extends Actor

#__________SIGNALS__________


#__________ENUMS__________


#__________CONSTANTS__________


#__________VARIABLES__________

#EXPORTED
export (String) var loot_table

#PUBLIC
var loot_spawner

#PRIVATE


#ONREADY
onready var loot_scene = preload("res://Actors/Enemies/LootSpawner/LootSpawner.tscn")

#__________FUNCTIONS__________

#BUILT-IN
#func _init() -> void:
#	pass
#
func _ready() -> void:
	_ready_loot_spawner()
#
#func _process(delta) -> void:
#	pass
#
#func _physics_process(delta) -> void:
#	pass

#PUBLIC
func spawn_loot() -> void:
	if loot_spawner != null:
		var col_shape = $CollisionShape2D.shape
		match col_shape.get_class():
			"RectangleShape2D":
				if col_shape.extents.x < 9:
					col_shape.extents.x = 9
				if col_shape.extents.y < 9:
					col_shape.extents.y = 9
			null:
				printerr("No Collision Shape found")
		
# warning-ignore:return_value_discarded
		move_and_slide(Vector2.UP, Vector2.UP)
		
		loot_spawner.global_position = self.global_position
		loot_spawner.serve_loot(loot_table)

#PRIVATE
func _die() -> void:
	$FlashAnimator.stop()
	$FlashAnimator.queue_free()
	._die()
	get_parent().add_child(loot_spawner)
	
	

func _ready_loot_spawner() -> void:
	loot_spawner = loot_scene.instance()
	
