class_name HitBox
extends Area2D

#__________VARIABLES__________

#PRIVATE
var _parent

#ONREADY
onready var collider = $CollisionShape2D

#__________FUNCTIONS__________

#BUILT-IN
func _ready() -> void:
	if get_parent().has_method("deal_damage"):
		_parent = get_parent()
	else:
		push_warning("Warning: " + str(self) + " has parent that cannot deal damage.")

func _set(property, value):
	if property == "monitoring":
		if value && monitoring:
			var areas = get_overlapping_areas()
			for area in areas:
				if area.monitorable:
					self.emit_signal("area_entered", area)

#PRIVATE
func _is_own_hurtbox(area: Area2D) -> bool:
	return (_parent == area.get_parent())

func _on_HitBox_area_entered(area) -> void:
	if area is HurtBox && _parent && !_is_own_hurtbox(area):
		_parent.deal_damage(area)
