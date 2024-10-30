WindowTopBar = {}

function WindowTopBar:new()
    local obj = {}

    obj.offset = { x = 0, y = 0 }

    obj.color = colors.bright
    obj.coords = {
        x = 0,
        y = 0,
        w = love.graphics.getWidth(),
        h = 30
    }

    obj.mp = { x = 0, y = 0 }
    obj.selected = false

    obj.close = {
        coords = {
            x = obj.coords.w - 50,
            y = 0,
            w = 50,
            h = obj.coords.h
        },
        width = 50,
        color = { r = colors.red.r, g = colors.red.g, b = colors.red.b, a = 0 },
        image = icons.close,
        padding = 6,
        hovered = false
    }

    obj.minimize = {
        coords = {
            x = obj.coords.w - 50 - obj.close.width,
            y = 0,
            w = 50,
            h = obj.coords.h
        },
        color = { r = colors.button_hover.r, g = colors.button_hover.g, b = colors.button_hover.b, a = 0 },
        image = icons.minimize,
        padding = 6,
        hovered = false
    }

    function obj:load()

    end

    function obj:update(dt)
        if love.mouse.isDown(1) and obj.selected then
            local x, y = love.window.getPosition()
            local m_cur_x, m_cur_y = love.mouse.getPosition()
            love.window.setPosition(m_cur_x + x - obj.mp.x,
                m_cur_y + y - obj.mp.y)
        else
            obj.selected = false
        end

        if is_mouse_hover(obj.close.coords.x, obj.close.coords.y, obj.close.coords.w, obj.close.coords.h, obj.offset.x, obj.offset.y) then
            set_cursor("hand")
            obj.close.hovered = true
        else
            obj.close.hovered = false
        end

        if is_mouse_hover(obj.minimize.coords.x, obj.minimize.coords.y, obj.minimize.coords.w, obj.minimize.coords.h, obj.offset.x, obj.offset.y) then
            set_cursor("hand")
            obj.minimize.hovered = true
        else
            obj.minimize.hovered = false
        end

        obj.close.color.a = lerp(obj.close.color.a, obj.close.hovered and 1 or 0, dt * 20)
        obj.minimize.color.a = lerp(obj.minimize.color.a, obj.minimize.hovered and 1 or 0, dt * 20)
    end

    function obj:mousepressed(x, y, button)
        if button == 1 then
            if is_mouse_hover(obj.coords.x, obj.coords.y, obj.coords.w - obj.close.coords.w - obj.minimize.coords.w, obj.coords.h, obj.offset.x, obj.offset.y) then
                obj.selected = true
                obj.mp = { x = x, y = y }
            end

            if obj.close.hovered then love.event.quit() end
            if obj.minimize.hovered then love.window.minimize() end
        end
    end

    function obj:draw()
        love.graphics.origin()
        set_offset(obj.offset.x, obj.offset.y)

        box_shadow(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h, 20, { 0, 0, 0, .35 })

        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, colors.main_text.a)
        love.graphics.printf("VoxMedia", fonts.WorkSans, 15, 6, love.graphics.getWidth(), "left")

        love.graphics.setColor(obj.close.color.r, obj.close.color.g, obj.close.color.b, obj.close.color.a)
        love.graphics.rectangle("fill", obj.close.coords.x, obj.close.coords.y, obj.close.coords.w, obj.close.coords.h)
        love.graphics.setColor(colors.white.r, colors.white.g, colors.white.b, colors.white.a)
        drawLTWH(obj.close.image, obj.close.coords.x + obj.close.padding, obj.close.coords.y + obj.close.padding,
            obj.close.coords.w - obj.close.padding * 2,
            obj.close.coords.h - obj.close.padding * 2, "horizontal")

        love.graphics.setColor(obj.minimize.color.r, obj.minimize.color.g, obj.minimize.color.b, obj.minimize.color.a)
        love.graphics.rectangle("fill", obj.minimize.coords.x, obj.minimize.coords.y, obj.minimize.coords.w,
            obj.minimize.coords.h)
        love.graphics.setColor(colors.white.r, colors.white.g, colors.white.b, colors.white.a)
        drawLTWH(obj.minimize.image, obj.minimize.coords.x + obj.minimize.padding,
            obj.minimize.coords.y + obj.minimize.padding, obj.minimize.coords.w - obj.minimize.padding * 2,
            obj.minimize.coords.h - obj.minimize.padding * 2, "horizontal")
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
