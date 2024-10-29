MyProfile = {}

function MyProfile:new()
    local obj = {}

    obj.offset = { x = 40, y = 30 }

    obj.button = Button:new("Button", function() print("button_pressed") end, 100, 200, 100, 30, 10, obj.offset.x,
        obj.offset.y, true)

    obj.avatar = {
        image = love.graphics.newImage("assets/images/test_avatar.png"),
        x = love.graphics.getWidth() - obj.offset.x - 100,
        y = 100,
        radius = 60,
        hovered = false,
        edit_y = 0,
        edit_icon = love.graphics.newImage("assets/icons/icon_photo.png")
    }

    obj.cap = {
        image = love.graphics.newImage("assets/images/test_cap.png"),
        x = 0,
        y = 0,
        w = love.graphics.getWidth() - obj.offset.x,
        h = obj.avatar.y,
        hovered = false,
        edit_a = 0,
        edit_icon = love.graphics.newImage("assets/icons/icon_edit.png")
    }
    obj.cap.quad = love.graphics.newQuad(0, 0, obj.cap.w, obj.cap.h, obj.cap.image:getWidth(), obj.cap.image:getHeight())

    function obj:load()
        obj.button:load()
    end

    function obj:mousepressed(x, y, button)
        obj.button:mousepressed(x, y, button)
    end

    function obj:update(dt)
        obj.button:update(dt)

        if is_mouse_hover_circle(obj.avatar.x, obj.avatar.y, obj.avatar.radius, obj.offset.x, obj.offset.y) then
            set_cursor("hand")
            obj.avatar.hovered = true
        else
            obj.avatar.hovered = false
        end

        local cap_edit_y = 0
        if obj.avatar.hovered then cap_edit_y = 40 end
        obj.avatar.edit_y = lerp(obj.avatar.edit_y, cap_edit_y, dt * 20)

        if is_mouse_hover(obj.cap.x, obj.cap.y, obj.cap.w, obj.cap.h, obj.offset.x, obj.offset.y) and not obj.avatar.hovered then
            set_cursor("hand")
            obj.cap.hovered = true
        else
            obj.cap.hovered = false
        end

        local cap_edit_a = 0
        if obj.cap.hovered then cap_edit_a = 1 end
        obj.cap.edit_a = lerp(obj.cap.edit_a, cap_edit_a, dt * 20)
    end

    function obj:draw()
        love.graphics.origin()
        set_offset(obj.offset.x, obj.offset.y)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(obj.cap.image, obj.cap.quad, obj.cap.x, obj.cap.y)
        love.graphics.setColor(colors.button.r, colors.button.g, colors.button.b, obj.cap.edit_a)
        love.graphics.rectangle("fill", love.graphics.getWidth() - obj.offset.x - 50, 10, 40, 40, 7)
        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.cap.edit_a)
        drawLTWH(obj.cap.edit_icon, love.graphics.getWidth() - obj.offset.x - 40, 20, 20, 20)

        love.graphics.setScissor(obj.cap.x + obj.offset.x, obj.cap.y + obj.offset.y, obj.cap.w, obj.cap.h)
        circle_shadow(obj.avatar.x, obj.avatar.y, obj.avatar.radius, 20, { 0, 0, 0, .5 })
        love.graphics.setScissor()

        love.graphics.stencil(function()
            love.graphics.circle("fill", obj.avatar.x, obj.avatar.y, obj.avatar.radius)
        end, "replace", 1)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setStencilTest("greater", 0)
        drawLTWH(obj.avatar.image, obj.avatar.x - obj.avatar.radius, obj.avatar.y - obj.avatar.radius,
            obj.avatar.radius * 2,
            obj.avatar.radius * 2)

        love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
        love.graphics.rectangle("fill", obj.avatar.x - obj.avatar.radius,
            obj.avatar.y + obj.avatar.radius - obj.avatar.edit_y, obj.avatar.radius * 2, obj.avatar.radius * 2)
        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        drawLTWH(obj.avatar.edit_icon, obj.avatar.x - obj.avatar.radius + 10,
            obj.avatar.y + obj.avatar.radius - obj.avatar.edit_y + 10, obj.avatar.radius * 2 - 20, 40 - 20, "horizontal")
        love.graphics.setStencilTest()

        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        love.graphics.printf("228 Posts", WorkSans, obj.cap.x, obj.avatar.y + 40,
            obj.avatar.x - obj.avatar.radius, "right")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        love.graphics.printf("AntonGondon", WorkSansBig, obj.cap.x, obj.avatar.y + 10,
            obj.avatar.x - obj.avatar.radius - 15, "right")

        obj.button:draw()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
