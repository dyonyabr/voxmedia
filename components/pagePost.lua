PagePost = {}

function PagePost:new(page, i, x, y, pox, poy)
    local obj = {}

    obj.tone = 0

    obj.coords = {
        x = x + 700 * i,
        y = y,
        w = 660,
        h = 300
    }
    obj.hovered = true

    obj.min_content_w = obj.coords.h - 30
    obj.max_content_w = obj.coords.w - 30

    obj.content = {
        x = 15,
        y = 15,
        w = obj.min_content_w,
        h = obj.coords.h - 30,
        default_x = 15,
        default_y = 15,
        default_w = obj.min_content_w,
        default_h = obj.coords.h - 30,
        expanded_x = -15,
        expanded_y = -165,
        expanded_w = obj.coords.w + 30,
        expanded_h = 500,
        color = { r = love.math.random(0, 100) / 100, g = love.math.random(0, 100) / 100, b = love.math.random(0, 100) / 100, 1 },
        hovered = false,
        view_icon = icons.expand,
        vi_x = 0,
        vi_y = 0,
        vi_w = 30,
        vi_h = 30,
        vi_hovered = false,
        hover_a = 0,
        clicked = false
    }

    obj.content.vi_x = obj.coords.x + obj.content.w + obj.content.x - 40
    obj.content.vi_y = obj.coords.y + obj.content.y + 10


    obj.like = {
        clicked = false,
    }
    obj.like.ib = IconButton:new(icons.like, function()
            obj.like.clicked = not obj.like.clicked
        end, obj.content.default_x + 355, obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 10,
        false,
        pox, poy)

    obj.comment = {
        ib = IconButton:new(icons.message, function()
                print("comment pressed")
            end, obj.content.default_x + 475, obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 10,
            false,
            pox, poy),
    }

    obj.save = {
        clicked = false
    }
    obj.save.ib = IconButton:new(icons.saved, function()
            obj.save.clicked = not obj.save.clicked
        end, obj.content.default_x + 595, obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 12,
        false,
        pox, poy)

    function obj:load()
        obj.like.ib:load()
        obj.comment.ib:load()
        obj.save.ib:load()
    end

    function obj:update(dt)
        if is_mouse_hover(obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w, obj.content.h, pox, poy, page.post_trans)
            and obj.content.clicked == false then
            set_cursor("hand")
            obj.content.hovered = true
        else
            obj.content.hovered = false
        end

        local w = obj.min_content_w
        local content_a = 0

        local content_x = obj.content.default_x
        local content_y = obj.content.default_y
        local content_w = obj.content.default_w
        local content_h = obj.content.default_h

        obj.content.vi_x = obj.coords.x + obj.content.w + obj.content.x - 40
        obj.content.vi_y = obj.coords.y + obj.content.y + 10

        obj.content.vi_hovered = false
        obj.tone = 0
        if obj.content.clicked then
            if page.cur_post ~= i then obj.content.clicked = false end
            obj.tone = .75
            content_x = obj.content.expanded_x
            content_y = obj.content.expanded_y
            content_w = obj.content.expanded_w
            content_h = obj.content.expanded_h
            obj.content.view_icon = icons.close
            if is_mouse_hover(obj.content.vi_x, obj.content.vi_y, obj.content.vi_w, obj.content.vi_h, pox, poy, page.post_trans) then
                obj.content.vi_hovered = true
                set_cursor("hand")
            end
        else
            obj.like.ib:update(dt)
            obj.comment.ib:update(dt)
            obj.save.ib:update(dt)
            obj.content.view_icon = icons.expand
        end
        if obj.content.hovered or obj.content.clicked then content_a = .5 + (obj.content.vi_hovered and 1 or 0) * .5 end

        obj.content.hover_a = lerp(obj.content.hover_a, content_a, dt * 10)
        obj.content.x = lerp(obj.content.x, content_x, dt * 10)
        obj.content.y = lerp(obj.content.y, content_y, dt * 10)
        obj.content.w = lerp(obj.content.w, content_w, dt * 10)
        obj.content.h = lerp(obj.content.h, content_h, dt * 10)
    end

    function obj:mousepressed(x, y, button)
        obj.like.ib:mousepressed(x, y, button)
        obj.comment.ib:mousepressed(x, y, button)
        obj.save.ib:mousepressed(x, y, button)
        if obj.content.hovered then
            obj.content.clicked = true
        end

        if obj.content.vi_hovered then
            obj.content.clicked = false
        end
    end

    function obj:draw()
        -- love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
        -- box_shadow(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h, 40, { 0, 0, 0, .2 })

        local like_color = nil
        if obj.like.clicked then like_color = { r = colors.red.r, g = colors.red.g, b = colors.red.b, 1 } end
        obj.like.ib:draw(700 * i, 0, like_color)
        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        love.graphics.printf("120", fonts.WorkSans, 700 * i + 400,
            obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")

        obj.comment.ib:draw(700 * i, 0)
        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        love.graphics.printf("85", fonts.WorkSans, 700 * i + 520,
            obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")

        local save_color = nil
        if obj.save.clicked then save_color = { r = colors.yellow.r, g = colors.yellow.g, b = colors.yellow.b, 1 } end
        obj.save.ib:draw(700 * i, 0, save_color)
        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        love.graphics.printf("16", fonts.WorkSans, 700 * i + 640,
            obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
        love.graphics.printf(
            "Lorem ipsum", fonts.WorkSansBig,
            obj.coords.x + obj.content.default_x + obj.min_content_w + obj.content.default_x,
            obj.coords.y + obj.content.default_y,
            obj.coords.w - (obj.content.default_x + obj.min_content_w + obj.content.default_x + obj.content.default_x),
            "left")

        love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
        box_text(
            "Lorem ipsum odor amet, consectetuer adipiscing elit. Condimentum suspendisse adipiscing tellus malesuada faucibus sollicitudin porttitor auctor. Sapien netus nostra pharetra natoque class. Blandit morbi laoreet semper cursus quam ornare. Tempor sem lacus curae torquent felis; nam etiam. Placerat nibh phasellus nam; non montes dapibus.",
            obj.coords.x + obj.content.default_x + obj.min_content_w + obj.content.default_x,
            obj.coords.y + obj.content.default_y + 40,
            obj.coords.w - (obj.content.default_x + obj.min_content_w + obj.content.default_x + obj.content.default_x),
            obj.coords.h - obj.content.default_y - 20,
            fonts.WorkSans, "left")

        love.graphics.push()
        love.graphics.origin()

        box_shadow(obj.coords.x + obj.content.x + pox, obj.coords.y + obj.content.y + poy, obj.content.w,
            obj.content.h, 40, { 0, 0, 0, .35 })

        love.graphics.pop()

        love.graphics.stencil(function()
            love.graphics.rectangle("fill", obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w,
                obj.content.h, 10)
        end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

        love.graphics.setColor(obj.content.color.r, obj.content.color.g, obj.content.color.b, 1)
        love.graphics.rectangle("fill", obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w,
            obj.content.h)

        love.graphics.setColor(0, 0, 0, obj.content.hover_a * 0)
        love.graphics.rectangle("fill", obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w,
            obj.content.h)

        love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, obj.content.hover_a)
        love.graphics.rectangle("fill", obj.content.vi_x,
            obj.content.vi_y, obj.content.vi_w, obj.content.vi_h, 5)

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.content.hover_a * 2)
        drawLTWH(obj.content.view_icon, obj.content.vi_x + 5,
            obj.content.vi_y + 5, obj.content.vi_w - 10,
            obj.content.vi_h - 10,
            "horizontal")

        love.graphics.setStencilTest()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
