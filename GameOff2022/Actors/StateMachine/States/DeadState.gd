class_name DeadState
extends BaseState

var dead_color: Color = Color("#c25940")

func init() -> void:
	_inherit_actor_property("friction")

# warning-ignore:unused_argument
func do_action(action) -> BaseState:
	return null

func enter() -> void:
	actor.destroy_attack_boxes()
	#actor.set_modulate(dead_color)
	.enter()

func process(delta: float) -> BaseState:
	
	return .process(delta)

func physics_process(delta: float) -> BaseState:
	_do_gravity(delta)
	_do_friction()
	_do_motion()
	return .physics_process(delta)
