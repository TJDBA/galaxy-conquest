# File: scripts/SystemDataStruct.gd
extends Resource

class_name System

# Properties
@export var system_id: String
@export var coordinates: Dictionary  # Example: {"sextant": "A1", "sector": "B2"}
@export var system_class: String            # Class of the system (e.g., mining, research, military)
@export var resource_points: int
@export var controlled_by: String = "Uncontrolled" #player_id
@export var population: Dictionary = {}   # {"player_1_id": 0.5, "player_2_id": 0.0} in bi (Billions of Individuals)
@export var contested: bool = false       # Whether the system is currently contested

# Visibility tracking
@export var scanned_by: Array = []        # List of player IDs who have scanned the system (knows system exists)
@export var close_scanned_by: Array = []  # List of player IDs who have close-scanned the system (knows system class)
@export var visited_by: Dictionary = {}  # {"player_1_id": {"controlled_by": "player_1_id", "population": {"player_1_id": 0.5, "player_2_id": 0.1}}}

# Methods

# Update the controller of the system based on population and contest rules
func update_control():
	var players_with_population = []
	
	# Collect players with population ≥ 0.1 bi
	for player_id in population.keys():
		if population[player_id] >= 0.1:
			players_with_population.append(player_id)

	# Check if the system is contested
	contested = players_with_population.size() > 1

	if contested:
		var max_population = 0.0
		var new_controller = null
		var contenders = []

		# Determine the player with the highest population meeting the control threshold
		for player_id in players_with_population:
			var player_population = population[player_id]
			if player_population >= 0.5:
				contenders.append(player_id)
				if player_population > max_population:
					max_population = player_population
					new_controller = player_id
				elif player_population == max_population:
					new_controller = null  # Handle ties

		# Retain control if the current controller is part of the tie
		if new_controller == null and controlled_by in contenders:
			new_controller = controlled_by
		else:
			controlled_by = "Uncontrolled"  # Uncontrolled if tied and no clear prior controller

		controlled_by = new_controller
	else:
		# System is not contested: assign control if only one player has ≥ 0.5 bi
		if players_with_population.size() == 1:
			var player_id = players_with_population[0]
			if population[player_id] >= 0.5:
				controlled_by = player_id
			else:
				controlled_by = "Uncontrolled"
		else:
			controlled_by = "Uncontrolled"  # No players have sufficient population

# Update population for a specific player
func update_population(player_id: String, amount: float):
	if not population.has(player_id):
		population[player_id] = 0.0
	population[player_id] += amount
	
	# Remove the player if population drops below 0.1 bi
	if population[player_id] < 0.1:
		population.erase(player_id)

	update_control()  # Re-evaluate control after population change

# Check if the system is allowed to generate income
func can_generate_income() -> bool:
	return not contested

# Check if the system can build ships
func can_build_ships() -> bool:
	return not contested and system_class in ["shipyard", "military"]  # Example: assuming shipbuilding classes

# Mark the system as scanned by a player
# Scanned players only know the system exists
func mark_scanned(player_id: String):
	if not scanned_by.has(player_id):
		scanned_by.append(player_id)

# Mark the system as close-scanned by a player
# Close-scanned players know the system exists and its class
func mark_close_scanned(player_id: String):
	if not close_scanned_by.has(player_id):
		close_scanned_by.append(player_id)
		mark_scanned(player_id)  # Also add to scanned since they know the system exists

# Mark the system as visited by a player
# Visited players know the system exists, its class, and its resource points
func mark_visited(player_id: String):
	if not visited_by.has(player_id):
		visited_by[player_id] = {}
		visited_by[player_id]["controlled_by"] = controlled_by
		visited_by[player_id]["population"] = population.duplicate()  # Store a snapshot of current population
	mark_close_scanned(player_id)  # Also add to close scanned since they know the class


# Get information visible to a player based on their level of knowledge
func get_visible_info(player_id: String) -> Dictionary:
	var info = {}

# Check if the player has visited the system
	if visited_by.has(player_id):
		info["resource_points"] = resource_points
		info["controlled_by"] = visited_by[player_id].get("controlled_by", "Uncontrolled")
		info["population"] = visited_by[player_id].get("population", {}).duplicate()  # Provide the snapshot of population

# Check if the player has close-scanned the system
	if close_scanned_by.has(player_id):
		info["system_class"] = system_class

# Check if the player has scanned the system
	if scanned_by.has(player_id):
		info["exists"] = true

	return info
 
