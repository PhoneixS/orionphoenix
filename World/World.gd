extends Node2D

const GROUP_SHIPS = "ships"

# Declare member variables here. Examples:
var currentPlayer = 1
var selectedShip: Ship
var selectedShipOriginalPosition: Vector2
var selected_ship_velocity_node: Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for ship in get_tree().get_nodes_in_group(GROUP_SHIPS):
		ship.connect("ship_event", self, "_on_ship_clicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ship_clicked(event: InputEvent, ship: Ship):
	if ship.player == currentPlayer:
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if selectedShip != ship:
					selectedShip = ship
					selectedShipOriginalPosition = ship.position
					show_speed(true)
				else:
					show_speed(false)
					selectedShip = null
		
	else:
		print("¡Enemy ship " + ship.name + "!")
		

func _input(event: InputEvent):
	if event is InputEventMouseMotion and selectedShip != null:
		#selectedShip.position = ((event.position - selectedShipOriginalPosition) \
		#	.clamped($Grid.cellSize * selectedShip.speed) + selectedShipOriginalPosition - cell_size/2).snapped(cell_size) +  cell_size/2
			
		selectedShip.position = floor_to_cells(event.position, selectedShip.speed, $Grid.cellSize)

func floor_to_cells(position: Vector2, speed: float, cell_size: float) -> Vector2:
	var cell: Vector2 = Vector2(cell_size, cell_size)
	var half_size: Vector2 = cell / 2
	var direction: Vector2 = (position - selectedShipOriginalPosition).normalized()
	var search_position = (position - selectedShipOriginalPosition).clamped(speed * cell_size)
	var snapped_position = search_position.snapped(cell) + selectedShipOriginalPosition
	
	while not is_in_range(snapped_position, selectedShipOriginalPosition, speed*cell_size):
		search_position -= direction * cell_size / 2
		snapped_position = search_position.snapped(cell) + selectedShipOriginalPosition
	
	return snapped_position

func snap_floor(position: Vector2, step: float) -> Vector2:
	return Vector2(floor(position.x / step) * step, floor(position.y / step) * step)

func show_speed(show: bool):
	if show:
		selected_ship_velocity_node = create_range(selectedShip.speed, $Grid.cellSize)
		add_child(selected_ship_velocity_node)
	else:
		selected_ship_velocity_node.queue_free()
		
func create_range(speed, cell_size) -> Polygon2D:
	var circle = Polygon2D.new()
	
	# If it doesn't have speed, just return a empty polygon
	if speed <= 0:
		return circle
	
	var center = selectedShipOriginalPosition
	var points_arc = PoolVector2Array()
	# points_arc.push_back(center)
	
	# start at the rigth cell
	var starter_point: Vector2 = center + Vector2(cell_size * speed + cell_size/2, -cell_size/2) 
	var last_point: Vector2 = starter_point
	var last_direction: Vector2 = Vector2.DOWN * cell_size
	
	# Add the first.
	points_arc.push_back(starter_point)
	
	# Go down 1 cell
	last_point += last_direction
	
	# continue until we have returned to the starting point
	while last_point != starter_point:
		
		var current_point: Vector2
		var current_direction: Vector2
		
		# test going left
		current_direction = rotate_left(last_direction)
		current_point = last_point + current_direction
		if is_right_cell_valid(current_point, current_direction, center, speed * cell_size):
			points_arc.push_back(last_point)
			last_direction = rotate_left(last_direction)
			last_point = current_point
			continue

		# test continuing trajectory
		current_point = last_point + last_direction
		if is_right_cell_valid(current_point, last_direction, center, speed * cell_size):
			last_point = current_point
			continue

		# else it should be ok (or the previous should be wrong)
		points_arc.push_back(last_point)
		last_direction = rotate_right(last_direction)
		last_point = last_point + last_direction
		
	
	circle.polygon = points_arc
	circle.color = Color(0, 1, 0, 0.25)
	
	return circle

func rotate_left(direction: Vector2) -> Vector2:
	return Vector2(direction.y, -direction.x)

func rotate_right(direction: Vector2) -> Vector2:
	return Vector2(-direction.y, direction.x)

func is_right_cell_valid(corner: Vector2, dir: Vector2, origin: Vector2, speed_pixels: float) -> bool:
	# Center = last going back half distance and going half distance towards right
	var center = corner - (dir / 2) + (rotate_right(dir) / 2)
	return is_in_range(center, origin, speed_pixels)

func is_in_range(dest: Vector2, origin: Vector2, speed_pixels: float) -> bool:
	return origin.distance_to(dest) <= speed_pixels
