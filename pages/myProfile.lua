require "components.pagePost"
MyProfile = {}

function MyProfile:new()
  local obj = {}

  obj.offset = { x = 40, y = 30 }
  obj.can_swipe = true
  obj.swap_timer = Timer()

  obj.click_effect = ClickEffect:new()

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

  obj.new_post = {
    x = obj.post_offset.x + 105,
    y = obj.post_offset.y - 55,
    w = 40,
    h = 40,
    shadow_color = { r = 0, g = 0, b = 0 },
    shadow_color_hsv = { h = 0, s = .5, v = 1 },
    func = function()
      open_editor()
    end,
    base_color = { r = colors.main.r, g = colors.main.g, b = colors.main.b },
    hover_color = { r = colors.main.r, g = colors.main.g, b = colors.main.b },
    color = { r = colors.button.r, g = colors.button.g, b = colors.button.b },
    hovered = false
  }

  obj.posts = {}
  local user = client:get_user(1)
  local cl_posts
  if user then
    cl_posts = user.posts
    for i = 0, #cl_posts - 1 do
      obj.posts[i + 1] = PagePost:new(
        cl_posts[i + 1].description,
        cl_posts[i + 1].likes,
        cl_posts[i + 1].comments,
        obj, i, obj.post_offset.x, obj.post_offset.y,
        obj.offset.x,
        obj.offset.y)
    end
  end

  obj.cur_post = 0
  function obj:set_cur_post(value)
    obj.cur_post =
        clamp(value, 0, #obj.posts - 1)
  end

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
    -- if not obj.posts[obj.cur_post + 1].content.clicked then
    --   if k == "left" then
    --     obj:set_cur_post(obj.cur_post - 1)
    --   elseif k == "right" then
    --     obj:set_cur_post(obj.cur_post + 1)
    --   end
    -- end
  end

  function obj:mousepressed(x, y, button)
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:mousepressed(x, y, button)
    end
    obj.post_left:mousepressed(x, y, button)
    obj.post_right:mousepressed(x, y, button)
    if obj.new_post.hovered and button == 1 then
      obj.click_effect:do_click(x - obj.offset.x, y - obj.offset.y)
      open_editor()
    end
  end

  function obj:wheelmoved(x, y)
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:wheelmoved(x, y)
    end
  end

  function obj:mousereleased(x, y, button)
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:mousereleased(x, y, button)
    end
  end

  function obj:mousemoved(x, y, dx, dy)
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:mousemoved(x, y, dx, dy)
    end
  end

  function obj:update(dt)
    obj.swap_timer:update(dt)

    if obj.cur_post ~= 0 then obj.posts[obj.cur_post]:update(dt) end
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:update(dt)
      if obj.cur_post ~= #obj.posts - 1 then obj.posts[obj.cur_post + 2]:update(dt) end

      if not obj.posts[obj.cur_post + 1].content.clicked and not obj.posts[obj.cur_post + 1].comments_field.opened then
        if is_mouse_hover_circle(obj.avatar.x, obj.avatar.y, obj.avatar.radius, obj.offset.x, obj.offset.y) then
          set_cursor("hand")
          obj.avatar.hovered = true
        else
          obj.avatar.hovered = false
        end
      end

      local npr, npg, npb, w = obj.new_post.base_color.r, obj.new_post.base_color.g, obj.new_post.base_color.b, 40
      obj.new_post.hovered = false
      if is_mouse_hover(obj.new_post.x, obj.new_post.y, obj.new_post.w, obj.new_post.h, obj.offset.x, obj.offset.y) then
        set_cursor("hand")
        obj.new_post.hovered = true
        npr, npg, npb, w = obj.new_post.hover_color.r, obj.new_post.hover_color.g,
            obj.new_post.hover_color.b, 200
      end

      obj.new_post.color.r = lerp(
        obj.new_post.color.r, npr, dt * 20)
      obj.new_post.color.b = lerp(
        obj.new_post.color.g, npg, dt * 20)
      obj.new_post.color.b = lerp(
        obj.new_post.color.b, npb, dt * 20)
      obj.new_post.w = lerp(obj.new_post.w,
        w, dt * 10)

      obj.new_post.shadow_color_hsv.h = obj.new_post.shadow_color_hsv.h + .25 * dt
      if obj.new_post.shadow_color_hsv.h > 1 then obj.new_post.shadow_color_hsv.h = 0 end
      obj.new_post.shadow_color.r, obj.new_post.shadow_color.g, obj.new_post.shadow_color.b = hsv2rgb(
        obj.new_post.shadow_color_hsv.h,
        obj.new_post.shadow_color_hsv.s, obj.new_post.shadow_color_hsv.v)

      obj.click_effect:update(dt)

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
    if #obj.posts > 0 then
      obj.tone_lerp = lerp(obj.tone_lerp, obj.posts[obj.cur_post + 1].tone, dt * 10)
    else
      obj.tone_lerp = lerp(obj.tone_lerp, 0, dt * 10)
    end
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

    box_shadow(obj.new_post.x + 20, obj.new_post.y + 20, obj.new_post.w - 40, obj.new_post.h - 40, 35,
      { obj.new_post.shadow_color.r, obj.new_post.shadow_color.g, obj.new_post.shadow_color.b, .75 })

    love.graphics.stencil(function()
      love.graphics.rectangle("fill", obj.new_post.x, obj.new_post.y, obj.new_post.w, obj.new_post.h, 20)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    local main_color, add_color
    add_color = { obj.new_post.color.r, obj.new_post.color.g, obj.new_post.color.b }
    if not obj.new_post.hovered then
      main_color = { colors.main_text.r, colors.main_text.g, colors.main_text.b }
      add_color = { obj.new_post.color.r, obj.new_post.color.g, obj.new_post.color.b }
    else
      main_color = { obj.new_post.shadow_color.r, obj.new_post.shadow_color.g, obj.new_post.shadow_color.b }
      local h, s, v = rgb2hsv(obj.new_post.shadow_color.r, obj.new_post.shadow_color.g,
        obj.new_post.shadow_color.b)
      local r, g, b = hsv2rgb(h, s - .35, v - .9)
      add_color = { r, g, b }
    end
    love.graphics.setColor(add_color)
    love.graphics.rectangle("fill", obj.new_post.x, obj.new_post.y, obj.new_post.w, obj.new_post.h, 20)
    obj.click_effect:draw()
    love.graphics.setColor(main_color)
    drawLTWH(icons.new, obj.new_post.x + 10, obj.new_post.y + 10, 20, 20, "horizontal")
    -- love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b)
    love.graphics.printf("Create New Post", fonts.WorkSans, obj.new_post.x + 50, obj.new_post.y + 10, 170, "left")
    love.graphics.setStencilTest()

    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("User Nickname", fonts.WorkSansBig, obj.cap.x, obj.avatar.y + 10,
      obj.avatar.x - obj.avatar.radius - 15, "right")

    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Posts", fonts.WorkSansBig, obj.post_offset.x + 15, obj.post_offset.y - 50,
      love.graphics.getWidth(), "left")

    if #obj.posts > 0 and not obj.posts[obj.cur_post + 1].content.clicked then
      if obj.cur_post ~= 0 then
        obj.post_left:draw()
      end
      if obj.cur_post ~= #obj.posts - 1 then
        obj.post_right:draw()
      end
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.printf((obj.cur_post + 1) .. " / " .. #obj.posts, fonts.WorkSans, obj.post_count.x, obj.post_count.y,
        obj.post_count.w, "center")
    end


    love.graphics.setColor(0, 0, 0, obj.tone_lerp)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.push()

    set_offset(obj.post_trans, 0)
    if obj.cur_post ~= 0 and not obj.posts[obj.cur_post + 1].content.clicked then obj.posts[obj.cur_post]:draw() end
    if #obj.posts > 0 then
      obj.posts[obj.cur_post + 1]:draw()
      if obj.cur_post ~= #obj.posts - 1 and not obj.posts[obj.cur_post + 1].content.clicked then
        obj.posts[obj.cur_post + 2]:draw()
      end
    end

    love.graphics.pop()

    if #obj.posts == 0 then
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
      love.graphics.printf("There are no posts yet.", fonts.WorkSans, offset.x, offset.y + 300,
        love.graphics.getWidth() - offset.x, "center")
    end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
