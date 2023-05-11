extends Node2D

#Variable for whether or not the task was "selected"
var selected = false

#The positions of the centers of the dropzones
var rest_point
var rest_nodes = []

#x and y are position variables
var x = 300
var y = 100

#The dimensions of the dropzones
var rectx
var recty

#Scale factor
var sclfact = 0.7

#"current" and "candidate", used for swapping
var current
var candidate

#link for the image
var img

#size of image
var imgx
var imgy

#which step of the sequence
var ordernum

#Constructs the task with all the necessary inpputs
func init(xval, yval, rx, ry, curr, link, onum, scl):
	x = xval
	y = yval
	rectx = rx
	recty = ry
	current = curr
	candidate = current
	img = link
	sclfact = scl
	
	#Gets the image for the task
	var texturex = load(img)
	
	#Finds the size of the image
	imgx = texturex.get_size().x
	imgy = texturex.get_size().y
	
	#Sets the step number 
	ordernum = onum

func _ready():
	#Creates a picture with ic
	var sprite = get_node("Icon")
	var collision_box = get_node("Icon/Area2D/collision_box")
	var shape = collision_box.shape as RectangleShape2D
	var texturex = load(img)
	
	#Code for scaling the images. The 0.7 is there to make sure 
	#that the images are a bit smaller than the dropzones
	sprite.texture = texturex
	shape.extents = Vector2(imgx/2,imgy/2)
	scale = Vector2(sclfact * rectx / imgx,sclfact * recty/imgy)
	
	#Initializing the rest_points, which are the locations of the dropzones
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = rest_nodes[0].pos + Vector2(rectx/2, recty/2)
	rest_nodes[0].select()
	
	#Sets the position of the task 
	global_position = Vector2(x,y)

#Sets the task to "selected" if clicked by a mouse input
func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		#Plays a click sound
		if InputControl.soundfx:
			Boxonclick.play()
		selected = true

#The main physics process
func _physics_process(delta):
	#If selected, make the task follow the moouse
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	#If it's not selected, meaning its let go. "current" is the box where it was
	#dragged from and "candidate" is the closest box to it once released.
	else:
		#Once released, if the closest box is the original box, the box will just go to the original position
		if current == candidate:
			global_position = lerp(global_position, candidate.pos + Vector2(rectx/2, recty/2), 20 * delta)
			
		#If the closest box is not the original box and it's moving to a different box:
		else:
			#If the box is occupied, the two tasks will SWAP
			if candidate.occupied == true:
				if InputControl.soundfx:
					Swapsound.play()
				var temp1 = candidate.ans
				var temp2 = current.ans
				candidate.ans.current = current
				candidate.ans.candidate = current
				current.ans = temp1
				current = candidate
				current.ans = temp2
				temp1 = null
				temp2 = null
				global_position = lerp(global_position, candidate.pos + Vector2(rectx/2, recty/2), 20 * delta)
			
			#If the box is not occupied, it will not swap but just occupy it
			else:
				if InputControl.soundfx:
					Boxsound.play()
				candidate.ans = current.ans
				current.ans = null
				candidate.occupied = true
				current.occupied = false
				current = candidate
				global_position = lerp(global_position, candidate.pos + Vector2(rectx/2, recty/2), 20 * delta)

#This code handles what happens the moment when the task is released. It finds
#the closest box to it and stores it as the "candidate".
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			var shortest_dist = 10000
			#Checks all the rest_nodes, aka all the dropzones, to see which one is the closest
			for child in rest_nodes:
				var distance = global_position.distance_to(child.pos +  Vector2(rectx/2, recty/2) )
				if distance < shortest_dist:
					child.select()
					rest_point = child.pos + Vector2(rectx/2, recty/2)
					shortest_dist = distance
					candidate = child
