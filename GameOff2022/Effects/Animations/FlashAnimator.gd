#tool
#class_name
extends AnimationPlayer

#__________SIGNALS__________


#__________ENUMS__________


#__________CONSTANTS__________


#__________VARIABLES__________

#EXPORTED


#PUBLIC


#PRIVATE


#ONREADY


#__________FUNCTIONS__________

#BUILT-IN
func _ready() -> void:
# warning-ignore:return_value_discarded
	get_parent().connect("invulnerable_changed", self, "_on_parent_invulnerable_changed")
	play("RESET")

#PUBLIC


#PRIVATE
func _on_parent_invulnerable_changed(value: bool) -> void:
	if value:
		play("flash")
	else:
		play("RESET")
