extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "next_level_button_pressed")

func next_level_button_pressed():
    get_parent().get_parent().goToNextLevel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
