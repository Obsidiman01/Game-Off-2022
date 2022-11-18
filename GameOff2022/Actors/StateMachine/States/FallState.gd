class_name FallState
extends AirborneState

#__________FUNCTIONS__________

#PUBLIC
func physics_process(delta: float) -> BaseState:
	actor.velocity.y += (actor.gravity) * delta
	return(.physics_process(delta))

