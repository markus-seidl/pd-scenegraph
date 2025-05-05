local pd <const> = playdate
local gfx <const> = playdate.graphics
local g_point <const> = playdate.geometry.point
local g_rect <const> = playdate.geometry.rect

SceneNode = {}

---@class (exact) SceneNode
---@field private _parent SceneGraph|SceneNode
---@field private _started boolean
---@field paused boolean
---@field visible boolean
class('SceneNode').extends()

---comment
---@param position? playdate.geometry.point
---@param nodes? table
function SceneNode:init(name, typeId, position, nodes)
    self.name = name
    self.type = typeId
    self.position = position or g_point.new(0, 0)
    self._nodes = nodes or {}

    self._parent = nil
    self.visible = true
    self.paused = false
    self._started = false
end

---comment Initially shows the scene (like sprite:add()). Can only be called once
function SceneNode:start()
    assert(not self._started, "Node " .. self.name .. " already started")

    self:_start()
    for _, node in pairs(self._nodes) do
        node:start()
    end

    self._started = true
end

function SceneNode:_start() end

function SceneNode:update()
    if not self.paused then
        self:_update()
    end

    for _, node in pairs(self._nodes) do
        node:update()
    end
end

function SceneNode:_update() end

---comment Move this node inside the object space
---@param newPosition playdate.geometry.point
function SceneNode:move(newPosition)
    self.position = newPosition
end

---comment Resolve the current position in world space
---@return playdate.geometry.point
function SceneNode:calculateWorldPosition()
    local pp = self._parent:calculateWorldPosition()
    pp:offset(self.position.x, self.position.y)
    return pp
end

function SceneNode:children()
    return self._nodes
end

function SceneNode:add(node)
    assert(node, "node is nil")
    assert(not node:isa("SceneNode"), "node is not of type SceneNode, but: " .. node.className)

    table.insert(self._nodes, node)
    node._parent = self
    node:_eventNodeAdded(node)

    if self._started then
        node:start()
    end
end

---comment
function SceneNode:_eventNodeAdded(node) end

function SceneNode:remove(node)
    assert(node, "node is nil")
    assert(not node:isa("SceneNode"), "node is not of type SceneNode, but: " .. node.className)

    for i, n in ipairs(self._nodes) do
        if n == node then
            table.remove(self._nodes, i)
            node:_eventNodeRemoved(node)
            break
        end
    end
end

---comment
function SceneNode:_eventNodeRemoved(node) end

function SceneNode:unload()
    self:_unload()

    for _, node in pairs(self._nodes) do
        node:unload()
    end
end

function SceneNode:_unload() end

---comment
---@param visible boolean
function SceneNode:setVisible(visible)
    if self.visible ~= visible then
        self:_eventVisibilityChanged(visible)
    end

    self.visible = visible
    for _, node in pairs(self._nodes) do
        node:setVisible(visible)
    end
end

function SceneNode:_eventVisibilityChanged(visible) end

---comment
---@param paused boolean
function SceneNode:setPaused(paused)
    self.paused = paused
    for _, node in pairs(self._nodes) do
        node:setPaused(paused)
    end
end

---comment
---@param dt table
function SceneNode:appendDebugInfo(dt)
    for _, node in pairs(self._nodes) do
        node:appendDebugInfo(dt)
    end
end

---comment
---@return SceneGraph
function SceneNode:getRoot()
    ---@diagnostic disable-next-line: return-type-mismatch
    return self._parent:getRoot()
end

---comment
---@param typeId any
---@param resTable table
function SceneNode:findAllInChildren(typeId, resTable)
    assert(typeId, "typeId is nil")
    assert(resTable, "resTable is nil")

    if self.type == typeId then
        table.insert(resTable, self)
    end

    for _, node in pairs(self._nodes) do
        node:findAllInChildren(typeId, resTable)
    end
end

function SceneNode:findFirstInChildren(typeId)
    assert(typeId, "typeId is nil")

    for _, node in pairs(self._nodes) do
        local found = node:findFirstInChildren(typeId)
        if found then
            return found
        end
    end
    return nil
end

---comment
---@param pre string
---@param dt table
function SceneNode:tostring(pre, dt)
    self:_tostring(pre, dt)

    pre = pre .. "\t"
    for _, node in pairs(self._nodes) do
        node:tostring(pre, dt)
    end
end

function SceneNode:_tostring(pre, dt)
    table.insert(dt, pre)

    if #self._nodes == 0 then
        table.insert(dt, "- ")
    else
        table.insert(dt, "+ ")
    end

    table.insert(dt, self.name)
    table.insert(dt, " Pos: (")
    table.insert(dt, self.position.x)
    table.insert(dt, ", ")
    table.insert(dt, self.position.y)
    table.insert(dt, ") Visible: ")
    table.insert(dt, self.visible and "true" or "false")
    table.insert(dt, " Paused: ")
    table.insert(dt, self.paused and "true" or "false")
    table.insert(dt, " Started: ")
    table.insert(dt, self._started and "true" or "false")
    table.insert(dt, "\n")
end

import "scene_node_test"
