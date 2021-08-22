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

var _person_array = []

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

	_person_array.append(factory1)
	_person_array.append(factory2)
	_person_array.append(government)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_money_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_money[factory_arg] = amount_arg
	
	update_money_in_market()
	
func update_money_in_market():
	var amount:float = 0
	for person in _person_array:
		amount += person.get_money_in_market()
	
	$Bill/MoneyInMarket.set_text(str(amount))
	
func on_chocolates_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_chocolates[factory_arg] = amount_arg
	
	update_chocolate_in_market()
	
func update_chocolate_in_market():
#	var amount:float = 0
#	for factory in _factory_chocolates:
#		amount += _factory_chocolates[factory]

	var amount:float = 0
	for person in _person_array:
		amount += person.get_chocolates_in_market()

	$Chocolate/ChocolatesInMarket.set_text(str(amount))

func on_candies_in_market(amount_arg:float, factory_arg):
#	print(amount_arg,factory_arg)
#	_factory_candies[factory_arg] = amount_arg

	update_candies_in_market()
	
func update_candies_in_market():
#	var amount:float = 0
#	for factory in _factory_candies:
#		amount = +_factory_candies[factory]

	var amount:float = 0
	for person in _person_array:
		amount += person.get_candies_in_market()
	
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
	
	
	
