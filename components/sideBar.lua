require "components.sideBarOption"

SideBar = {}

function SideBar:new(main_page)
    local obj = {}

    obj.offset = { x = 0, y = 30 }
    obj.tone = 0

    obj.main_page = main_page

    obj.max_width = 200
    obj.min_width = 40
    obj.color = colors.main
    obj.coords = {
        x = 0,
        y = 0,
        w = obj.min_width,
        h = love.graphics.getHeight()
    }
    obj.hovered = false

    obj.options = {
        SideBarOption:new(obj, 0, icons.user, "My Profile", obj.main_page.my_profile),
        SideBarOption:new(obj, 1, icons.saved, "Saved", obj.main_page.saved),
        SideBarOption:new(obj, 2, icons.cube, "Dashboard", obj.main_page.dashboard),
    }

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
        local da = true
        if main_page.page == nil or main_page.page.posts == nil then
            da = true
        else
            if main_page.page.posts[main_page.page.cur_post + 1].content.clicked then
                da = false
            end
        end
        if is_mouse_hover(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h, obj.offset.x, obj.offset.y) and da then
            obj.hovered = true
        else
            obj.hovered = false
        end

        local tone = 0
        local w = obj.min_width
        if (obj.hovered) then
            w = obj.max_width; tone = 1
        end
        obj.coords.w = lerp(obj.coords.w, w, dt * 10)
        obj.tone = lerp(obj.tone, tone, dt * 10)

        for i = 1, #obj.options do
            obj.options[i]:update(dt)
        end
    end

    function obj:draw()
        love.graphics.origin()
        set_offset(obj.offset.x, obj.offset.y)

        box_shadow(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h, 40, { 0, 0, 0, .2 })

        love.graphics.setColor(0, 0, 0, obj.tone * .5)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y, love.graphics.getWidth() - obj.offset.x,
            love.graphics.getHeight() - obj.offset.y)

        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)


        for i = 1, #obj.options do
            -- love.graphics.setScissor(obj.coords.x, obj.coords.y, obj.coords.w, obj.coords.h)
            obj.options[i]:draw()
        end

        love.graphics.setScissor()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
