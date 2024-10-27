require "components.sideBar"

MainPage = {}

function MainPage:new()
    local obj = {}

    obj.side_bar = SideBar:new()

    function obj:load()
        obj.side_bar:load()
    end

    function obj:mousepressed(x, y, button)
        obj.side_bar:mousepressed(x, y, button)
    end

    function obj:update(dt)
        obj.side_bar:update(dt)
    end

    function obj:draw()
        love.graphics.setBackgroundColor(colors.dark.r, colors.dark.g, colors.dark.b, colors.dark.a)
        obj.side_bar:draw()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
