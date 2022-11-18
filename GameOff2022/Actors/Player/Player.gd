class_name Player
extends Actor

#__________VARIABLES__________

#EXPORTED
export (int) var hop_force = 50
export (int) var max_speed_run = 130
export (int) var move_speed_run = 300

#PRIVATE
var _is_jump_buffered: bool = false
var _was_on_floor: bool = false
var _just_jumped: bool = false

#ONREADY
onready var jump_timer = $JumpBufferTimer
onready var hop_timer = $ShortJumpTimer
onready var coyote_timer = $CoyoteTimer
onready var ledge_detector = $LedgeDetector

#__________FUNCTIONS__________

#BUILT-IN
func _ready():
	jump_timer.connect("timeout", self, "_on_jump_timer_timeout")
	hop_timer.connect("timeout", self, "_on_hop_timer_timeout")
	coyote_timer.connect("timeout", self, "_on_coyote_timer_timeout")

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("input_jump"):
		_is_jump_buffered = true
		jump_timer.start()
	
	if event.is_action_released("input_jump") && !hop_timer.is_stopped():
		velocity.y += (jump_force - hop_force)
	
	if event.is_action_pressed("input_attack"):
# warning-ignore:return_value_discarded
		do_action("attack")
	
#	if event.is_action_pressed("input_run"):
## warning-ignore:return_value_discarded
#		do_action("run")
	
	state_machine.input(event)
	get_tree().set_input_as_handled()

# warning-ignore:unused_argument
func _physics_process(delta):
	if _is_jump_buffered:
		if do_action("jump"):
			hop_timer.start()
			_is_jump_buffered = false
			_was_on_floor = false
			_just_jumped = true
	
	if !_just_jumped:
		if .is_on_floor():
			_was_on_floor = true
		elif !.is_on_floor() && _was_on_floor && _was_on_ledge() && coyote_timer.is_stopped():
			coyote_timer.start()
	
# warning-ignore:return_value_discarded
	do_action(_get_move_direction())

#PUBLIC
func is_on_floor() -> bool:
	return _was_on_floor

func current_state() -> BaseState:
	return state_machine.current_state()

#PRIVATE
func _get_move_direction() -> Vector2:
	return Vector2(Input.get_action_strength("input_right") - Input.get_action_strength("input_left"), 0)

func _on_jump_timer_timeout() -> void:
	_is_jump_buffered = false

func _on_hop_timer_timeout() -> void:
	_just_jumped = false

func _on_coyote_timer_timeout() -> void:
	_was_on_floor = false

func _was_on_ledge() -> bool:
	return ledge_detector.is_colliding() && ledge_detector.get_collider() is TileMap
