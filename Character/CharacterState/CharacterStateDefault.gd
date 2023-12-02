extends CharacterState
class_name CharacterStateDefault

@export_category("Built-In")
@export var headBob : PeriodicShifter
@export var headTilt : HeadTilter

func update(_delta : float) -> void:
	if lastIsSprinting and character.velocity.length() > manager.getSprintState().sprintMinSpeed:
		manager.switchState(manager.getSprintState())
		return

func updatePhysics(delta : float) -> void:
	super.updatePhysics(delta)
	
	if !lastInputDirection.is_zero_approx():
		headBob.update(delta)
	
	headTilt.update(delta, lastInputDirection.x)

func justJumped():
	if character.getCoyoteTime() || character.is_on_floor():
		character.velocity.y += jumpVelocity
	
	manager.switchState(manager.getInAirState())

func justSlid():
	manager.switchState(manager.getSlideState())

