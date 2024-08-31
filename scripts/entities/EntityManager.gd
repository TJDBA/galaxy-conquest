
# File: scripts/entities/EntityManager.gd
extends Node

class_name EntityManager

# Stores all entities by their unique ID
var entities: Dictionary = {}

# Adds an entity with specified components
func add_entity(entity_id: String, components: Dictionary):
	if not entities.has(entity_id):
		entities[entity_id] = components

# Adds a component to an existing entity
func add_component(entity_id: String, component_name: String, component_instance: Resource):
	if entities.has(entity_id):
		entities[entity_id][component_name] = component_instance
		print("Added component %s to entity %s" % [component_name, entity_id])
	else:
		print("Entity %s does not exist." % entity_id)

# Retrieves a specific component from an entity
func get_component(entity_id: String, component_name: String):
	if entities.has(entity_id) and entities[entity_id].has(component_name):
		return entities[entity_id][component_name]
	return null

# Updates a component for a given entity
func update_component(entity_id: String, component_name: String, data):
	if entities.has(entity_id):
		entities[entity_id][component_name] = data

# Removes an entity
func remove_entity(entity_id: String):
	entities.erase(entity_id)
