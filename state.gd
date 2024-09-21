## Base class for StateMachine's states
class_name State
extends Node

@warning_ignore("unused_signal")
signal state_switched

@export var actor: CharacterBody2D
@export var default_state: bool


func _ready() -> void:
	actor = get_owner() as CharacterBody2D


func state_enter() -> void:
	pass


func state_exit() -> void:
	pass


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	pass
