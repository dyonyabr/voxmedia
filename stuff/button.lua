Button = {}

function Button:new(text, click_func, x, y, w, h, ox, oy)
    local obj = {}

    obj.text = text

    obj.click_effect = ClickEffect:new()

    obj.color = { r = colors.button.r, g = colors.button.g, b = colors.button.b, a = 1 }
    obj.coords = {
        x = x + offset.x,
        y = y + offset.y,
        w = w,
        h = h
    }
    obj.hovered = false

    function obj:load()
    end

    function obj:update(dt)
        if is_mouse_hover(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h, ox, oy) then
            obj.hovered = true
            set_cursor("hand")
        else
            obj.hovered = false
        end

        local r, g, b = colors.button.r, colors.button.g, colors.button.b
        if obj.hovered then
            r, g, b = colors.button_hover.r, colors.button_hover.g, colors.button_hover.b
        end
        obj.color.r = lerp(obj.color.r, r, dt * 20)
        obj.color.g = lerp(obj.color.g, g, dt * 20)
        obj.color.b = lerp(obj.color.b, b, dt * 20)

        obj.click_effect:update(dt)
    end

    function obj:mousepressed(x, y, button)
        if obj.hovered then
            if button == 1 then
                obj.click_effect:do_click(x - ox, y - oy)
                click_func()
            end
        end
    end

    function obj:draw()
        love.graphics.setScissor(obj.coords.x + offset.x, obj.coords.y + offset.y, obj.coords.w, obj.coords.h)

        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)

        obj.click_effect:draw()

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, colors.main_text.a)
        love.graphics.printf(obj.text, WorkSans, obj.coords.x + 5, obj.coords.y + obj.coords.h / 2 - 10,
            obj.coords.w - 10,
            "center")

        love.graphics.setScissor()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
