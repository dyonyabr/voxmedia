require "stuff.button"
require "stuff.IconButton"

SignUp = {}

function SignUp:new(parent)
  local obj = {}

  obj.dialog = {
    color = { r = 0, g = 0, b = 0, a = 0 },
    text = ""
  }

  local success = false

  obj.parent = parent

  obj.back = IconButton:new(icons.arrow_left, function()
    obj.parent.current_num = 1
    obj.parent.current = obj.parent.pages[obj.parent.current_num]
  end, love.graphics.getWidth() + 40, 70, 20, 12, true, -love.graphics.getWidth(), 0)

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

  obj.repeat_password = {
    text = "",
    hovered = false,
    current = false,
    cursor = 0,
    to_cursor_width = 0,
    x = love.graphics.getWidth() / 2 - 150,
    y = love.graphics.getHeight() / 2 + 40,
    w = 300,
    h = 40,
  }

  obj.sign_button = Button:new("", function()
      if obj.login.text ~= "" and obj.password.text ~= "" and obj.repeat_password.text ~= "" then
        if obj.password.text == obj.repeat_password.text then
          local err, col, code = client:create_new_user(obj.login.text, obj.password.text)
          if type(err) == "string" then
            obj.dialog.text = err
            obj.dialog.color = col
          end
          obj.success = code
        else
          obj.dialog.text = "Passwords are not matched!"
          obj.dialog.color = { r = colors.red.r, g = colors.red.g, b = colors.red.b, a = 1 }
        end
      else
        obj.dialog.text = "Some fields are empty!"
        obj.dialog.color = { r = colors.red.r, g = colors.red.g, b = colors.red.b, a = 1 }
      end
    end, love.graphics.getWidth() + love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 + 140, 300, 40, 20,
    -love.graphics.getWidth(), 0, false)

  obj.shadow_color = { r = 0, g = 0, b = 0 }
  obj.shadow_color_hsv = { h = 0, s = .5, v = 1 }

  function obj:load()
    obj.back:load()
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
    elseif obj.repeat_password.current then
      if k == "backspace" and obj.repeat_password.cursor >= 1 then
        local byteoffset = utf8.offset(obj.repeat_password.text,
          -1 - (#obj.repeat_password.text - obj.repeat_password.cursor))
        if byteoffset then
          obj.repeat_password.text = string.sub(obj.repeat_password.text, 1, byteoffset - 1) ..
              string.sub(obj.repeat_password.text, obj.repeat_password.cursor + 1, #obj.repeat_password.text)
        end
        obj.repeat_password.cursor = obj.repeat_password.cursor - 1
      elseif k == "delete" then
        obj.repeat_password.text = string.sub(obj.repeat_password.text, 1, obj.repeat_password.cursor) ..
            string.sub(obj.repeat_password.text, obj.repeat_password.cursor + 2, #obj.repeat_password.text)
      elseif k == "left" and obj.repeat_password.cursor > 0 then
        obj.repeat_password.cursor = obj.repeat_password.cursor - 1
      elseif k == "right" and obj.repeat_password.cursor < #obj.repeat_password.text then
        obj.repeat_password.cursor = obj.repeat_password.cursor + 1
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
    elseif obj.repeat_password.current and #obj.repeat_password.text < obj.max_len then
      obj.repeat_password.text = string.sub(obj.repeat_password.text, 1, obj.repeat_password.cursor) ..
          t .. (string.sub(obj.repeat_password.text, obj.repeat_password.cursor + 1, #obj.repeat_password.text))
      obj.repeat_password.cursor = obj.repeat_password.cursor + #t
    end
  end

  function obj:mousepressed(x, y, button)
    if not obj.success then
      obj.sign_button:mousepressed(x, y, button)
    end

    if obj.login.hovered then obj.login.current = true else obj.login.current = false end
    if obj.password.hovered then obj.password.current = true else obj.password.current = false end
    if obj.repeat_password.hovered then obj.repeat_password.current = true else obj.repeat_password.current = false end

    obj.back:mousepressed(x, y, button)
  end

  function obj:wheelmoved(x, y, button)
  end

  function obj:mousereleased(x, y, button)
  end

  function obj:mousemoved(x, y, dx, dy)
  end

  function obj:update(dt)
    if not obj.success then
      obj.sign_button:update(dt)
    end

    obj.shadow_color_hsv.h = obj.shadow_color_hsv.h + .25 * dt
    if obj.shadow_color_hsv.h > 1 then obj.shadow_color_hsv.h = 0 end
    obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b = hsv2rgb(
      obj.shadow_color_hsv.h,
      obj.shadow_color_hsv.s, obj.shadow_color_hsv.v)

    obj.login.hovered = is_mouse_hover(obj.login.x, obj.login.y, obj.login.w, obj.login.h)
    obj.password.hovered = is_mouse_hover(obj.password.x, obj.password.y, obj.password.w, obj.password.h)
    obj.repeat_password.hovered =
        is_mouse_hover(obj.repeat_password.x, obj.repeat_password.y, obj.repeat_password.w, obj.repeat_password.h)
    if obj.login.hovered then set_cursor("hand") end
    if obj.password.hovered then set_cursor("hand") end
    if obj.repeat_password.hovered then set_cursor("hand") end

    obj.back:update(dt)
  end

  function obj:draw(ox)
    local fox = love.graphics.getWidth()
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Welcome! Start your journey here.", fonts.WorkSansBig, fox, 140,
      love.graphics.getWidth(),
      "center")

    box_shadow(fox + ox + obj.login.x + 20, obj.login.y + 20, obj.login.w - 40, obj.login.h - 40, 40, { 0, 0, 0, .5 }, ox,
      0)
    box_shadow(fox + ox + obj.password.x + 20, obj.password.y + 20, obj.password.w - 40, obj.password.h - 40, 40,
      { 0, 0, 0, .5 }, ox, 0)
    box_shadow(fox + ox + obj.repeat_password.x + 20, obj.repeat_password.y + 20, obj.repeat_password.w - 40,
      obj.repeat_password.h - 40, 40, { 0, 0, 0, .5 }, ox, 0)
    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", fox + obj.login.x, obj.login.y, obj.login.w, obj.login.h, 20)
    if obj.login.current then
      love.graphics.setColor(colors.bright.r, colors.bright.g, colors.bright.b, 1)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", fox + obj.login.x, obj.login.y, obj.login.w, obj.login.h, 20)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.line(fox + obj.login.x + obj.login.to_cursor_width + 16, obj.login.y + 10,
        fox + obj.login.x + obj.login.to_cursor_width + 16, obj.login.h + obj.login.y - 10)
    end
    if obj.login.text == "" then
      if not obj.login.current then
        love.graphics.setColor(colors.bright.r + .1, colors.bright.g + .1, colors.bright.b + .1, 1)
        love.graphics.printf("Login", fonts.WorkSans, fox + obj.login.x + 15, obj.login.y + 10,
          obj.login.w, "left")
      end
    else
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.printf(obj.login.text, fonts.WorkSans, fox + obj.login.x + 15, obj.login.y + 10,
        obj.login.w, "left")
    end

    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", fox + obj.password.x, obj.password.y, obj.password.w, obj.password.h, 20)
    if obj.password.current then
      love.graphics.setColor(colors.bright.r, colors.bright.g, colors.bright.b, 1)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", fox + obj.password.x, obj.password.y, obj.password.w, obj.password.h, 20)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      local da = "***************************************"
      local w = love.graphics.newText(fonts.WorkSans, string.sub(da, 1, obj.password.cursor)):getWidth()
      love.graphics.line(fox + obj.password.x + w + 16, obj.password.y + 10,
        fox + obj.password.x + w + 16, obj.password.h + obj.password.y - 10)
    end
    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
    love.graphics.rectangle("fill", fox + obj.repeat_password.x, obj.repeat_password.y, obj.repeat_password.w,
      obj.repeat_password.h, 20)
    if obj.repeat_password.current then
      love.graphics.setColor(colors.bright.r, colors.bright.g, colors.bright.b, 1)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", fox + obj.repeat_password.x, obj.repeat_password.y, obj.repeat_password.w,
        obj.repeat_password.h, 20)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      local da = "***************************************"
      local w = love.graphics.newText(fonts.WorkSans, string.sub(da, 1, obj.repeat_password.cursor)):getWidth()
      love.graphics.line(fox + obj.repeat_password.x + w + 16,
        obj.repeat_password.y + 10,
        fox + obj.repeat_password.x + w + 16,
        obj.repeat_password.h + obj.repeat_password.y - 10)
    end
    if obj.password.text == "" then
      if not obj.password.current then
        love.graphics.setColor(colors.bright.r + .1, colors.bright.g + .1, colors.bright.b + .1, 1)
        love.graphics.printf("Password", fonts.WorkSans, fox + obj.password.x + 15, obj.password.y + 10,
          obj.password.w, "left")
      end
    else
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      local text = ""
      for i = 1, #obj.password.text do text = text .. "*" end
      love.graphics.printf(text, fonts.WorkSans, fox + obj.password.x + 15, obj.password.y + 10,
        obj.password.w, "left")
    end
    if obj.repeat_password.text == "" then
      if not obj.repeat_password.current then
        love.graphics.setColor(colors.bright.r + .1, colors.bright.g + .1, colors.bright.b + .1, 1)
        love.graphics.printf("Repeat password", fonts.WorkSans, fox + obj.repeat_password.x + 15,
          obj.repeat_password.y + 10,
          obj.repeat_password.w, "left")
      end
    else
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      local text = ""
      for i = 1, #obj.repeat_password.text do text = text .. "*" end
      love.graphics.printf(text, fonts.WorkSans, fox + obj.repeat_password.x + 15,
        obj.repeat_password.y + 10,
        obj.repeat_password.w, "left")
    end

    love.graphics.setColor(obj.dialog.color.r, obj.dialog.color.g, obj.dialog.color.b, obj.dialog.color.a)
    love.graphics.printf(obj.dialog.text, fonts.WorkSans, fox, love.graphics.getHeight() / 2 + 100,
      love.graphics.getWidth(), "center")

    if not obj.success then
      box_shadow(ox + obj.sign_button.coords.x + 20, obj.sign_button.coords.y + 20, obj.sign_button.coords.w - 40,
        obj.sign_button.coords.h - 40, 40,
        { obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, .5 }, ox, 0)
      obj.sign_button:draw()
      love.graphics.setColor(obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, 1)
      love.graphics.printf("Sign up", fonts.WorkSans, obj.sign_button.coords.x, obj.sign_button.coords.y + 10,
        obj.sign_button.coords.w, "center")
      obj.sign_button:draw()
      love.graphics.setColor(obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, 1)
      love.graphics.printf("Sign up", fonts.WorkSans, obj.sign_button.coords.x, obj.sign_button.coords.y + 10,
        obj.sign_button.coords.w, "center")
    end

    if obj.success then
      box_shadow(ox + obj.back.coords.x, obj.back.coords.y, 0, 0, obj.back.coords.r + 10,
        { obj.shadow_color.r, obj.shadow_color.g, obj.shadow_color.b, 1 }, ox, 0)
      love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, 1)
      love.graphics.circle("fill", obj.back.coords.x, obj.back.coords.y, obj.back.coords.r)
    end

    obj.back:draw()
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
