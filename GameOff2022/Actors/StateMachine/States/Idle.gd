class_name IdleState
extends BaseState

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("friction")

func do_action(action) -> BaseState:
	if action is Vector2:
		if action.x != 0:
			return _get_state("walk")
		else:
			return null
	elif action is String:
		return _get_state(action)
	else:
		return null

func physics_process(delta: float) -> BaseState:
	if !actor.is_on_floor():
		return _get_state("fall")
	
	_do_gravity(delta)
	_do_friction()
	_do_motion()
	
	return null

