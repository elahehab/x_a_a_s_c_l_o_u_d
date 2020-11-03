extends Area2D

const BLUECLOUD = preload("res://scenes/BlueCloud.tscn")
const XAASCLOUD = preload("res://scenes/XaasCloud.tscn")

var numOfWClouds
var numOfHClouds
var numOfClouds
var numOfXClouds
var numOfAllowedFail

var numOfFoundedClouds = 0
var numOfFails = 0

var clouds = []

var start = 0

# xcloud, w, h
var levels = [
[1, 2, 2, 0],
[2, 3, 2, 0],
[2, 3, 3, 1],
[3, 3, 3, 0],
[3, 4, 3, 2],
[3, 4, 3, 1],
[3, 4, 3, 0],
[3, 4, 4, 1],
[4, 4, 4, 2],
[4, 4, 4, 1],
[4, 4, 4, 0],
[5, 4, 4, 2],
[5, 4, 4, 1],
[5, 4, 4, 0],
[5, 5, 4, 0],
[5, 5, 5, 2],
[5, 5, 5, 1],
[5, 5, 5, 0],
[6, 5, 5, 2],
]

func _ready():
	randomize()

	var SCREEN_WIDTH = get_viewport_rect().size[0]
	var SCREEN_HEIGHT = get_viewport_rect().size[1]
	var xCloudNums = []
	var availableNums = []
	for i in range(numOfClouds):
		availableNums.append(i)
	
	for i in range(numOfXClouds):
		var selected = randi()%(availableNums.size())
		xCloudNums.append(availableNums[selected])
		availableNums.remove(selected)
		
	var vDist = 10
	var hDist = 10
	
	var tmpCloud = BLUECLOUD.instance()
	var cloudW = tmpCloud.getSize()[0]
	var cloudH = tmpCloud.getSize()[1]
	var cloudsW = numOfWClouds*cloudW + (numOfWClouds - 1)*vDist
	var cloudsH = numOfHClouds*cloudH + (numOfHClouds - 1)*hDist
	var startPosX = (SCREEN_WIDTH - cloudsW) / 2
	var startPosY = (SCREEN_HEIGHT - cloudsH) / 2 - 50
	
	for i in range(numOfWClouds):
		for j in range(numOfHClouds):
			var cloudx = startPosX + i*(cloudW + vDist)
			var cloudy = startPosY + j*(cloudH + hDist)
			
			var cloudNumber = i+j*numOfWClouds
			var cloud
			if(xCloudNums.find(cloudNumber) != -1):
				cloud = XAASCLOUD.instance()
			else:
				cloud = BLUECLOUD.instance()
			
			cloud.position = Vector2(cloudx, cloudy)
			add_child(cloud)
			clouds.append(cloud)

func increaseNumOfFoundedClouds():
	numOfFoundedClouds += 1
	if(numOfFoundedClouds == numOfXClouds):
		var timer = get_node("Timer")
		timer.connect("timeout", self, "levelSuccess")
		timer.start(1)


func increaseNumOfFails():
	numOfFails += 1
	if(numOfFails > numOfAllowedFail):
		var timer = get_node("Timer")
		timer.connect("timeout", self, "levelFailed")
		timer.start(1)

func start():
	start = 1

func isLevelStarted():
	return start
	

func initializeLevel(levelNum):
	numOfXClouds = levels[levelNum][0]
	numOfWClouds = levels[levelNum][1]
	numOfHClouds = levels[levelNum][2]
	numOfAllowedFail = levels[levelNum][3]
	numOfClouds = numOfHClouds*numOfWClouds
	
func levelSuccess():
	get_parent().levelSuccess()
	
func levelFailed():
	get_parent().levelFailed()
	
func checkOverlap():
	var bodies = get_overlapping_bodies()
	print(bodies.size())
	if(bodies.size() > 0):
		print(bodies)
#	for i in range(clouds.size() - 1):
#		for j in range(i+1, clouds.size() - 1):
#			var c1 = clouds[i]
#			var c2 = clouds[j]
			
