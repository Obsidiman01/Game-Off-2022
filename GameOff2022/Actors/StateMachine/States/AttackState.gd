class_name AttackState
extends BaseState

#__________VARIABLES__________

#PRIVATE
var _anim_finished = false

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
# warning-ignore:return_value_discarded
	actor.animation.connect("animation_finished", self, "_on_actor_animation_finished")
	_inherit_actor_property("friction")

func enter() -> void:
	_anim_finished = false
	.enter()

func physics_process(delta: float) -> BaseState:
	_do_gravity(delta)
	_set_friction()
	_do_friction()
	_do_motion()
	if _anim_finished:
		return _get_state("idle")
	else:
		return .physics_process(delta)

#PRIVATE
func _on_actor_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		_anim_finished = true

func _set_friction() -> void:
	if actor.is_on_floor():
		_inherit_actor_property("friction")
	else:
		_inherit_actor_property("friction_air", "_air")
