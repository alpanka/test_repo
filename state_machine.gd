## StateMachine
## State switcher, handler
class_name  StateMachine
extends Node


signal current_state_changed

var states_dict: Dictionary = {}
var current_state: State

@export var initial_state: State

@export_group("DEBUG")
@export var debug_on: bool = true
@export var state_label: Label
@export var print_names: bool = true


func _ready() -> void:
	for child in get_children():
		if child is State:
			states_dict[child.name] = child
			child.state_switched.connect(change_state)
			
			# If a state has "default_state" checked, get that as initial state.
			if child.default_state == true:
				initial_state = states_dict.get(child.name)
	
	if initial_state:
		initial_state.state_enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update_process(delta)
	
	# Update debug label is debug is on
	if current_state and state_label:
		if debug_on:
			state_label.visible = true
			state_label.text = current_state.name
		else:
			state_label.visible = false


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update_physics(delta)


func change_state(source_state: State, new_state_name: String):
	if source_state != current_state:
		print("Invalid change_state attempt from ", \
		source_state.name, " to ", new_state_name)
		return

	var new_state = states_dict.get(new_state_name)
	
	if not new_state:
		print("New state is empty! ", new_state_name)
		return
	
	current_state_changed.emit(new_state.name)
	new_state.state_enter()
	
	current_state = new_state
	
	if print_names:
		print(current_state.name)


# Use when absolutely needed. Like for "DeathState"
func change_state_forced(new_state_name: String):
	var new_state = states_dict.get(new_state_name)
	
	if not new_state:
		print("New state is empty! ", new_state_name)
		return

	if current_state == new_state:
		print("Attempt to re-enter into current state. Aborted!")
		return
	
	if current_state:
		var exit_callable = Callable(current_state, "exit")
		exit_callable.call_deferred()
	
	new_state.state_enter()
	
	current_state = new_state
