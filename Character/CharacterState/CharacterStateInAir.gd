extends CharacterState
class_name CharacterStateInAir

@export_category("Built-In")
@export var HeadTilt : HeadTilter
@export var RayCastLeft : RayCast3D
@export var RayCastRight : RayCast3D
@export_group("States")
@export var defaultState : CharacterStateDefault
@export var slideState : CharacterStateSlide
@export var wallSlideState : CharacterStateWallSlide

@export_category("InAirConfig")
@export var wallSlideAngleLimit : float = 13.0
@export var wallSlideBoost : float = 2.0
@export var upBoostWeight : float = 5.0
@export var forwardBoostWeight : float = 0.0

func updatePhysics(delta):
	super.updatePhysics(delta)
	
	if(trySwitchToSlide()):
		return
	if(trySwitchToWallSlide()):
		return
	if(trySwitchToDefault()):
		return
	
	HeadTilt.update(delta, lastInputDirection.x)

func trySwitchToDefault() -> bool:
	if character.is_on_floor() and !lastIsSliding:
		character.switchState(defaultState)
		return true
	return false

func trySwitchToSlide() -> bool:
	if character.is_on_floor() and lastIsSliding:
		character.switchState(slideState)
		return true
	return false

func trySwitchToWallSlide() -> bool:
	if !lastIsSliding:
		return false
	
	var targetRay : RayCast3D = getRayIfValidWall()
	if targetRay:
		var normal : Vector3 = targetRay.get_collision_normal()
		var wallAngle : float = abs(90 - rad_to_deg(Vector3.UP.angle_to(normal)))
		
		if wallAngle > wallSlideAngleLimit:
			return false
		
		var forwardDirection : Vector3 = Vector3.UP.cross(normal)
		var minAngle = abs(character.velocity.angle_to(forwardDirection))
		if abs(character.velocity.angle_to(-forwardDirection)) < minAngle:
			forwardDirection = -forwardDirection
		
		var upAlongWallDirection = normal.cross(forwardDirection)
		minAngle = abs(Vector3.UP.angle_to(upAlongWallDirection))
		if abs(Vector3.UP.angle_to(-upAlongWallDirection)) < minAngle:
			upAlongWallDirection = -upAlongWallDirection
		
		var totalDirection = (upAlongWallDirection * upBoostWeight + forwardDirection * forwardBoostWeight).normalized()
		
		character.velocity += totalDirection * wallSlideBoost
		
		character.switchState(wallSlideState)
	
	return false

func getRayIfValidWall() -> RayCast3D:
	if !character.is_on_wall_only():
		return null
	
	if RayCastLeft.is_colliding():
		return RayCastLeft
	
	if RayCastRight.is_colliding():
		return RayCastRight
	
	return null
