extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var _factory_node_path_1
export(NodePath) var _factory_node_path_2
export(NodePath) var _government_node_path
#
#var _factory_candies = {}
#var _factory_chocolates = {}
#var _factory_money = {}

const _MovingProductSceneRes = preload("res://MovingProduct.tscn")

var _person_array = []

var _government = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var factory1 = get_node(_factory_node_path_1)
	factory1.connect("signal_money_in_market",self,"on_money_in_market")
	factory1.connect("signal_candies_in_market",self,"on_candies_in_market")
	factory1.connect("signal_chocolates_in_market",self,"on_chocolates_in_market")
#	pass # Replace with function body.
	var factory2 = get_node(_factory_node_path_2)
	factory2.connect("signal_money_in_market",self,"on_money_in_market")
	factory2.connect("signal_candies_in_market",self,"on_candies_in_market")
	factory2.connect("signal_chocolates_in_market",self,"on_chocolates_in_market")

	var government = get_node(_government_node_path)
	government.connect("signal_remove_products_from_market",self, "on_remove_products_from_market")
	government.connect("signal_money_in_market",self,"on_money_in_market")

	_person_array.append(factory1.get_consumer())
	_person_array.append(factory2.get_consumer())
	_person_array.append(government.get_consumer())
	
	_government = government.get_consumer()
	
	self.update_candies_in_market()
	self.update_chocolate_in_market()
	self.update_money_in_market()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_money_in_market():
	var amount:float = 0
	for person in _person_array:
		amount += person.get_money_in_market()
	return amount

func get_candies_in_market():
	var amount:float = 0
	for person in _person_array:
		amount += person.get_candies_in_market()
	return amount

func get_chocolates_in_market():
	var amount:float = 0
	for person in _person_array:
		amount += person.get_chocolates_in_market()
	return amount

func buy_candies(max_money_arg:float, buyer_arg:Node):
	return buy_products(max_money_arg,buyer_arg,"Candy")
	
func buy_chocolates(max_money_arg:float, buyer_arg:Node):
	return buy_products(max_money_arg,buyer_arg,"Chocolate")

func buy_products(max_money_arg:float, buyer_arg:Node, product_type_arg:String):
	if (Globals._product_price<=0):
		return
	var money_used:float = 0.0
	var max_taxes:float = max_money_arg*Globals._tax_rate
	var max_money_without_taxes = max_money_arg-max_taxes
	var candies_buyable_with_this_money:float = max_money_arg/Globals._product_price
	var candies_in_market:float = self.get_candies_in_market()
	if (product_type_arg!="Candy"):
		candies_in_market = self.get_chocolates_in_market()
	
	var candies_to_buy = min(candies_buyable_with_this_money,candies_in_market)
	var real_taxes:float = candies_to_buy*Globals._product_price*Globals._tax_rate
	
	transfer_money(real_taxes,buyer_arg,self._government)
	
	money_used = candies_to_buy*Globals._product_price
	
	var remaining_candies_to_buy:float = candies_to_buy
	for person in _person_array:
		if (remaining_candies_to_buy>0):
			var amount_candies_of_person:float = person.get_candies_in_market()
			if (product_type_arg!="Candy"):
				amount_candies_of_person = person.get_chocolates_in_market()
			if (0==amount_candies_of_person):
				continue
				
			var amount_of_products_bought_from_person=0
			if(remaining_candies_to_buy>amount_candies_of_person):
				amount_of_products_bought_from_person = amount_candies_of_person				
				remaining_candies_to_buy -=amount_candies_of_person
			else:
				amount_of_products_bought_from_person = remaining_candies_to_buy
				remaining_candies_to_buy = 0
			var money_to_seller_after_taxes = Globals.get_price_without_taxes()*amount_of_products_bought_from_person
			
			exchange(buyer_arg, person, money_to_seller_after_taxes, amount_of_products_bought_from_person, product_type_arg)
	
	return money_used

func exchange(buyer_arg:Node, seller_arg:Node, money_amount_arg:float, product_amount_arg:float, product_type_arg:String):
#	var transaction:Dictionary = {
#		"buyer":buyer_arg, 
#		"seller":seller_arg, 
#		"money_amount": money_amount_arg, 
#		"product_amount":product_amount_arg,
#		"product_type":product_type_arg
#		}

	if (money_amount_arg>0 or product_amount_arg>0):
		seller_arg.remove_products_from_market(product_amount_arg)
	#	seller_arg.add_owned_money(money_amount_arg)
		create_moving_product(buyer_arg,seller_arg,"Money",money_amount_arg)

		buyer_arg.remove_money_from_market(money_amount_arg)	
	#	buyer_arg.add_consumed_products(product_amount_arg)	
		create_moving_product(seller_arg,buyer_arg,product_type_arg,product_amount_arg)
	

func transfer_money(amount_arg:float,origin_arg:Node,destiny_arg:Node):
#	destiny_arg.add_owned_money(amount_arg)
	if (amount_arg>0):
		origin_arg.remove_money_from_market(amount_arg)
		create_moving_product(origin_arg,destiny_arg,"Money",amount_arg)
		

func create_moving_product(origin_arg:Node2D,destiny_arg:Node2D,product_type_arg:String,amount_arg:float):
	var movingProd = _MovingProductSceneRes.instance()
#	$"../".add_child(movingProd)
	self.get_parent().add_child(movingProd)
	movingProd.init(origin_arg,destiny_arg, product_type_arg,amount_arg)

func on_money_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_money[factory_arg] = amount_arg
	
	update_money_in_market()
	
func update_money_in_market():
#	var amount:float = 0
#	for person in _person_array:
#		amount += person.get_money_in_market()
#
	var amount:float = get_money_in_market()
	$Bill/MoneyInMarket.set_text(str(amount))
	
func on_chocolates_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_chocolates[factory_arg] = amount_arg
	
	update_chocolate_in_market()
	
func update_chocolate_in_market():
	
	var amount:float = get_chocolates_in_market()
	$Chocolate/ChocolatesInMarket.set_text(str(amount))

func on_candies_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_candies[factory_arg] = amount_arg

	update_candies_in_market()
	
func update_candies_in_market():

	var amount:float = self.get_candies_in_market()
	$Candies/CandiesInMarket.set_text(str(amount))

func on_remove_products_from_market(amount_arg:float, factory_arg):
	var remaining_products_to_remove:float = amount_arg
	for person in _person_array:
		var amount_in_person = person.get_candies_in_market()
		if (remaining_products_to_remove > amount_in_person):
			person = 0.0
			remaining_products_to_remove -= amount_in_person
		else:
			person = amount_in_person - remaining_products_to_remove
			remaining_products_to_remove = 0.0
	
	for person in _person_array:
		var amount_in_person = person.get_chocolates_in_market()
		if (remaining_products_to_remove > amount_in_person):
			person = 0.0
			remaining_products_to_remove -= amount_in_person
		else:
			person = amount_in_person - remaining_products_to_remove
			remaining_products_to_remove = 0.0
	
	update_candies_in_market()
	update_chocolate_in_market()	


func get_amount_of_products() -> float:
#	var total_amount:float = 0.0
#	for factory in _factory_candies:
#		var amount_in_factory = _factory_candies[factory]
#		total_amount += amount_in_factory
#	for factory in _factory_chocolates:
#		var amount_in_factory = _factory_chocolates[factory]
#		total_amount += amount_in_factory

	var total_amount:float = 0
	for person in _person_array:
		total_amount += person.get_products_in_market()
		
	return total_amount

func get_amount_of_money() -> float:
#	var total_amount:float = 0.0
#	for factory in _factory_money:
#		var amount_in_factory = _factory_money[factory]
#		total_amount += amount_in_factory

	var total_amount:float = 0
	for person in _person_array:
		total_amount += person.get_money_in_market()
	
		
	return total_amount

func calculate_price():
	var amount_of_products:float = get_amount_of_products()
	var amount_of_money:float = get_amount_of_money()
	
	if (amount_of_products<0.01):
		$Prices/WithTaxes/Price.set_text("Error")
		$Prices/WithoutTaxes/Price.set_text("Error")
		return

	var money_per_product:float = amount_of_money/amount_of_products
	
	set_product_price(money_per_product)
	
	var amount_of_taxes:float = Globals._tax_rate*amount_of_money
	var amount_of_money_after_taxes = amount_of_money-amount_of_taxes
	
	var money_per_product_after_taxes:float = amount_of_money_after_taxes/amount_of_products
	
	set_product_selling_price(money_per_product_after_taxes)

func set_product_price(price_arg:float):
	Globals._product_price = price_arg
	$Prices/WithTaxes/Price.set_text(str(Globals._product_price))

func set_product_selling_price(price_arg:float):
	$Prices/WithoutTaxes/Price.set_text(str(price_arg))

func _on_CalculatePrices_pressed():
	calculate_price()
	
	
	
