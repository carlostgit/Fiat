extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var _shop_node_path = "res://Shop.gd"
export(NodePath) var _government_node_path = "res://Government.gd"

export(String) var _produced_product_type = "Candy"
export(Texture) var _product_texture = preload("res://candy_small.png")
export(String) var _demanded_product_type = "Chocolate"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Consumer._produced_product_type = _produced_product_type
	$Consumer._demanded_product_type = _demanded_product_type
	$Consumer._product_texture = _product_texture
	
	$Consumer._shop = get_node(_shop_node_path)
	$Consumer._government = get_node(_government_node_path)
	
#	$Consumer.set_shop(get_node(_shop_node_path))
#	$Consumer.set_government(get_node(_government_node_path))
#
	$Consumer.update_produced_product_texture()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_consumer() -> Node:
	return $Consumer
####

func buy():

	var money_in_market = $Consumer._money_in_market
	
	if($Consumer._demanded_product_type=="Candy"):
		$Consumer._shop.buy_candies(money_in_market,$Consumer)
	else:
		$Consumer._shop.buy_chocolates(money_in_market,$Consumer)

####

func get_total_value_in_market():
	var value_of_products_in_market = Globals._product_price*$Consumer._products_in_market
	var total_value_in_market = value_of_products_in_market + $Consumer._money_in_market
	return total_value_in_market
	
####

func _on_ProduceButton_pressed():
	$Consumer.produce()
#	pass # Replace with function body.

func _on_SendProductsToMarketButton_pressed():
	$Consumer.send_all_products_to_market()
#	pass # Replace with function body.

func _on_SendMoneyToMarketButton_pressed():
	$Consumer.send_all_money_to_market()
#	pass # Replace with function body.

func _on_BuyButton_pressed():
	buy()	
	
