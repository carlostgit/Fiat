extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String) var _produced_product_type = "Candy"
export(Texture) var _product_texture = preload("res://candy_small.png")
export(String) var _demanded_product_type = "Chocolate"

export(NodePath) var _shop_node_path = "res://Shop.gd"
export(NodePath) var _government_node_path = "res://Government.gd"

export(float) var _production_rate = 1

var _owned_money:float = 0
var _money_in_market:float = 0
var _consumed_products:float = 0

var _owned_products:float = 0
var _products_in_market:float = 0


var _shop:Node = null
var _government:Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_shop = get_node(_shop_node_path)
	_government = get_node(_government_node_path)

	set_owned_money(self._owned_money)
	set_owned_products(self._owned_products)
	set_products_in_market(self._products_in_market)
	set_money_in_market(self._money_in_market)
	set_consumed_products(self._consumed_products)
	$Product.set_texture(_product_texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func set_shop(shop_arg:Node):
#	_shop = shop_arg
#
#func set_government(government_arg:Node):
#	_government = government_arg

func buy():

	var money_in_market = _money_in_market
	
	if(_demanded_product_type=="Candy"):
		#Factory
		_shop.buy_candies(money_in_market,self)
	elif(_demanded_product_type=="Chocolate"):
		#Factory
		_shop.buy_chocolates(money_in_market,self)
	else:
		#Government
		_shop.buy_candies(money_in_market/2,self)
		_shop.buy_chocolates(money_in_market/2,self)


func update_produced_product_texture():
	$Product.set_texture(_product_texture)

func produce():
	produce_amount(_production_rate)

####

func set_owned_money(amount_arg:float):
	_owned_money = amount_arg
	$Bill/OwnedBills.set_text(str(_owned_money))

func send_all_money_to_market():
	send_money_to_market(_owned_money)
	
func send_money_to_market(amount_arg:float):
	var money_in_market:float = _money_in_market
	var owned_money:float = _owned_money
	set_money_in_market(money_in_market + amount_arg)
	set_owned_money(owned_money - amount_arg)
	
func set_money_in_market(amount_arg:float):
	_money_in_market = amount_arg
	$Bill/BillsInMarket.set_text(str(_money_in_market))
	if (_shop!=null):
		_shop.update_money_in_market()
#	emit_signal("signal_money_in_market",_money_in_market,self)

func remove_money_from_market(amount_arg:float):
	set_money_in_market(_money_in_market-amount_arg)

func get_money_in_market()->float:
	return _money_in_market
####

func add_consumed_products(amount_arg:float):
	set_consumed_products(_consumed_products + amount_arg)
	
func set_consumed_products(amount_arg:float):
	_consumed_products = amount_arg
	$ConsumingProducts/OwnedChocolatesAndCandies.set_text(str(amount_arg))
####

func add_owned_money(amount_arg:float):
	set_owned_money(self._owned_money + amount_arg)

####

func add_owned_products(amount_arg:float):
	set_owned_products(_owned_products + amount_arg)

func set_owned_products(amount_arg:float):
	_owned_products = amount_arg
	$Product/OwnedProduct.set_text(str(_owned_products))
	
func produce_amount(amount_arg:float):
	 set_owned_products(_owned_products+amount_arg)
	
func empty_owned_products():
	set_owned_products(0.0)
	
func send_all_products_to_market():
	send_products_to_market(_owned_products)
	
func send_products_to_market(amount_arg:float):
	set_products_in_market(_products_in_market + amount_arg)
	set_owned_products(_owned_products - amount_arg)
	
func get_products_in_market() -> float:
	return _products_in_market
	
func get_chocolates_in_market()->float:
	if(self._produced_product_type=="Candy"):
		return 0.0
	else:
		return get_products_in_market()

func get_candies_in_market()->float:
	if(self._produced_product_type=="Candy"):
		return get_products_in_market()
	else:
		return 0.0
	
func set_products_in_market(amount_arg:float):
	_products_in_market = amount_arg
	$Product/ProductsInMarket.set_text(str(_products_in_market))
	if (_shop!=null):
		if ("Candy"==_produced_product_type):
			self._shop.update_candies_in_market()
		else:
			self._shop.update_chocolate_in_market()

func remove_products_from_market(amount_arg:float):
	set_products_in_market(_products_in_market-amount_arg)	
