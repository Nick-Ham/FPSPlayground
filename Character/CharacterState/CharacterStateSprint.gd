extends CharacterState
class_name CharacterStateSprint

@export_category("Built-In")
@export var camera : CharacterCamera
@export var headBob : PeriodicShifter
@export var headTilt : HeadTilter

@export_category("SprintConfig")
@export var sprintFovMult : float = 1.2
@export var sprintMinSpeed : float = 2.0
@export var headBobTimescale : float = 1.5

func _on_state_enter():
	super._on_state_enter()
	
	camera.setFovTarget(sprintFovMult)

func update(_delta : float) -> void:
	if !lastIsSprinting:
		endSprint()
		manager.switchState(manager.getDefaultState())
	
	if character.velocity.length() < sprintMinSpeed:
		endSprint()
		manager.switchState(manager.getDefaultState())

func updatePhysics(delta):
	super.updatePhysics(delta)
	
	headBob.updateWithTimescale(delta, headBobTimescale)
	headTilt.update(delta, lastInputDirection.x)

func endSprint():
	camera.resetFov()

func justJumped():
	if character.getCoyoteTime() || character.is_on_floor():
		character.velocity.y += jumpVelocity
	
	endSprint()
	manager.switchState(manager.getInAirState())

func justSlid():
	endSprint()
	manager.switchState(manager.getSlideState())
