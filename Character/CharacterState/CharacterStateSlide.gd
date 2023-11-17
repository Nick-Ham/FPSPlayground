extends CharacterState
class_name CharacterStateSlide

@export_category("Built-In")
@export var Neck : CharacterNeck
@export var RayCast : RayCast3D
@export var HeadTilt : HeadTilter
@export_group("States")
@export var defaultState : CharacterStateDefault
@export var inAirState : CharacterStateInAir

@export_category("SlideConfig")
@export var slideTurnWeight : float = 0.9
@export var slideBoost : float = 4.5
@export var slideHeight : float = 0.5
@export var slideStopDuration : float = 0.5
@export var slideStopSpeed : float = 0.5
@export var slideGravityScalarX : float = 2.0
@export var slideGravityScalarY : float = 2.0
@export var slideMaxFallSpeed : float = 5.0

var slideStopTimer : SceneTreeTimer
var slideStopHasStarted : bool = false

func _on_state_enter():
	super._on_state_enter()
	
	var velocityPlanar = Vector2(character.velocity.x, character.velocity.z)
	if velocityPlanar.length_squared() < 5:
		stopSlide(defaultState)
		return
	
	var slideDirection : Vector3
	if lastInputDirection.is_zero_approx():
		slideDirection = character.velocity.normalized()
	else:
		slideDirection = convertInputToDirection(lastInputDirection, character.transform.basis)
	
	character.velocity += slideDirection * slideBoost
	
	Neck.setHeightTarget(slideHeight)

func _on_state_exit():
	Neck.resetHeight()

func updatePhysics(delta) -> void:
	if !lastInputDirection.is_zero_approx() and slideTurnWeight != 0.0:
		var velocityComponentY = character.velocity.y
		var weightedNudgeDirection = convertInputToDirection(lastInputDirection, character.transform.basis) * slideTurnWeight * delta
		var weightedCurrentDirection = character.velocity.normalized() * (1/slideTurnWeight)
		var totalDirection = (weightedNudgeDirection + weightedCurrentDirection).normalized()
		character.velocity = character.velocity.length() * totalDirection # this needs to be planar or else it breaks gravity
		character.velocity.y = velocityComponentY
	
	if character.velocity.y < -slideMaxFallSpeed:
		stopSlide(inAirState)
		return
	
	if isSlideReadyToStop() and !slideStopHasStarted:
		startSlideStop()
	
	HeadTilt.update(delta, lastInputDirection.x)
	super.updatePhysics(delta)

func isSlideReadyToStop() -> bool:
	return character.velocity.length_squared() < pow(slideStopSpeed, 2)

func startSlideStop():
	slideStopTimer = get_tree().create_timer(slideStopDuration)
	Util.safeConnect(slideStopTimer.timeout, _on_slide_timer_end)
	slideStopHasStarted = true

func stopSlide(newState : CharacterState) -> void:
	Neck.resetHeight()
	slideStopHasStarted = false
	character.switchState(newState)
	return

func _on_slide_timer_end():
	if character.currentState == self:
		stopSlide(defaultState)

func justJumped() -> void:
	if character.getCoyoteTime() || character.is_on_floor():
		character.velocity.y += jumpVelocity
	
	stopSlide(inAirState)

func applyGravity(delta : float) -> void:
	if !character.is_on_floor():
		character.velocity.y -= gravity * delta
	
	if !RayCast.is_colliding():
		return
	
	var normal : Vector3 = RayCast.get_collision_normal()
	var angleToGround = rad_to_deg(Vector3.UP.angle_to(normal))
	var direction = Vector2(normal.x, normal.z).normalized()
	
	var xComponent = angleToGround / 90 * Vector3(direction.x, 0, direction.y)
	
	var yComponent = Vector3.DOWN * (90 - max(0.01, angleToGround)) / 90
	
	var totalGravity = xComponent * gravity * slideGravityScalarX + yComponent * gravity * slideGravityScalarY
	
	character.velocity += totalGravity * delta
