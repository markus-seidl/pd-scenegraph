
local g_point <const> = playdate.geometry.point

TestSceneNode = {
    testBasicFunctions = function()
        local sg = SceneGraph()

        local node01 = SceneNode()
        node01._update = function(self)
            self.updateCalled = true
        end
        node01._unload = function(self)
            self.unloadCalled = true
        end

        local node02 = SceneNode()
        node02._update = function(self)
            self.updateCalled = true
        end
        node02._unload = function(self)
            self.unloadCalled = true
        end

        sg:add(node01)
        sg:add(node02)

        sg:update()

        luaunit.assertEquals(#(sg:children()), 2)
        luaunit.assertIsTrue(node01.updateCalled)
        luaunit.assertIsTrue(node02.updateCalled)

        sg:unload()

        luaunit.assertIsTrue(node01.unloadCalled)
        luaunit.assertIsTrue(node02.unloadCalled)
    end,
}
