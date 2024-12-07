require "stuff.button"

SignIn = {}

function SignIn:new(parent)
  local obj = {}

  obj.parent = parent

  obj.to_sign_up = {
    x = love.graphics.getWidth() / 2 - 150,
    y = love.graphics.getHeight() / 2 + 160,
    w = 300,
    h = 30,
    color = { 0, 0, 0, 0 },
    hovered = false
  }

  obj.max_len = 20

  obj.login = {
    text = "",
    hovered = false,
    current = false,
    cursor = 0,
    to_cursor_width = 0,
    x = love.graphics.getWidth() / 2 - 150,
    y = love.graphics.getHeight() / 2 - 80,
    w = 300,
    h = 40,
  }
  obj.password = {
    text = "",
    hovered = false,
    current = false,
    cursor = 0,
    to_cursor_width = 0,
    x = love.graphics.getWidth() / 2 - 150,
    y = love.graphics.getHeight() / 2 - 20,
    w = 300,
    h = 40,
  }

  obj.sign_button = Button:new("", function()
    if obj.login.text ~= "" and obj.password.text ~= "" then
      local data = client:sign_in(obj.login.text, obj.password.text)
      if data and data[1] and data[1].id then
        set_signed(tonumber(data[1].id))
      else
        print("dada")
      end
    end
  end, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 + 80, 300, 40, 20, 0, 0, false)

  obj.shadow_color = { r = 0, g = 0, b = 0 }
  obj.shadow_color_hsv = { h = 0, s = .5, v = 1 }

  function obj:load()
  end

  function obj:keypressed(k)
    if obj.login.current then
      if k == "backspace" and obj.login.cursor >= 1 then
        local byteoffset = utf8.offset(obj.login.text, -1 - (#obj.login.text - obj.login.cursor))
        if byteoffset then
          obj.login.text = string.sub(obj.login.text, 1, byteoffset - 1) ..
              string.sub(obj.login.text, obj.login.cursor + 1, #obj.login.text)
        end
        obj.login.cursor = obj.login.cursor - 1

        obj.login.to_cursor_width = love.graphics.newText(fonts.WorkSans,
          string.sub(obj.login.text, 1, obj.login.cursor)):getWidth()
      elseif k == "delete" then
        obj.login.text = string.sub(obj.login.text, 1, obj.login.cursor) ..
            string.sub(obj.login.text, obj.login.cursor + 2, #obj.login.text)
      elseif k == "left" and obj.login.cursor > 0 then
        obj.login.cursor = obj.login.cursor - 1

        obj.login.to_cursor_width = love.graphics.newText(fonts.WorkSans,
          string.sub(obj.login.text, 1, obj.login.cursor)):getWidth()
      elseif k == "right" and obj.login.cursor < #obj.login.text then
        obj.login.cursor = obj.login.cursor + 1

        obj.login.to_cursor_width = love.graphics.newText(fonts.WorkSans,
          string.sub(obj.login.text, 1, obj.login.cursor)):getWidth()
      end
    elseif obj.password.current then
      if k == "backspace" and obj.password.cursor >= 1 then
        local byteoffset = utf8.offset(obj.password.text, -1 - (#obj.password.text - obj.password.cursor))
        if byteoffset then
          obj.password.text = string.sub(obj.password.text, 1, byteoffset - 1) ..
              string.sub(obj.password.text, obj.password.cursor + 1, #obj.password.text)
        end
        obj.password.cursor = obj.password.cursor - 1
      elseif k == "delete" then
        obj.password.text = string.sub(obj.password.text, 1, obj.password.cursor) ..
            string.sub(obj.password.text, obj.password.cursor + 2, #obj.password.text)
      elseif k == "left" and obj.password.cursor > 0 then
        obj.password.cursor = obj.password.cursor - 1
      elseif k == "right" and obj.password.cursor < #obj.password.text then
        obj.password.cursor = obj.password.cursor + 1
      end
    end
  end

  function obj:textinput(t)
    if obj.login.current and #obj.login.text < obj.max_len then
      obj.login.text = string.sub(obj.login.text, 1, obj.login.cursor) ..
          t .. (string.sub(obj.login.text, obj.login.cursor + 1, #obj.login.text))
      obj.login.cursor = obj.login.cursor + #t

      obj.login.to_cursor_width = love.graphics.newText(fonts.WorkSans,
        string.sub(obj.login.text, 1, obj.login.cursor)):getWidth()
    elseif obj.password.current and #obj.password.text < obj.max_len then
      obj.password.text = string.sub(obj.password.text, 1, obj.password.cursor) ..
          t .. (string.sub(obj.password.text, obj.password.cursor + 1, #obj.password.text))
      obj.password.cursor = obj.password.cursor + #t
      obj.password.to_cursor_width = love.graphics.newText(fonts.WorkSans,
        string.sub(obj.password.text, 1, obj.password.cursor)):getWidth()
    end
  end

  function obj:mousepressed(x, y, button)
    obj.sign_button:mousepressed(x, y, button)

    if obj.login.hovered then obj.login.current = true else obj.login.current = false end
    if obj.password.hovered then obj.password.current = true else obj.password.current = false end
    if obj.to_sign_up.hovered then
      obj.parent.current_num = 2;
      obj.parent.current = obj.parent.pages[obj.parent.current_num]
    end
  end

  function obj:wheelmoved(x, y, button)
  end

  function obj:mousereleased(x, y, button)
  end

  function obj:mousemoved(x, y, dx, dy)
  end

  function obj:update(dt)
    obj.sign_button:update(dt)

    obj.shadow_color_hsv.h = obj.shadow_color_hsv.h + .25 * dt
    if obj.shadow_color_hsv.h > 1 then obj.shadow_color_hsv.h = 0 end
    obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b = hsv2rgb(
      obj.shadow_color_hsv.h,
      obj.shadow_color_hsv.s, obj.shadow_color_hsv.v)

    obj.login.hovered = is_mouse_hover(obj.login.x, obj.login.y, obj.login.w, obj.login.h)
    obj.password.hovered = is_mouse_hover(obj.password.x, obj.password.y, obj.password.w, obj.password.h)
    obj.to_sign_up.hovered = is_mouse_hover(obj.to_sign_up.x, obj.to_sign_up.y, obj.to_sign_up.w, obj.to_sign_up.h)
    obj.to_sign_up.color = obj.to_sign_up.hovered and colors.main_text or colors.secondary_text

    if obj.login.hovered then set_cursor("hand") end
    if obj.password.hovered then set_cursor("hand") end
    if obj.to_sign_up.hovered then set_cursor("hand") end
  end

  function obj:draw(ox)
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Hello, sign in to continue :)", fonts.WorkSansBig, 0, 140, love.graphics.getWidth(),
      "center")

    box_shadow(ox + obj.login.x + 20, obj.login.y + 20, obj.login.w - 40, obj.login.h - 40, 40, { 0, 0, 0, .5 })
    box_shadow(ox + obj.password.x + 20, obj.password.y + 20, obj.password.w - 40, obj.password.h - 40, 40,
      { 0, 0, 0, .5 })
    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", obj.login.x, obj.login.y, obj.login.w, obj.login.h, 20)
    if obj.login.current then
      love.graphics.setColor(colors.bright.r, colors.bright.g, colors.bright.b, 1)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", obj.login.x, obj.login.y, obj.login.w, obj.login.h, 20)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.line(obj.login.x + obj.login.to_cursor_width + 16, obj.login.y + 10,
        obj.login.x + obj.login.to_cursor_width + 16, obj.login.h + obj.login.y - 10)
    end
    if obj.login.text == "" then
      if not obj.login.current then
        love.graphics.setColor(colors.bright.r + .1, colors.bright.g + .1, colors.bright.b + .1, 1)
        love.graphics.printf("Login", fonts.WorkSans, obj.login.x + 15, obj.login.y + 10,
          obj.login.w, "left")
      end
    else
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.printf(obj.login.text, fonts.WorkSans, obj.login.x + 15, obj.login.y + 10,
        obj.login.w, "left")
    end

    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", obj.password.x, obj.password.y, obj.password.w, obj.password.h, 20)
    if obj.password.current then
      love.graphics.setColor(colors.bright.r, colors.bright.g, colors.bright.b, 1)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", obj.password.x, obj.password.y, obj.password.w, obj.password.h, 20)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      local da = "***************************************"
      local w = love.graphics.newText(fonts.WorkSans, string.sub(da, 1, obj.password.cursor)):getWidth()
      love.graphics.line(obj.password.x + w + 16, obj.password.y + 10,
        obj.password.x + w + 16, obj.password.h + obj.password.y - 10)
    end
    if obj.password.text == "" then
      if not obj.password.current then
        love.graphics.setColor(colors.bright.r + .1, colors.bright.g + .1, colors.bright.b + .1, 1)
        love.graphics.printf("Password", fonts.WorkSans, obj.password.x + 15, obj.password.y + 10,
          obj.password.w, "left")
      end
    else
      local text = ""
      for i = 1, #obj.password.text do text = text .. "*" end
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.printf(text, fonts.WorkSans, obj.password.x + 15, obj.password.y + 10,
        obj.password.w, "left")
    end

    box_shadow(ox + obj.sign_button.coords.x + 20, obj.sign_button.coords.y + 20, obj.sign_button.coords.w - 40,
      obj.sign_button.coords.h - 40, 40,
      { obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, .5 })
    obj.sign_button:draw()
    love.graphics.setColor(obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, 1)
    love.graphics.printf("Sign in", fonts.WorkSans, obj.sign_button.coords.x, obj.sign_button.coords.y + 10,
      obj.sign_button.coords.w, "center")

    love.graphics.setColor(obj.to_sign_up.color.r, obj.to_sign_up.color.g, obj.to_sign_up.color.b)
    love.graphics.printf("First time here? Click here to sign up.", fonts.WorkSans,
      ox + obj.to_sign_up.x, obj.to_sign_up.y, obj.to_sign_up.w, "center")
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
