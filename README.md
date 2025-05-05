# Scene Graph/Node Class

Small, simple, unity inspired scene graph class. This is a very basic implementation of the node class that can be used to create a scene graph for your game.
It consists of two classes:
* SceneGraph: Root of the graph, there is only one instance of this class for each graph and it's the root node
* SceneNode: A node in the graph. It has your implementation of the logic that you want to run on a specific part of the scene.

## Usage

```lua
NODE_TYPE_PLAYER = 1
local g_point <const> = playdate.geometry.point

--- Factory method to create the scene
function create()
    local ret = SceneGraph()

    local playerNode = PlayerNode(g_point.new(50, 10), ...)
    local mapNode = MapNode(g_point.new(0, 0), ...)
    local gameControllerNode = GameControllerNode(...)

    ret:add(playerNode)
    ret:add(mapNode)
    ret:add(gameControllerNode)

    return ret
end

--- main.lua

local graph = create()
graph:start()

function playdate.update()
  graph:update()
end

--- Player implementation

PlayerNode = {}

class('PlayerNode').extends(SceneNode)

function PlayerNode:init(position, ...)
    PlayerNode.super.init(self, "Player", NODE_TYPE_PLAYER, position)
end

--- Note: only override _ functions, otherwise you will have to re-implement the parent implementation
function Player:_start()
end

function Player:_update()
end

function Player:_unload()
end

```



