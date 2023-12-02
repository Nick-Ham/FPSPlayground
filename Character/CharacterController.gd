extends Node
class_name CharacterController

@export_category("Built-In")
@export var character : Character
@export var neck : Node3D

const MOUSE_SENSITIVITY_CONST = .001

@export_category("MouseSensitivity")
@export var mouseSensitivity : float = 2.0

@export_subgroup("IndividualAxisSensitivity")
@export var horizontalSensitivity : float = 1.0
@export var verticalSensitivity : float = 1.0

@export_category("JoyStickSensitivity")
@export var joystickSensitivity : float = 1.0

signal input_direction(direction : Vector3)
signal input_sprint(isSprinting : bool)
signal input_just_jumped
signal input_just_slid
signal input_is_sliding(isSliding : bool)
signal input_is_activating(isActivating : bool)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		character.rotate_y(-event.relative.x * MOUSE_SENSITIVITY_CONST * mouseSensitivity * horizontalSensitivity)
		neck.rotate_x(event.relative.y * MOUSE_SENSITIVITY_CONST * mouseSensitivity * verticalSensitivity)
		neck.rotation.x = clamp(neck.rotation.x, -PI/2.0, PI/2.0)

func _process(_delta):
	var direction = getDirection()
	emit_signal("input_direction", direction)
	
	var isSprinting = getIsSprinting()
	emit_signal("input_sprint", isSprinting)
	
	var justJumped = getJustJumped()
	if justJumped:
		emit_signal("input_just_jumped")
	
	var justSlid = getJustSlid()
	if justSlid:
		emit_signal("input_just_slid")
	
	var isSliding = getIsSliding()
	emit_signal("input_is_sliding", isSliding)
	
	var joystickDirection = Input.get_vector("CameraLeft", "CameraRight", "CameraUp", "CameraDown")
	if !joystickDirection.is_zero_approx():
		character.rotate_y(-joystickDirection.x * joystickSensitivity * horizontalSensitivity)
		neck.rotate_x(joystickDirection.y * joystickSensitivity * verticalSensitivity)
		neck.rotation.x = clamp(neck.rotation.x, -PI/2.0, PI/2.0)
	
	var isActivating = getIsActivating()
	emit_signal("input_is_activating", isActivating)

func getIsActivating() -> bool:
	return Input.is_action_pressed("Click")

func getDirection() -> Vector2:
	return Input.get_vector("Right", "Left", "Backward", "Forward")

func getIsSprinting() -> bool:
	return Input.is_action_pressed("Sprint")

func getJustJumped() -> bool:
	return Input.is_action_just_pressed("Jump")

func getJustSlid() -> bool:
	return Input.is_action_just_pressed("Slide")

func getIsSliding() -> bool:
	return Input.is_action_pressed("Slide")
