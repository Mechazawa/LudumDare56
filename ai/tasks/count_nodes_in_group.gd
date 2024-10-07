## Based on LimboAI get_first_in_group written by Serhii Snitsaruk
## https://github.com/limbonaut/limboai/blob/master/demo/demo/ai/tasks/get_first_in_group.gd

@tool
extends BTAction
## Stores the first node in the [member group] on the blackboard, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if the group contains 0 nodes.

## Name of the SceneTree group.
@export var group: StringName

## Blackboard variable in which the task will store the acquired node.
@export var output_var: StringName = &"target"


func _generate_name() -> String:
	return "CountNodesInGroup \"%s\"  ➜%s" % [
		group,
		LimboUtility.decorate_var(output_var)
	]

func _tick(_delta: float) -> Status:
	blackboard.set_var(output_var, agent.get_tree().get_nodes_in_group(group).size())
	return SUCCESS
