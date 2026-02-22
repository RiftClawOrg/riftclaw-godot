extends Node

# Passport Manager - Handles agent identity and authentication

var passport: Dictionary = {}

const PASSPORT_FILE = "user://passport.json"

func _ready():
	load_passport()

func load_passport():
	if FileAccess.file_exists(PASSPORT_FILE):
		var file = FileAccess.open(PASSPORT_FILE, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			passport = json.data
			print("[PassportManager] Loaded passport: ", passport.get("agent_id", "unknown"))
		else:
			print("[PassportManager] Failed to parse passport, generating new one")
			generate_passport()
	else:
		print("[PassportManager] No passport found, generating new one")
		generate_passport()

func generate_passport():
	var timestamp = Time.get_unix_time_from_system()
	var random_id = str(randi()).sha256_text().substr(0, 16)
	
	passport = {
		"agent_id": "rift_" + random_id,
		"agent_name": "Traveler",
		"public_key": "",  # TODO: Generate ed25519 keypair
		"home_world": "Limbo",
		"reputation": 0.0,
		"created_at": timestamp,
		"inventory": "[]"
	}
	
	save_passport()
	print("[PassportManager] Generated new passport: ", passport.agent_id)

func save_passport():
	var file = FileAccess.open(PASSPORT_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(passport))
	file.close()

func get_agent_id() -> String:
	return passport.get("agent_id", "")

func get_agent_name() -> String:
	return passport.get("agent_name", "Traveler")

func get_reputation() -> float:
	return passport.get("reputation", 0.0)

func update_reputation(delta: float):
	passport.reputation = get_reputation() + delta
	save_passport()
