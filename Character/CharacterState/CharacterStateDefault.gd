extends CharacterState
class_name CharacterStateDefault

@export_category("Built-In")
@export var HeadBob : PeriodicShifter
@export var HeadTilt : HeadTilter
@export_group("States")
@export var inAirState : CharacterStateInAir
@export var slideState : CharacterStateSlide
@export var sprintState : CharacterStateSprint

func update(_delta : float) -> void:
	if lastIsSprinting and character.velocity.length() > sprintState.sprintMinSpeed:
		character.switchState(sprintState)
		return

func updatePhysics(delta : float) -> void:
	super.updatePhysics(delta)
	
	if !lastInputDirection.is_zero_approx():
		HeadBob.update(delta)
	
	HeadTilt.update(delta, lastInputDirection.x)

func justJumped():
	if character.getCoyoteTime() || character.is_on_floor():
		character.velocity.y += jumpVelocity
	
	character.switchState(inAirState)

func justSlid():
	character.switchState(slideState)

