class_name StateMachine
extends Node

#__________VARIABLES__________

#EXPORTED
export (Dictionary) var states = {
	"idle" : NodePath(),
	"walk" : NodePath(),
	"air" : NodePath(),
	"jump" : NodePath(),
	"fall" : NodePath()
}
export (NodePath) var start_state

#PRIVATE
var _current_state: BaseState

#__________FUNCTIONS__________

#PUBLIC
func fsm_init(actor: Actor) -> void:
	for child in get_children():
		child.actor = actor
		child.states = states
		child.init()
	
	_change_state(get_node(start_state))

func process(delta: float) -> void:
	var new_state = _current_state.process(delta)
	if new_state:
		_change_state(new_state)

func physics_process(delta: float) -> void:
	var new_state = _current_state.physics_process(delta)
	if new_state:
		_change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = _current_state.input(event)
	if new_state:
		_change_state(new_state)

func do_action(action) -> bool:
	var new_state = _current_state.do_action(action)
	if new_state:
		_change_state(new_state)
		new_state.do_action(action)
		return true
	else:
		return false

func current_state() -> BaseState:
	return _current_state

#PRIVATE
func _change_state(new_state: BaseState) -> void:
	if _current_state:
		_current_state.exit()
	
#	if new_state != _current_state && _current_state != null:
#		print(_current_state.name, " -> ", new_state.name)

	_current_state = new_state
	_current_state.enter()

