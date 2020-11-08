extends Area2D

const BLUECLOUD = preload("res://scenes/BlueCloud.tscn")
const XAASCLOUD = preload("res://scenes/XaasCloud.tscn")

var numOfWClouds
var numOfHClouds
var numOfClouds
var numOfXClouds
var numOfAllowedFail
var vDist = 40
var hDist = 40

var xCloudNums = []
var numOfFails = 0

var clouds = []

var start = 0

# xcloud, w, h, numOfFault
var levels = [
[1, 2, 2, 0], #0
[2, 3, 2, 0], #1
[2, 2, 3, 1], #2
[3, 2, 4, 0], #3
[3, 3, 3, 2], #4
[3, 2, 5, 1], #5
[3, 4, 3, 0], #6
[3, 3, 4, 1], #7
[4, 3, 4, 2], #8
[4, 3, 4, 2], #9
[4, 3, 5, 1], #10
[4, 4, 4, 0], #11
[5, 5, 3, 2], #12
[5, 3, 5, 1], #13
[5, 4, 4, 0], #14
[5, 5, 4, 0], #15
[5, 4, 5, 2], #16
[5, 5, 4, 1], #17
[5, 5, 4, 0], #18
[6, 2, 4, 2], #19
[6, 3, 4, 1], #20
[6, 4, 3, 1], #21
[6, 3, 5, 0], #22
[6, 4, 4, 0], #23
[6, 5, 4, 0], #24
[6, 4, 5, 0], #25
[7, 3, 5, 0], #26
]

func _ready():
	randomize()

	var SCREEN_WIDTH = get_viewport_rect().size[0]
	var SCREEN_HEIGHT = get_viewport_rect().size[1]
	var availableNums = []
	for i in range(numOfClouds):
		availableNums.append(i)
	
	for i in range(numOfXClouds):
		var selected = randi()%(availableNums.size())
		xCloudNums.append(availableNums[selected])
		availableNums.remove(selected)
	
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
			
			cloud.setCloudNumber(cloudNumber)
			cloud.position = Vector2(cloudx, cloudy)
			add_child(cloud)
			clouds.append(cloud)

func xaasCloudFound(cloudNumber):
	if(xCloudNums.find(cloudNumber) != -1):
		get_node("CorrectSound").play()
		xCloudNums.erase(cloudNumber)
		if(xCloudNums.size() == 0):
			var timer = get_node("Timer")
			timer.connect("timeout", self, "levelSuccess")
			timer.start(1)


func increaseNumOfFails():
	numOfFails += 1
	get_node("WrongSound").play()
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
	

func allCloudsStopped():
	for c in clouds:
		if(c.speed > 0):
			return false
	return true
