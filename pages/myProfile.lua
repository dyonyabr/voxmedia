MyProfile = {}

function MyProfile:new()
    local obj = {}

    obj.offset = { x = 40, y = 30 }

    obj.button = Button:new("Button", function() print("button_pressed") end, 100, 200, 100, 30, obj.offset.x,
        obj.offset.y)

    obj.avatar = {
        image = love.graphics.newImage("assets/images/test_avatar.png"),
        x = love.graphics.getWidth() - obj.offset.x - 100,
        y = 100,
        radius = 60
    }

    obj.cap = {
        image = love.graphics.newImage("assets/images/test_cap.jpg"),
        x = 0,
        y = 0,
        w = love.graphics.getWidth() - obj.offset.x,
        h = obj.avatar.y
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
    end

    function obj:draw()
        love.graphics.origin()
        set_offset(obj.offset.x, obj.offset.y)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(obj.cap.image, obj.cap.quad, obj.cap.x, obj.cap.y)

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
        love.graphics.setStencilTest()

        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        love.graphics.printf("228 Posts", WorkSans, obj.cap.x, obj.avatar.y + 45,
            obj.avatar.x - obj.avatar.radius, "right")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        love.graphics.printf("AntonGondon", WorkSansBig, obj.cap.x, obj.avatar.y + 15,
            obj.avatar.x - obj.avatar.radius - 15, "right")

        obj.button:draw()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
