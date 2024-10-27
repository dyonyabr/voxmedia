SideBarOption = {}

function SideBarOption:new(side_bar, i, icon_path, label)
    local obj = {}

    obj.side_bar = side_bar
    obj.i = i

    obj.color = { r = colors.bright.r, g = colors.bright.g, b = colors.bright.b, a = 1 }
    obj.coords = {
        x = 0,
        y = 30,
        w = 200,
        h = 40
    }
    obj.hovered = false

    obj.icon = {
        coords = {
            x = 0,
            y = 0,
            w = 40,
            h = obj.coords.h
        },
        padding = 12,
        color = { r = 1, g = 1, b = 1, a = 1 },
        image = love.graphics.newImage(icon_path),
    }

    obj.label = label

    function obj:load()
    end

    function obj:mousepressed(x, y, button)
    end

    function obj:update(dt)
        if is_mouse_hover(obj.coords.x, obj.coords.y + obj.coords.h * obj.i, side_bar.coords.w, obj.coords.h) then
            obj.hovered = true
        else
            obj.hovered = false
        end

        local a = 0
        if (obj.hovered) then a = 1 end
        obj.color.a = lerp(obj.color.a, a, dt * 20)
    end

    function obj:draw()
        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y + obj.coords.h * obj.i, obj.coords.w, obj.coords.h)

        love.graphics.setColor(obj.icon.color.r, obj.icon.color.g, obj.icon.color.b, obj.icon.color.a)
        drawLTWH(obj.icon.image, obj.icon.coords.x + obj.icon.padding,
            (obj.icon.coords.y + obj.icon.padding) + obj.coords.h * obj.i + obj.coords.y,
            obj.icon.coords.w - obj.icon.padding * 2,
            obj.icon.coords.h - obj.icon.padding * 2, true)

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, colors.main_text.a)
        love.graphics.printf(obj.label, WorkSans, obj.icon.coords.w + 5,
            obj.coords.h * obj.i + obj.coords.y + 12,
            love.graphics.getWidth(),
            "left")
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
