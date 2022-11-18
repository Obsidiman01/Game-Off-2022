class_name StunnedState
extends BaseState

#__________SIGNALS__________


#__________ENUMS__________


#__________CONSTANTS__________


#__________VARIABLES__________

#EXPORTED


#PUBLIC
var stun_duration: float = 1

#PRIVATE
var _stun_finished: bool = false

#ONREADY


#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	_inherit_actor_property("stun_duration")
	_inherit_actor_property("friction_air", "_air")

func enter() -> void:
	.enter()
	var previous_hitbox_state = actor.get_hitbox_active_state()
	_stun_finished = false
	actor.deactivate_hitbox()
	yield(get_tree().create_timer(stun_duration), "timeout")
	actor.set_hitbox_active_state(previous_hitbox_state)
	_stun_finished = true

func physics_process(delta: float) -> BaseState:
	_do_gravity(delta)
	#_set_friction()
	_do_friction()
	_do_motion()
	
	if _stun_finished:
		#print("stun finished")
		return _get_state("idle")
	else:
		return .physics_process(delta)

#PRIVATE
func _set_friction() -> void:
	if actor.is_on_floor():
		_inherit_actor_property("friction")
	else:
		_inherit_actor_property("friction_air", "_air")
