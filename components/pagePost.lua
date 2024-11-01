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
        canvas = dream:newCanvases(),
        camera = dream:newCamera(),
        model = dream:loadObject("assets/objects/cube"),
        pos_grabbed = false,
        rot_grabbed = false,
        lerp_posx = 0,
        lerp_posy = 0,
        lerp_posz = 0,
        lerp_rotx = math.rad(35),
        lerp_roty = math.pi / 4,
        lerp_rotz = 0,
        lerp_zoom = 6,
        light = dream:newLight("sun"),
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

        obj.content.camera:setFov(54)
        obj.content.camera:translate(0, 0, 10)
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
            obj.content.posx, obj.content.posy, obj.content.posz = 0, 0, 0
            obj.content.rotx, obj.content.roty, obj.content.rotz = math.rad(35), math.pi / 4, 0
            obj.content.zoom = 6
            obj.like.ib:update(dt)
            obj.comment.ib:update(dt)
            obj.save.ib:update(dt)
            obj.content.view_icon = icons.expand
        end
        if obj.content.hovered or obj.content.clicked then content_a = .5 + (obj.content.vi_hovered and 1 or 0) * .5 end
        if obj.content.hovered and not obj.content.clicked then
            obj.content.zoom = obj.content.zoom - 1
        end

        if obj.content.rot_grabbed then set_cursor("sizeall") end

        obj.content.hover_a = lerp(obj.content.hover_a, content_a, dt * 10)
        obj.content.x = lerp(obj.content.x, content_x, dt * 10)
        obj.content.y = lerp(obj.content.y, content_y, dt * 10)
        obj.content.w = lerp(obj.content.w, content_w, dt * 10)
        obj.content.h = lerp(obj.content.h, content_h, dt * 10)
        obj.content.lerp_posx = lerp(obj.content.lerp_posx, obj.content.posx, dt * 10)
        obj.content.lerp_posy = lerp(obj.content.lerp_posy, obj.content.posy, dt * 10)
        obj.content.lerp_posz = lerp(obj.content.lerp_posz, obj.content.posz, dt * 10)
        obj.content.lerp_rotx = lerp_angle(obj.content.lerp_rotx, obj.content.rotx, dt * 10)
        obj.content.lerp_roty = lerp_angle(obj.content.lerp_roty, obj.content.roty, dt * 10)
        obj.content.lerp_rotz = lerp_angle(obj.content.lerp_rotz, obj.content.rotz, dt * 10)
        obj.content.lerp_zoom = lerp(obj.content.lerp_zoom, obj.content.zoom, dt * 10)

        obj.content.camera:resetTransform()
        obj.content.camera:setTransform(dream:lookAt(dream.vec3(obj.content.lerp_posx, obj.content.lerp_posy,
            obj.content.lerp_zoom), dream.vec3(0, 0, 0)):invert())
        obj.content.camera:setSize(obj.content.lerp_zoom)

        obj.content.model:resetTransform()
        obj.content.model:rotateX(obj.content.lerp_rotx)
        obj.content.model:rotateY(obj.content.lerp_roty)
        obj.content.model:rotateZ(obj.content.lerp_rotz)
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

        if obj.content.clicked and button == 1 and not obj.content.pos_grabbed then
            obj.content.rot_grabbed = true
        end
    end

    function obj:wheelmoved(x, y)
        if obj.content.clicked then
            obj.content.zoom = obj.content.zoom - y * .5
        end
    end

    function obj:mousereleased(x, y, button)
        if button == 1 then
            obj.content.rot_grabbed = false
        end
    end

    function obj:mousemoved(x, y, dx, dy)
        if obj.content.rot_grabbed then
            obj.content.roty = obj.content.roty - dx * .005
            obj.content.rotx = obj.content.rotx + dy * .005
        end
    end

    function obj:draw()
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

        love.graphics.push()
        love.graphics.translate(obj.coords.x + obj.content.x - 10, obj.coords.y + obj.content.y - 10)
        obj.content.canvas:init(obj.content.w + 20, obj.content.h + 20)

        dream:prepare()

        dream:addLight(obj.content.light)

        dream:draw(obj.content.model)

        dream:present(obj.content.camera, obj.content.canvas)

        love.graphics.pop()

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
