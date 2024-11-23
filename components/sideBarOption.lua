SideBarOption = {}

function SideBarOption:new(side_bar, i, icon_image, label, page)
    local obj = {}

    obj.label = label
    obj.side_bar = side_bar
    obj.i = i
    obj.page = page

    obj.click_effect = ClickEffect:new()

    obj.selected_color = { r = colors.button_pressed.r, g = colors.button_pressed.g, b = colors.button_pressed.b, a = 1 }
    obj.non_selected_color = { r = colors.button_hover.r, g = colors.button_hover.g, b = colors.button_hover.b, a = 1 }
    obj.color = { r = obj.non_selected_color.r, g = obj.non_selected_color.g, b = obj.non_selected_color.b, a = 1 }
    obj.coords = {
        x = obj.side_bar.coords.x,
        y = obj.side_bar.coords.y,
        w = obj.side_bar.max_width,
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
        color = { r = colors.main_text.r, g = colors.main_text.g, b = colors.main_text.b, a = 1 },
        image = icon_image,
    }
    function obj:load()
    end

    function obj:update(dt)
        if is_mouse_hover(obj.coords.x + 1, obj.coords.y + obj.coords.h * obj.i + 1, side_bar.coords.w - 2, obj.coords.h - 2, obj.side_bar.offset.x, obj.side_bar.offset.y) then
            obj.hovered = true
            set_cursor("hand")
        else
            obj.hovered = false
        end

        local a = 0
        if (obj.hovered or obj.side_bar.main_page.page == obj.page) then
            a = 1
        end
        obj.color.a = lerp(obj.color.a, a, dt * 20)

        obj.click_effect:update(dt)
    end

    function obj:mousepressed(x, y, button)
        if obj.hovered then
            if button == 1 then
                obj.do_click(x, y)
            end
        end
    end

    function obj.do_click(x, y)
        if obj.side_bar.main_page.page ~= obj.page then
            obj.side_bar.main_page:setPage(obj.page)
            obj.click_effect:do_click(x - obj.side_bar.offset.x, y - obj.side_bar.offset.y)
        end
    end

    function obj:draw()
        love.graphics.setScissor(obj.coords.x + obj.side_bar.offset.x,
            obj.coords.y + obj.coords.h * obj.i + obj.side_bar.offset.y, clamp(obj.side_bar.coords.w, 0, 999),
            clamp(obj.coords.h, 0, 999))
        love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
        love.graphics.rectangle("fill", obj.coords.x, obj.coords.y + obj.coords.h * obj.i, obj.coords.w, obj.coords.h)

        obj.click_effect:draw()

        love.graphics.setColor(obj.icon.color.r, obj.icon.color.g, obj.icon.color.b, obj.icon.color.a)
        drawLTWH(obj.icon.image, obj.icon.coords.x + obj.icon.padding,
            (obj.icon.coords.y + obj.icon.padding) + obj.coords.h * obj.i + obj.coords.y,
            obj.icon.coords.w - obj.icon.padding * 2,
            obj.icon.coords.h - obj.icon.padding * 2, "horizontal")

        love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, colors.main_text.a)
        love.graphics.printf(obj.label, fonts.WorkSans, obj.icon.coords.w + 5,
            obj.coords.h * obj.i + obj.coords.y + 10,
            love.graphics.getWidth(),
            "left")
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
