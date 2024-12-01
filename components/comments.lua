Comments = {}

local avatar = love.graphics.newImage("assets/images/test_avatar.png")

local function format_time(date, time)
  local fd, ft = date, time

  h = tostring(tonumber(string.sub(ft, 1, 2) + 3))
  m = string.sub(ft, 4, 5)
  ft = h .. ":" .. m

  local y = string.sub(fd, 1, 4)
  local d = string.sub(fd, 9, 10)
  local m = months[tonumber(string.sub(fd, 6, 7))]

  return d .. " " .. m .. ", " .. y .. "  " .. ft
end

function Comments:new(entities)
  local obj = {}

  obj.entities = entities

  obj.opened = false
  obj.hovered = true
  obj.alpha = 0

  obj.x, obj.y = 0, 0
  obj.sx, obj.sy, obj.w, obj.h = 0, 0, 0, 0
  obj.cur_x, obj.cur_y, obj.cur_w, obj.cur_h = 0, 0, 0, 0

  function obj:set_dimensions(x, y, sx, sy, w, h, pox, poy)
    obj.x, obj.y, obj.sx, obj.sy, obj.w, obj.h, obj.pox, obj.poy = x, y, sx + pox, sy + poy, w, h, pox, poy
    obj.cur_x, obj.cur_y, obj.cur_w, obj.cur_h = obj.x, obj.y, 0, 0
  end

  function obj:open()
    obj.opened = true
  end

  function obj:load()
  end

  function obj:keypressed(k)
  end

  function obj:mousepressed(x, y, button)
    if button == 1 and obj.hovered then obj.opened = not obj.opened end
  end

  function obj:wheelmoved(x, y, button)
  end

  function obj:mousereleased(x, y, button)
  end

  function obj:mousemoved(x, y, dx, dy)
  end

  function obj:update(dt)
    if is_mouse_hover(obj.cur_x, obj.cur_y, obj.cur_w, obj.cur_h, obj.pox, obj.poy) then
      set_cursor("hand")
      obj.hovered = true
    else
      obj.hovered = false
    end
    if obj.opened then
      obj.cur_x = lerp(obj.cur_x, obj.sx, dt * 10)
      obj.cur_y = lerp(obj.cur_y, obj.sy, dt * 10)
      obj.cur_w = lerp(obj.cur_w, obj.w, dt * 10)
      obj.cur_h = lerp(obj.cur_h, obj.h, dt * 10)
    else
      obj.cur_x = lerp(obj.cur_x, obj.x, dt * 10)
      obj.cur_y = lerp(obj.cur_y, obj.y, dt * 10)
      obj.cur_w = lerp(obj.cur_w, 0, dt * 10)
      obj.cur_h = lerp(obj.cur_h, 0, dt * 10)
    end
    obj.alpha = lerp(obj.alpha, obj.opened and 1 or 0, dt * 20)
  end

  function obj:draw()
    love.graphics.push()
    love.graphics.origin()
    love.graphics.translate(obj.pox, obj.poy)

    love.graphics.stencil(function()
      love.graphics.rectangle("fill", obj.cur_x, obj.cur_y, obj.cur_w, obj.cur_h, clamp(obj.cur_w - 20, 0, 10))
    end, "replace")
    love.graphics.setStencilTest("greater", 0)

    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", obj.cur_x, obj.cur_y, obj.cur_w, obj.cur_h)


    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.alpha)

    love.graphics.setFont(fonts.WorkSansBig)
    love.graphics.print("Comments", obj.cur_x + 20, obj.cur_y + 20)

    local iy = 0
    for i, com in ipairs(obj.entities) do
      local x, y = obj.cur_x + 80, obj.cur_y + 80 + iy

      love.graphics.stencil(function()
        love.graphics.circle("fill", x - 40, y + 20, 20)
      end, "replace", 2, true)
      love.graphics.setStencilTest("greater", 1)

      love.graphics.setColor(1, 1, 1, obj.alpha ^ 5)
      drawLTWH(avatar, x - 60, y, 40, 40, "horizontal")

      love.graphics.setStencilTest("greater", 0)

      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.alpha)
      local user_name_text_width = love.graphics.newText(fonts.WorkSansSemiBold, com.user_name):getWidth()
      love.graphics.printf(com.user_name, fonts.WorkSansSemiBold, x, y, obj.w - x + obj.cur_x,
        "left")

      love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, obj.alpha)
      local height = box_text(com.content, x, y + 30, obj.w - 160, 80 - y,
        fonts.WorkSans, "left")
      iy = iy + height + 70
      love.graphics.printf(format_time(com.upload_date, com.upload_time), fonts.WorkSans, x,
        y + height + 40,
        obj.w - x + obj.cur_x,
        "left", 0, .75, .75)
    end
    love.graphics.setStencilTest()

    love.graphics.pop()
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
