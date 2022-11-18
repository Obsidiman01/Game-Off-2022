class_name MoveState
extends BaseState

#__________VARIABLES__________

#EXPORTED
export (int) var move_speed = 10

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("move_speed")
	_inherit_actor_property("friction")

func do_action(action) -> BaseState:
	if action is Vector2:
		move_vector = action
	elif action is String:
		if (action == "jump" && actor.is_on_floor()) || action != "jump":
			return _get_state(action)
	
	return null

func physics_process(delta: float) -> BaseState:
	var move = move_vector.x
	
	_face_direction(move)
	
	_do_gravity(delta)
	actor.velocity.x += move_speed * move * delta
	if actor.is_on_floor():
		actor.velocity.x = clamp(actor.velocity.x, -actor.max_speed, actor.max_speed)
	_do_motion()
	
	if !actor.is_on_floor():
		if _is_moving_down():
			return _get_state("fall")
		else:
			return _get_state("air")
	else:
		if move != 0:
			return _get_state("walk")
		else:
			return _get_state("idle")

#PRIVATE
func _is_moving_down() -> bool:
	return actor.velocity.y >= 0
