extends Node

# Inventory Manager - Handles 8-slot inventory system

signal inventory_changed

const MAX_SLOTS = 8
const MAX_STACK = 999

var inventory: Array = []

func _ready():
	load_inventory()

func load_inventory():
	var passport_inventory = PassportManager.passport.get("inventory", "[]")
	var json = JSON.new()
	var error = json.parse(passport_inventory)
	if error == OK:
		inventory = json.data
	else:
		inventory = []
	print("[InventoryManager] Loaded ", inventory.size(), " items")

func save_inventory():
	PassportManager.passport.inventory = JSON.stringify(inventory)
	PassportManager.save_passport()
	emit_signal("inventory_changed")

func add_item(item_name: String, item_icon: String, quantity: int = 1) -> bool:
	# Try to stack with existing
	for item in inventory:
		if item.name == item_name:
			item.quantity = min(item.quantity + quantity, MAX_STACK)
			save_inventory()
			return true
	
	# Add to new slot if space available
	if inventory.size() < MAX_SLOTS:
		inventory.append({
			"name": item_name,
			"icon": item_icon,
			"quantity": min(quantity, MAX_STACK)
		})
		save_inventory()
		return true
	
	return false

func remove_item(item_name: String, quantity: int = 1) -> bool:
	for i in range(inventory.size()):
		if inventory[i].name == item_name:
			inventory[i].quantity -= quantity
			if inventory[i].quantity <= 0:
				inventory.remove_at(i)
			save_inventory()
			return true
	return false

func get_item_count(item_name: String) -> int:
	for item in inventory:
		if item.name == item_name:
			return item.quantity
	return 0

func has_item(item_name: String) -> bool:
	return get_item_count(item_name) > 0

func get_inventory() -> Array:
	return inventory.duplicate()

func clear_inventory():
	inventory.clear()
	save_inventory()
