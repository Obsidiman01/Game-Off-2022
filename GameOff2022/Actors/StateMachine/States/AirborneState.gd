class_name AirborneState
extends MoveState

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("move_speed_air", "_air")
	_inherit_actor_property("friction_air", "_air")

func physics_process(delta: float) -> BaseState:
	return .physics_process(delta)
