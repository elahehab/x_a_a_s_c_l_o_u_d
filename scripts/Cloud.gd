extends KinematicBody2D


var cloudScale = Vector2(1, 1)
var start = 0
var speed = 200
var velocity = Vector2()
var maxDist = 50
var nextPos = Vector2()
var cloudType = 0 #0: normal cloud, 1: xaas cloud

func _ready():
	randomize()
	start = 0
	get_node("Sprite").scale = cloudScale
	nextPos = position
	if(get_node("Sprite").has_node("cover")):
		cloudType = 1
	if(cloudType == 1):
		get_node("Sprite/cover").modulate.a = 0


func getSize():
	var size = get_node("Sprite").get_rect().size
	return size*cloudScale
	

func _process(delta):
	if(!get_parent().isLevelStarted()):
		return
	if(speed > 0):
		speed = speed - 1
		if(cloudType == 1):
			get_node("Sprite/cover").modulate.a += 0.01
			if(get_node("Sprite/cover").modulate.a > 1):
				get_node("Sprite/cover").modulate.a = 1
	else:
		speed = 0
		return

	var changed = false
	var res = updatePosition(position)
	position = res[0]
	changed = res[1]
	if(changed == true):
		nextPos = position

	if(position.distance_to(nextPos) < 5):
		nextPos = generateRandomPos()
#		velocity = position.direction_to(nextPos) * speed * delta
		velocity = position.direction_to(nextPos) * speed
	if position.distance_to(nextPos) > 5:
		move_and_slide(velocity)
#		var collisionObj = move_and_collide(velocity)
#		if(collisionObj != null):
#			nextPos = generateRandomPos()
#			velocity = position.direction_to(nextPos) * speed * delta

func _input(event):
	if(event is InputEventMouseButton and event.is_pressed() and
	isMouseOver(event.position) and speed <= 0):
		get_tree().set_input_as_handled()
		if(cloudType == 1):
			get_node("Sprite/cover").modulate.a = 0
			get_parent().increaseNumOfFoundedClouds()
		else:
			get_parent().increaseNumOfFails()
		

func generateRandomPos():
	var nextRandX = 2*(randi()%maxDist) - maxDist
	var nextRandY = 2*(randi()%maxDist) - maxDist
	nextPos = position + Vector2(nextRandX, nextRandY)
	nextPos = updatePosition(nextPos)[0]
	return nextPos
	
func updatePosition(pos):
	var SCREEN_WIDTH = get_viewport_rect().size[0]
	var SCREEN_HEIGHT = get_viewport_rect().size[1]
	var cloudWidth = getSize()[0]
	var cloudHeight = getSize()[1]
	var changed = false
	if(pos.x > (SCREEN_WIDTH - cloudWidth)):
		pos.x = SCREEN_WIDTH - cloudWidth
		changed = true
	if(pos.y > (SCREEN_HEIGHT - cloudHeight - 150)):
		pos.y = SCREEN_HEIGHT - cloudHeight - 150
		changed = true
	if(pos.x < 0):
		pos.x = 0
		changed = true
	if(pos.y < 0):
		pos.y = 0
		changed = true
	return [pos, changed]
	
func isMouseOver(mousePos):
	var mouseX = mousePos[0]
	var mouseY = mousePos[1]
	if(mouseX > position.x and mouseX < position.x + getSize()[0] and
	mouseY > position.y and mouseY < position.y + getSize()[1]):
		return true
	else:
		return false
		
