require "components.pagePost"
MyProfile = {}

function MyProfile:new()
    local obj = {}

    obj.offset = { x = 40, y = 30 }
    obj.can_swipe = true
    obj.swap_timer = Timer()

    obj.tone = 0
    obj.tone_lerp = 0

    obj.avatar = {
        image = images.test_avatar,
        x = love.graphics.getWidth() - obj.offset.x - 100,
        y = 100,
        radius = 60,
        hovered = false,
        edit_y = 0,
        edit_icon = icons.photo
    }

    obj.cap = {
        image = images.test_cap,
        x = 0,
        y = 0,
        w = love.graphics.getWidth() - obj.offset.x,
        h = obj.avatar.y,
        hovered = false,
        edit_a = 0,
        edit_icon = icons.edit
    }
    obj.cap.quad = love.graphics.newQuad(0, 0, obj.cap.w, obj.cap.h, obj.cap.image:getWidth(), obj.cap.image:getHeight())

    obj.post_offset = {
        x = (love.graphics.getWidth() - obj.offset.x) / 2 - 330,
        y = obj.avatar.y + obj.avatar.radius +
            40
    }

    obj.posts = {}
    for i = 0, 9 do
        obj.posts[i + 1] = PagePost:new(obj, i, obj.post_offset.x, obj.post_offset.y,
            obj.offset.x,
            obj.offset.y)
    end

    obj.cur_post = 0
    function obj:set_cur_post(value) obj.cur_post = clamp(value, 0, #obj.posts - 1) end

    obj.post_trans = 0

    obj.post_count = {
        x = (love.graphics.getWidth() - obj.offset.x) / 2 - 50,
        y = love.graphics.getHeight() - 75,
        w = 100
    }

    obj.post_left = IconButton:new(icons.arrow_left,
        function() obj:set_cur_post(obj.cur_post - 1) end,
        obj.post_count.x - 20, love.graphics.getHeight() - 65, 20, 12, true, obj.offset.x,
        obj.offset.y)

    obj.post_right = IconButton:new(icons.arrow_right,
        function() obj:set_cur_post(obj.cur_post + 1) end,
        obj.post_count.x + obj.post_count.w + 20, love.graphics.getHeight() - 65, 20, 12, true, obj.offset.x,
        obj.offset.y)

    function obj:load()
        for i = 1, #obj.posts do
            obj.posts[i]:load()
        end
        obj.post_left:load()
        obj.post_right:load()
    end

    function obj:keypressed(k)
        if not obj.posts[obj.cur_post + 1].content.clicked then
            if k == "left" then
                obj:set_cur_post(obj.cur_post - 1)
            elseif k == "right" then
                obj:set_cur_post(obj.cur_post + 1)
            end
        end
    end

    function obj:mousepressed(x, y, button)
        obj.posts[obj.cur_post + 1]:mousepressed(x, y, button)
        obj.post_left:mousepressed(x, y, button)
        obj.post_right:mousepressed(x, y, button)
    end

    function obj:wheelmoved(x, y)
        obj.posts[obj.cur_post + 1]:wheelmoved(x, y)
    end

    function obj:mousereleased(x, y, button)
        obj.posts[obj.cur_post + 1]:mousereleased(x, y, button)
    end

    function obj:mousemoved(x, y, dx, dy)
        obj.posts[obj.cur_post + 1]:mousemoved(x, y, dx, dy)
    end

    function obj:update(dt)
        obj.swap_timer:update(dt)

        if obj.cur_post ~= 0 then obj.posts[obj.cur_post]:update(dt) end
        obj.posts[obj.cur_post + 1]:update(dt)
        if obj.cur_post ~= #obj.posts - 1 then obj.posts[obj.cur_post + 2]:update(dt) end

        if not obj.posts[obj.cur_post + 1].content.clicked then
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

            obj.post_left:update(dt)
            obj.post_right:update(dt)
        end

        obj.post_trans = lerp(obj.post_trans, -700 * obj.cur_post, dt * 10)
        obj.tone_lerp = lerp(obj.tone_lerp, obj.posts[obj.cur_post + 1].tone, dt * 10)
    end

    function obj:draw()
        love.graphics.origin()
        set_offset(obj.offset.x, obj.offset.y)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(obj.cap.image, obj.cap.quad, obj.cap.x, obj.cap.y)
        love.graphics.setColor(colors.button.r, colors.button.g, colors.button.b, obj.cap.edit_a)
        love.graphics.rectangle("fill", love.graphics.getWidth() - obj.offset.x - 40, 10, 30, 30, 7)
        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.cap.edit_a)
        drawLTWH(obj.cap.edit_icon, love.graphics.getWidth() - obj.offset.x - 35, 15, 20, 20)

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
        love.graphics.printf(#obj.posts .. " Posts", fonts.WorkSans, obj.cap.x, obj.avatar.y + 40,
            obj.avatar.x - obj.avatar.radius - 20, "right")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        love.graphics.printf("AntonGondon", fonts.WorkSansBig, obj.cap.x, obj.avatar.y + 10,
            obj.avatar.x - obj.avatar.radius - 15, "right")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        love.graphics.printf("Posts", fonts.WorkSansBig, obj.post_offset.x + 15, obj.post_offset.y - 50,
            love.graphics.getWidth(), "left")

        if not obj.posts[obj.cur_post + 1].content.clicked then
            if obj.cur_post ~= 0 then
                obj.post_left:draw()
            end
            if obj.cur_post ~= #obj.posts - 1 then
                obj.post_right:draw()
            end
            love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
            love.graphics.printf((obj.cur_post + 1) .. " / " .. #obj.posts, obj.post_count.x, obj.post_count.y,
                obj.post_count.w, "center")
        end


        love.graphics.setColor(0, 0, 0, obj.tone_lerp)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.push()

        set_offset(obj.post_trans, 0)
        -- love.graphics.translate(obj.post_trans, 0)

        if obj.cur_post ~= 0 then obj.posts[obj.cur_post]:draw() end
        obj.posts[obj.cur_post + 1]:draw()
        if obj.cur_post ~= #obj.posts - 1 then obj.posts[obj.cur_post + 2]:draw() end

        love.graphics.pop()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
