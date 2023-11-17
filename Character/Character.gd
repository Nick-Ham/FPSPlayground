extends CharacterBody3D
class_name Character

@export_category("Built-In")
@export var StateDefault : CharacterState
@export var Controller : CharacterController

@export_category("Config")
var coyoteFrames : int = 3

var coyoteTimeCounter : int
var isCoyoteTime : bool

var currentState : CharacterState

func _ready():
	currentState = StateDefault
	bindToController(Controller)

func _process(delta):
	currentState.update(delta)
	
	Game.printStr(str(currentState.name))

func _physics_process(delta):
	updateCoyoteTime()
	currentState.updatePhysics(delta)

func bindToController(inController : CharacterController):
	Util.safeConnect(inController.input_direction, _on_input_direction)
	Util.safeConnect(inController.input_sprint, _on_input_sprint)
	Util.safeConnect(inController.input_just_jumped, _on_input_just_jumped)
	Util.safeConnect(inController.input_just_slid, _on_input_just_slid)
	Util.safeConnect(inController.input_is_sliding, _on_input_is_sliding)

func _on_input_direction(inDirection : Vector2):
	currentState.addNewInputDirection(inDirection)

func getInputDirection() -> Vector2:
	return Controller.getDirection()

func _on_input_sprint(inIsSprinting : bool):
	currentState.addNewIsSprinting(inIsSprinting)

func getInputIsSprinting() -> bool:
	return Controller.getIsSprinting()

func _on_input_is_sliding(inIsSliding : bool):
	currentState.addNewIsSliding(inIsSliding)

func getInputIsSliding() -> bool:
	return Controller.getIsSliding()

func _on_input_just_jumped():
	currentState.justJumped()

func _on_input_just_slid():
	currentState.justSlid()

func updateCoyoteTime() -> void:
	if is_on_floor():
		coyoteTimeCounter = 0
		isCoyoteTime = false
	else:
		if coyoteTimeCounter < coyoteFrames:
			isCoyoteTime = true
		else:
			isCoyoteTime = false
		coyoteTimeCounter += 1

func getCoyoteTime():
	return isCoyoteTime

func switchState(newState : CharacterState) -> void:
	currentState._on_state_exit()
	currentState = newState
	bindToState(currentState)
	currentState._on_state_enter()

func bindToState(inState : CharacterState):
	Util.safeConnect(inState.update_input_request, _on_update_input_request)

func _on_update_input_request() -> void:
	currentState.addNewInputDirection(getInputDirection())
	currentState.addNewIsSliding(getInputIsSliding())
	currentState.addNewIsSprinting(getInputIsSliding())
