# File: scripts/GameStateManager.gd
extends Node

class_name GameStateManager

# In-memory storage of entities and components
var entities: Dictionary = {}  # Stores all entities by ID

# Current turn number
var current_turn_number: int = 0

# Adds a new entity with specified components
func add_entity(entity_id: String, components: Dictionary = {}):
	if not entities.has(entity_id):
		entities[entity_id] = components

# Retrieves a component from an entity
func get_component(entity_id: String, component_name: String):
	if entities.has(entity_id) and entities[entity_id].has(component_name):
		return entities[entity_id][component_name]
	return null

# Updates a component of an entity
func update_component(entity_id: String, component_name: String, data):
	if entities.has(entity_id):
		entities[entity_id][component_name] = data

# Removes an entity
func remove_entity(entity_id: String):
	entities.erase(entity_id)
