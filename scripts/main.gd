extends Node2D

const BACKGROUND =  preload("res://scenes/background.tscn")
const BLUECLOUD = preload("res://scenes/BlueCloud.tscn")
const XAASCLOUD = preload("res://scenes/XaasCloud.tscn")

var numOfWClouds = 3
var numOfHClouds = 3
var numOfClouds = numOfWClouds*numOfHClouds
var numOfXClouds = 3 
var numOfFoundedClouds = 0
var clouds = []
var start = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var background = BACKGROUND.instance()
	add_child(background)
	
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
	
	var timer = get_node("Timer")
	timer.connect("timeout", self, "startLevel")
	timer.start(1)
	
func increaseNumOfFoundedClouds():
	numOfFoundedClouds += 1
	if(numOfFoundedClouds == numOfXClouds):
		print("you won")

func startLevel():
	start = 1

func isLevelStarted():
	return start
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
