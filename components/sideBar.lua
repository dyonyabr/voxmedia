require "components.sideBarOption"

SideBar = {}

function SideBar:new()
    local obj = {}

    obj.options = {
        SideBarOption:new(obj, 0, "assets/images/icon_user.png", "My Profile"),
        SideBarOption:new(obj, 1, "assets/images/icon_saved.png", "Saved"),
        SideBarOption:new(obj, 2, "assets/images/icon_window.png", "Pizda"),
    }

    obj.max_width = 200
    obj.min_width = 40
    obj.color = colors.main
    obj.coords = {
        x = 0,
        y = 30,
        w = 40,
        h = love.graphics.getHeight()
    }
    obj.hovered = false

    function obj:load()
        for i = 1, #obj.options do
            obj.options[i]:load()
        end
    end

    function obj:mousepressed(x, y, button)
        for i = 1, #obj.options do
            obj.options[i]:mousepressed(x, y, button)
        end
    end

    function obj:update(dt)
        if is_mouse_hover(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h) then
            obj.hovered = true
        else
            obj.hovered = false
        end

        local w = obj.min_width
        if (obj.hovered) then w = obj.max_width end
        obj.coords.w = lerp(obj.coords.w, w, dt * 20)

        for i = 1, #obj.options do
            obj.options[i]:update(dt)
        end
    end

    function obj:draw()
        love.graphics.setBackgroundColor(.05, .05, .05)

        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)

        love.graphics.setScissor(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)

        for i = 1, #obj.options do
            obj.options[i]:draw()
        end

        love.graphics.setScissor()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
