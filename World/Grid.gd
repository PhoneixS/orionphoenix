extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var cols_num: int = 100
export var rows_num: int = 100
export var cell_size: float = 64
export var line_width: float = 1.0
export var line_color: Color = Color(0.5, 0.5, 0.5, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var max_height = rows_num * cell_size
	var max_width = cols_num * cell_size
	
	for i in range(cols_num + 1):
		var line = Line2D.new()
		line.width = line_width
		line.default_color = line_color
		line.add_point(Vector2(i * cell_size, 0))
		line.add_point(Vector2(i * cell_size, max_height))
		add_child(line)
		
	for i in range(rows_num + 1):
		var line = Line2D.new()
		line.width = line_width
		line.default_color = line_color
		line.add_point(Vector2(0, i * cell_size))
		line.add_point(Vector2(max_width, i * cell_size))
		add_child(line)
	
	print(self.get_path())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
