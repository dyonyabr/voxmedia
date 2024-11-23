IconButton = {}

function IconButton:new(icon_image, click_func, x, y, r, padding, hollow, ox, oy, draw_shadow)
  local obj = {}

  obj.icon = {
    image = icon_image,
    padding = padding
  }

  obj.click_effect = ClickEffect:new()

  obj.color = { r = colors.button_hover.r, g = colors.button_hover.g, b = colors.button_hover.b, a = 0 }
  obj.coords = {
    x = x + offset.x,
    y = y + offset.y,
    r = r
  }
  obj.hovered = false
  obj.draw_shadow = draw_shadow

  function obj:load()
  end

  function obj:update(dt)
    if is_mouse_hover_circle(obj.coords.x, obj.coords.y, obj.coords.r, ox, oy) then
      obj.hovered = true
      set_cursor("hand")
    else
      obj.hovered = false
    end

    local a
    if hollow then a = 0 else a = .5 end
    if obj.hovered then
      a = 1
    end
    obj.color.a = lerp(obj.color.a, a, dt * 20)

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

  function obj:draw(ox, oy, icon_color)
    if ox == nil then ox = 0 end
    if oy == nil then oy = 0 end
    if icon_color == nil then
      icon_color = { r = colors.main_text.r, g = colors.main_text.g, b = colors.main_text.b, 1 }
    end

    love.graphics.push()
    love.graphics.translate(ox, oy)

    if draw_shadow then
      circle_shadow(obj.coords.x + ox, obj.coords.y + ox, obj.coords.r, 20, { 0, 0, 0, .15 })
    end

    love.graphics.stencil(function()
      love.graphics.circle("fill", obj.coords.x, obj.coords.y, obj.coords.r)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b, obj.color.a)
    love.graphics.circle("fill", obj.coords.x, obj.coords.y, obj.coords.r)

    obj.click_effect:draw()

    love.graphics.setColor(icon_color.r, icon_color.g, icon_color.b, 1)
    drawLTWH(obj.icon.image, obj.coords.x - obj.coords.r + padding, obj.coords.y - obj.coords.r + padding,
      obj.coords.r * 2 - padding * 2,
      obj.coords.r * 2 - padding * 2, "horizontal")

    love.graphics.setStencilTest()
    love.graphics.pop()
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
