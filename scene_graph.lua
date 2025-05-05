local pd <const> = playdate
local gfx <const> = playdate.graphics
local g_point <const> = playdate.geometry.point
local g_rect <const> = playdate.geometry.rect

SceneGraph = {}

---@class (exact) SceneGraph
---@field visible boolean
---@field paused boolean
---@field private _nodes table
class('SceneGraph').extends()

---comment
---@param nodes table?
function SceneGraph:init(nodes)
    self.visible = true
    self.paused = false
    self._nodes = nodes or {}
    self._started = false
end

---comment Resolve the current position in world space
---@return playdate.geometry.point
function SceneGraph:calculateWorldPosition()
    return g_point.new(0, 0)
end

function SceneGraph:children()
    return self._nodes
end

---comment Initially shows the scene (like sprite:add()). Can only be called once
function SceneGraph:start()
    assert(not self._started, "Scene already started")

    for _, node in pairs(self._nodes) do
        node:start()
    end

    self._started = true
end

---comment
---@param node SceneNode
function SceneGraph:add(node)
    assert(node, "node is nil")
    assert(not node:isa("SceneNode"), "node is not of type SceneNode, but: " .. node.className)

    table.insert(self._nodes, node)
    node._parent = self
    self:_eventNodeAdded(node)

    if self._started then
        node:start()
    end
end

function SceneGraph:_eventNodeAdded(node) end

---comment
---@param node SceneNode
function SceneGraph:remove(node)
    assert(node, "node is nil")
    assert(not node:isa("SceneNode"), "node is not of type SceneNode, but: " .. node.className)

    for i, n in ipairs(self._nodes) do
        if n == node then
            table.remove(self._nodes, i)
            self:_eventNodeRemoved(node)
            break
        end
    end
end

function SceneGraph:_eventNodeRemoved(node) end

function SceneGraph:update()
    if self.paused then return end

    for _, node in pairs(self._nodes) do
        node:update()
    end
end

function SceneGraph:unload()
    for _, node in pairs(self._nodes) do
        node:unload()
    end
end

---comment
---@param visible boolean
function SceneGraph:setVisible(visible)
    self.visible = visible
    for _, node in pairs(self._nodes) do
        node:setVisible(visible)
    end
end

---comment
---@param paused boolean
function SceneGraph:setPaused(paused)
    self.paused = paused
    for _, node in pairs(self._nodes) do
        node:setPaused(paused)
    end
end

---comment
---@param dt table
function SceneGraph:appendDebugInfo(dt)
    for _, node in pairs(self._nodes) do
        node:appendDebugInfo(dt)
    end
end

---comment
---@return SceneGraph
function SceneGraph:getRoot()
    ---@diagnostic disable-next-line: return-type-mismatch
    return self
end

---comment
---@param typeId any
---@param resTable table (optional)
---@return table
function SceneGraph:findAllInChildren(typeId, resTable)
    resTable = resTable or {}
    for _, node in pairs(self._nodes) do
        node:findAllInChildren(resTable, typeId)
    end
    return resTable
end

function SceneGraph:findFirstInChildren(typeId)
    for _, node in pairs(self._nodes) do
        local found = node:findFirstInChildren(typeId)
        if found then
            return found
        end
    end
    return nil
end

---comment
---@return table
function SceneGraph:tostring()
    local pre = "\t"
    local dt = {}
    table.insert(dt, "Scene graph:\n")
    for _, node in pairs(self._nodes) do
        node:tostring(pre, dt)
    end

    return dt
end

import "scene_graph_test"
