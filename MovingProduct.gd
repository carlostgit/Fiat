extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _origin:Node2D = null
var _destiny:Node2D = null
var _product_type:String = "Candy"
var _amount:float = 0.0

const _chocolate_texture:Texture = preload("res://chocolate_small.png") 
const _candy_texture:Texture = preload("res://candy_small.png") 
const _bill_texture:Texture = preload("res://bill.png") 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (_origin!=null and _destiny!=null):
		var current_pos:Vector2 = self.get_position()
		var param_speed = 100.0
		var destiny_pos = _destiny.get_position()
		var advance = param_speed*(current_pos.direction_to(destiny_pos).normalized())*delta
		self.set_position(current_pos+advance)
		
		if (current_pos.distance_to(destiny_pos)<1.0):
			destination_arrived()

func init(origin_arg:Node2D, destiny_arg:Node2D, product_type_arg:String, amount_arg:float):

	_origin = origin_arg
	_destiny = destiny_arg
	_product_type = product_type_arg
	_amount = amount_arg
	
	if(product_type_arg=="Candy"):
		$Sprite.set_texture(self._candy_texture)
	elif(product_type_arg=="Chocolate"):
		$Sprite.set_texture(self._chocolate_texture)
	else:
		$Sprite.set_texture(self._bill_texture)
	
	$Sprite/Label.set_text(str(amount_arg))
		
	self.set_position(origin_arg.get_position())
	
func destination_arrived():
	if (_product_type == "Candy" or _product_type == "Chocolate"):
		_destiny.add_consumed_products(_amount)
	else:
		_destiny.add_owned_money(_amount)
	self.queue_free()
