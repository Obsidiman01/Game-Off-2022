class_name HurtBox
extends Area2D

#__________VARIABLES__________

#PRIVATE
var _parent

#ONREADY
onready var collider = $CollisionShape2D

#__________FUNCTIONS__________

#BUILT-IN
func _ready() -> void:
	if get_parent().has_method("take_damage"):
		_parent = get_parent()
	else:
		push_warning("Warning: " + str(self) + " has parent that cannot take damage.")

func _set(property, value):
	if property == "monitorable":
		if value && monitoring:
			var areas = get_overlapping_areas()
			for area in areas:
				if area.monitoring:
					area.emit_signal("area_entered", self)

#PUBLIC
func take_damage(amount: int = 0, source = null) -> void:
	_parent.take_damage(amount, source)

