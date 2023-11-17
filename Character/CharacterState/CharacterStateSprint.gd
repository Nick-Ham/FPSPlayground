extends CharacterState
class_name CharacterStateSprint

@export_category("Built-In")
@export var Camera : CharacterCamera
@export var HeadBob : PeriodicShifter
@export var HeadTilt : HeadTilter
@export_group("States")
@export var defaultState : CharacterStateDefault
@export var inAirState : CharacterStateInAir
@export var slideState : CharacterStateSlide

@export_category("SprintConfig")
@export var sprintFovMult : float = 1.2
@export var sprintMinSpeed : float = 2.0

func _on_state_enter():
	super._on_state_enter()
	
	Camera.setFovTarget(sprintFovMult)

func update(_delta : float) -> void:
	if !lastIsSprinting:
		endSprint()
		character.switchState(defaultState)
	
	if character.velocity.length() < sprintMinSpeed:
		endSprint()
		character.switchState(defaultState)

func updatePhysics(delta):
	super.updatePhysics(delta)
	
	HeadBob.update(delta)
	HeadTilt.update(delta, lastInputDirection.x)

func endSprint():
	Camera.resetFov()

func justJumped():
	if character.getCoyoteTime() || character.is_on_floor():
		character.velocity.y += jumpVelocity
	
	endSprint()
	character.switchState(inAirState)

func justSlid():
	endSprint()
	character.switchState(slideState)
