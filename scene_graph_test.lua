local g_point <const> = playdate.geometry.point

TestSceneGraph = {
    testBasicFunctions = function()
        local sg = SceneGraph()
        sg._eventNodeAdded = function(self, node)
            self.eventCalled = true
        end

        local node01 = SceneNode()
        local node02 = SceneNode()

        sg:add(node01)
        sg:add(node02)

        luaunit.assertEquals(#(sg:children()), 2)
        luaunit.assertIsTrue(sg.eventCalled)

        luaunit.assertEquals(sg, node01._parent)
        luaunit.assertEquals(sg, node02._parent)
    end,
    testHierarchy = function()
        local sg = SceneGraph()
        sg._eventNodeAdded = function(self, node)
            self.eventCalled = true
        end

        local node01 = SceneNode()
        local node02 = SceneNode()

        node01:add(node02)

        sg:add(node01)

        luaunit.assertEquals(#(sg:children()), 1)
        luaunit.assertIsTrue(sg.eventCalled)

        luaunit.assertEquals(sg, node01._parent)
        luaunit.assertEquals(node01, node02._parent)
    end,
    testVisible = function()
        local sg = SceneGraph()

        local node01 = SceneNode()
        local node02 = SceneNode()

        node01:add(node02)
        sg:add(node01)

        sg:setVisible(false)

        luaunit.assertEquals(#(sg:children()), 1)
        luaunit.assertIsFalse(node01.visible)
        luaunit.assertIsFalse(node02.visible)
        luaunit.assertIsFalse(sg.visible)
    end,
    testPosition = function()
        local sg = SceneGraph()

        local node01 = SceneNode()
        local node02 = SceneNode()

        node01:add(node02)
        sg:add(node01)

        node01:move(g_point.new(5, 6))
        node02:move(g_point.new(5, 6))

        luaunit.assertEquals(#(sg:children()), 1)

        local node02Pos = node02:calculateWorldPosition()
        luaunit.assertEquals(node02Pos.x, 10)
        luaunit.assertEquals(node02Pos.y, 12)

        local node01Pos = node01:calculateWorldPosition()
        luaunit.assertEquals(node01Pos.x, 5)
        luaunit.assertEquals(node01Pos.y, 6)
    end
}
