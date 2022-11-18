class_name RunState
extends MoveState

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("move_speed_run", "_run")
	_inherit_actor_property("max_speed_run", "_run")
