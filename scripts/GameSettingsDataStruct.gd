# File: scripts/GameSettingsDataStruct.gd
extends Resource

class_name GameSettings

# Game Identification and Basic Info
@export var game_id: String
@export var game_name: String = "New Game"

# Player Configuration
@export var number_of_players: int = 2
@export var players: Dictionary = {}  # Dictionary of player details with player_id as keys

# System Classes Definition
@export var system_class: Dictionary = {
	"A": {"min_resource": 31, "max_resource": 36},
	"B": {"min_resource": 25, "max_resource": 30},
	"C": {"min_resource": 19, "max_resource": 24},
	"D": {"min_resource": 13, "max_resource": 18},
	"E": {"min_resource": 2, "max_resource": 12}
}

# Map Configuration
@export var map_size: Vector2i = Vector2i(6, 6)  # Example size in sextants

# Density Settings for Starting Sextants
@export var starting_sextant_density: Dictionary = {
	"A": {"min_count": 1, "max_count": 1},
	"B": {"min_count": 1, "max_count": 2},
	"C": {"min_count": 2, "max_count": 3},
	"D": {"min_count": 3, "max_count": 5},
	"E": {"min_count": 4, "max_count": 8}
}

# Density Settings for Other Sextants
@export var other_sextant_density: Dictionary = {
	"A": {"min_count": 0, "max_count": 1},
	"B": {"min_count": 1, "max_count": 2},
	"C": {"min_count": 1, "max_count": 3},
	"D": {"min_count": 2, "max_count": 5},
	"E": {"min_count": 3, "max_count": 10}
}

# Game Rules
@export var turn_time_limit: int = 7  # Time limit per turn in days
@export var conflict_response_time: int = 2  # Response time for conflict events in days

# Tech and Unit Configuration
@export var enabled_tech_upgrades: Array = ["ship_movement", "transport_upgrades", "scanner_range", "weapon_upgrades"]

# Add a player to the game
func add_player(player_id: String, name: String, email: String):
	if not players.has(player_id):
		var invite_code = generate_invite_code(player_id)
		players[player_id] = {
			"name": name,
			"email": email,
			"invite_code": invite_code,
			"faction_setup_done": false  # Initially set as not setup
		}
		number_of_players = players.size()

# Generate a unique invite code for each player
func generate_invite_code(player_id: String) -> String:
	return str(game_id) + "_" + str(player_id) + "_" + str(randi())

# Mark players as not playing if they haven't set up their factions when the game starts
func start_game():
	for player_id in players.keys():
		if not players[player_id]["faction_setup_done"]:
			players[player_id]["playing"] = false  # Mark as not playing
		else:
			players[player_id]["playing"] = true  # Confirm as playing

# Function to create a new system based on class type
func generate_system(system_type: String) -> Dictionary:
	var system_data = {}

	if system_class.has(system_type):
		var class_info = system_class[system_type]
		var min_resource = class_info["min_resource"]
		var max_resource = class_info["max_resource"]

		# Randomly assign resources within the range
		var resource_points = randi_range(min_resource, max_resource)

		# Assign the generated data to the system
		system_data["class"] = system_type
		system_data["resource_points"] = resource_points
	else:
		print("Invalid system type specified: %s" % system_type)

	return system_data

# Method to validate the total max counts in density settings
func validate_density(density: Dictionary) -> bool:
	var total_max = 0
	for class_type in density.keys():
		total_max += density[class_type]["max_count"]

	if total_max > 200:
		print("Total max count exceeds 200 hex cells: %d" % total_max)
		return false
	return true

# Method to validate both density settings
func validate_density_settings() -> bool:
	return validate_density(starting_sextant_density) and validate_density(other_sextant_density)

# Function to validate all settings before starting the game
func validate_settings() -> bool:
	if number_of_players < 2 or number_of_players > 24:
		print("Invalid number of players: Must be bcetween 2 and 24.")
		return false
	if not validate_density_settings():
		print("Density settings are invalid.")
		return false
	return true
