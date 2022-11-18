class_name JumpState
extends BaseState

#__________VARIABLES__________

#EXPORTED
export (float) var jump_force = 100.0

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("jump_force")

func enter() -> void:
	.enter()
	actor.velocity.y = 0
	actor.velocity.y -= jump_force

# warning-ignore:unused_argument
func physics_process(delta: float) -> BaseState:
	return _get_state("air")
