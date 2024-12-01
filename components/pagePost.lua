require "components.comments"

PagePost = {}

cube_verts = {
  { -.5, .5,  .5 }, { .5, .5, .5 }, { .5, -.5, .5 }, { -.5, -.5, .5 }, { -.5, -.5, .5 }, { 1, 1, 1 },
  { -.5, -.5, -.5 }, { .5, -.5, -.5 }, { .5, .5, -.5 }, { -.5, .5, -.5 }, { -.5, -.5, -.5 }, { .4, .4, .4 },
  { .5,  -.5, -.5 }, { .5, -.5, .5 }, { .5, .5, .5 }, { .5, .5, -.5 }, { .5, -.5, -.5 }, { .8, .8, .8 },
  { -.5, .5,  -.5 }, { -.5, .5, .5 }, { -.5, -.5, .5 }, { -.5, -.5, -.5 }, { -.5, -.5, -.5 }, { .8, .8, .8 },
  { .5,  .5,  -.5 }, { .5, .5, .5 }, { -.5, .5, .5 }, { -.5, .5, -.5 }, { -.5, .5, .5 }, { .6, .6, .6 },
  { -.5, -.5, -.5 }, { -.5, -.5, .5 }, { .5, -.5, .5 }, { .5, -.5, -.5 }, { -.5, -.5, .5 }, { .6, .6, .6 },
}

function make_cube(verts, c)
  for i = 0, 5 do
    local normal = cube_verts[i * 6 + 5]
    local uvx, uvy = (c - 1) % 16 + 1, math.floor((c - 1) / 16 + 1)

    local pos = { {}, {} }
    local uv = { {}, {} }
    local color = { {}, {} }
    for j = 1, 3 do
      local col = cube_verts[i * 6 + 6]

      pos[1][1] = cube_verts[i * 6 + 1]
      pos[1][2] = cube_verts[i * 6 + 2]
      pos[1][3] = cube_verts[i * 6 + 3]
      uv[1][1] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      uv[1][2] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      uv[1][3] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      color[2][1] = { col[1] - .1, col[2] - .1, col[2] - .1, 1 }
      color[2][2] = { col[1] - .1, col[2] - .1, col[2] - .1, 1 }
      color[2][3] = { col[1] - .1, col[2] - .1, col[2] - .1, 1 }
      pos[2][1] = cube_verts[i * 6 + 1]
      pos[2][2] = cube_verts[i * 6 + 3]
      pos[2][3] = cube_verts[i * 6 + 4]
      uv[2][1] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      uv[2][2] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      uv[2][3] = { ((uvx - 1) * 8) / 128, ((uvy - 1) * 8) / 128 }
      color[1][1] = { col[1], col[2], col[2], 1 }
      color[1][2] = { col[1], col[2], col[2], 1 }
      color[1][3] = { col[1], col[2], col[2], 1 }
    end

    for t = 1, 2 do
      for v = 1, 3 do
        verts[#verts + 1] = { pos[t][v][1], pos[t][v][2], pos[t][v][3],
          uv[t][v][1], uv[t][v][2],
          normal[1], normal[2], normal[3],
          color[t][v][1], color[t][v][2], color[t][v][3], color[t][v][4] }
      end
    end
  end
end

function PagePost:new(description, likes, comments, page, i, x, y, pox, poy)
  local obj = {}
  obj.tone = 0
  obj.coords = {
    x = x + 700 * i,
    y = y,
    w = 660,
    h = 300
  }


  obj.description = description
  obj.likes = likes
  obj.comments = comments

  obj.comments_field = Comments:new(comments)

  obj.hovered = true
  obj.min_content_w = obj.coords.h - 30
  obj.max_content_w = obj.coords.w - 30
  obj.content = {
    is_ortho = false,
    canvas = love.graphics.newCanvas(1000, 1000),
    v = {},
    pos_grabbed = false,
    rot_grabbed = false,
    lerp_rotx = math.rad(-35),
    lerp_roty = 0,
    lerp_rotz = math.pi / 4,
    lerp_zoom = 6,
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
    ortho_icon = icons.ortho,
    oi_x = 0,
    oi_y = 0,
    oi_w = 30,
    oi_h = 30,
    oi_hovered = false,
    hover_oa = 0,
    clicked = false
  }
  obj.content.color = {}
  obj.content.color.r, obj.content.color.g, obj.content.color.b = hsv2rgb(love.math.random(0, 100) / 100, 0.5, 1)
  obj.content.vi_x = obj.coords.x + obj.content.w + obj.content.x - 40
  obj.content.vi_y = obj.coords.y + obj.content.y + 10
  obj.content.oi_x = obj.content.vi_x - 40
  obj.content.oi_y = obj.content.vi_y
  obj.like = { clicked = false }
  obj.like.ib = IconButton:new(icons.like, function() obj.like.clicked = not obj.like.clicked end,
    obj.content.default_x + 355, obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 10, false, pox,
    poy)
  obj.comment = {
    ib = IconButton:new(icons.message, function() obj.comments_field:open() end, obj.content.default_x + 475,
      obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 10, false, pox, poy)
  }
  obj.save = { clicked = false }
  obj.save.ib = IconButton:new(icons.saved, function() obj.save.clicked = not obj.save.clicked end,
    obj.content.default_x + 595, obj.content.default_h + obj.content.default_y + obj.coords.y - 20, 20, 12, false, pox,
    poy)

  function obj:load()
    make_cube(obj.content.v, 2)
    obj.content.model = g3d.newModel(obj.content.v, "editor3d/assets/textures/default_atlas.png")
    obj.like.ib:load()
    obj.comment.ib:load()
    obj.save.ib:load()

    obj.comments_field:set_dimensions(obj.content.default_x + 475,
      obj.content.default_h + obj.content.default_y + obj.coords.y - 20,
      0, 5, obj.content.expanded_w, obj.content.expanded_h, pox, poy)
  end

  function obj:update(dt)
    if not obj.content.clicked then
      obj.comments_field:update(dt)
    end
    if not obj.comments_field.opened then
      if is_mouse_hover(obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w, obj.content.h, pox, poy, page.post_trans) and obj.content.clicked == false then
        set_cursor("hand")
        obj.content.hovered = true
      else
        obj.content.hovered = false
      end
    end
    local w = obj.min_content_w
    local content_a = 0
    local content_oa = 0
    local content_x = obj.content.default_x
    local content_y = obj.content.default_y
    local content_w = obj.content.default_w
    local content_h = obj.content.default_h
    obj.content.vi_x = obj.coords.x + obj.content.w + obj.content.x - 40
    obj.content.vi_y = obj.coords.y + obj.content.y + 10
    obj.content.oi_x = obj.content.vi_x - 40
    obj.content.oi_y = obj.content.vi_y
    obj.content.vi_hovered = false
    obj.content.oi_hovered = false
    if obj.content.is_ortho then obj.content.ortho_icon = icons.proj else obj.content.ortho_icon = icons.ortho end
    obj.tone = 0
    if is_mouse_hover(obj.content.oi_x, obj.content.oi_y, obj.content.oi_w, obj.content.oi_h, pox, poy, page.post_trans) and not obj.comments_field.opened and obj.content.clicked then
      obj.content.oi_hovered = true
      set_cursor("hand")
    end
    if obj.comments_field.opened then
      obj.tone = 0.75
    end
    if obj.content.clicked then
      if page.cur_post ~= i then obj.content.clicked = false end
      obj.tone = 0.75
      content_x = obj.content.expanded_x
      content_y = obj.content.expanded_y
      content_w = obj.content.expanded_w
      content_h = obj.content.expanded_h
      obj.content.view_icon = icons.close
      if is_mouse_hover(obj.content.vi_x, obj.content.vi_y, obj.content.vi_w, obj.content.vi_h, pox, poy, page.post_trans) and not obj.comments_field.opened then
        obj.content.vi_hovered = true
        set_cursor("hand")
      end
    else
      obj.content.posx, obj.content.posy, obj.content.posz = 0, 0, 0
      obj.content.rotx, obj.content.roty, obj.content.rotz = math.rad(-35), 0, math.pi / 4
      obj.content.zoom = 6
      obj.like.ib:update(dt)
      obj.comment.ib:update(dt)
      obj.save.ib:update(dt)
      obj.content.view_icon = icons.expand
    end
    if obj.content.hovered or obj.content.clicked then
      content_a = 0.5 + (obj.content.vi_hovered and 1 or 0) * 0.5
      content_oa = 0.5 + (obj.content.oi_hovered and 1 or 0) * 0.5
    end
    if obj.content.hovered and not obj.content.clicked then obj.content.zoom = obj.content.zoom - 1 end
    if obj.content.rot_grabbed then set_cursor("sizeall") end
    obj.content.hover_a = lerp(obj.content.hover_a, content_a, dt * 10)
    obj.content.hover_oa = lerp(obj.content.hover_oa, content_oa, dt * 10)
    obj.content.x = lerp(obj.content.x, content_x, dt * 10)
    obj.content.y = lerp(obj.content.y, content_y, dt * 10)
    obj.content.w = lerp(obj.content.w, content_w, dt * 10)
    obj.content.h = lerp(obj.content.h, content_h, dt * 10)
    obj.content.zoom = clamp(obj.content.zoom, 2, 20)

    obj.content.lerp_rotx = lerp_angle(obj.content.lerp_rotx, obj.content.rotx, dt * 15)
    obj.content.lerp_roty = lerp_angle(obj.content.lerp_roty, obj.content.roty, dt * 15)
    obj.content.lerp_rotz = lerp_angle(obj.content.lerp_rotz, obj.content.rotz, dt * 15)
    obj.content.lerp_zoom = lerp(obj.content.lerp_zoom, obj.content.zoom, dt * 15)

    local grxx, grxy, grxz = g3d.vectors.rotated(obj.content.lerp_rotx, 0, 0, 0, 0, 1, -obj.content.lerp_rotz)
    obj.content.model:setRotation(grxx, grxy, grxz + obj.content.lerp_rotz)
  end

  function obj:mousepressed(x, y, button)
    obj.comments_field:mousepressed(x, y, button)
    if not obj.comments_field.opened then
      obj.like.ib:mousepressed(x, y, button)
      obj.comment.ib:mousepressed(x, y, button)
      obj.save.ib:mousepressed(x, y, button)
      if obj.content.hovered then obj.content.clicked = true end
      if obj.content.vi_hovered then obj.content.clicked = false end
      if obj.content.oi_hovered then obj.content.is_ortho = not obj.content.is_ortho end
      if obj.content.clicked and button == 1 and not obj.content.pos_grabbed then obj.content.rot_grabbed = true end
    end
  end

  function obj:wheelmoved(x, y)
    if obj.content.clicked then obj.content.zoom = obj.content.zoom - y * 0.5 end
  end

  function obj:mousereleased(x, y, button) if button == 1 then obj.content.rot_grabbed = false end end

  function obj:mousemoved(x, y, dx, dy)
    if obj.content.rot_grabbed then
      obj.content.rotz = obj.content.rotz + dx * 7.5e-3
      obj.content.rotx = clamp(obj.content.rotx - dy * 7.5e-3, -math.pi / 2, math.pi / 2)
    end
  end

  function obj:draw()
    local like_color = nil
    if obj.like.clicked then
      like_color = {
        r = colors.red.r,
        g = colors.red.g,
        b = colors.red.b,
        1
      }
    end
    obj.like.ib:draw(700 * i, 0, like_color)
    love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
    love.graphics.printf(obj.likes, fonts.WorkSans, 700 * i + 400,
      obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")
    obj.comment.ib:draw(700 * i, 0)
    love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
    love.graphics.printf(#obj.comments, fonts.WorkSans, 700 * i + 520,
      obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")
    local save_color = nil
    if obj.save.clicked then
      save_color = {
        r = colors.yellow.r,
        g = colors.yellow.g,
        b = colors.yellow.b,
        1
      }
    end
    obj.save.ib:draw(700 * i, 0, save_color)
    love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
    love.graphics.printf("0", fonts.WorkSans, 700 * i + 640,
      obj.content.default_h + obj.content.default_y + obj.coords.y - 30, 100, "left")
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Lorem ipsum", fonts.WorkSansBig,
      obj.coords.x + obj.content.default_x + obj.min_content_w + obj.content.default_x,
      obj.coords.y + obj.content.default_y,
      obj.coords.w - (obj.content.default_x + obj.min_content_w + obj.content.default_x + obj.content.default_x), "left")
    love.graphics.setColor(colors.secondary_text.r, colors.secondary_text.g, colors.secondary_text.b, 1)
    box_text(
      obj.description,
      obj.coords.x + obj.content.default_x + obj.min_content_w + obj.content.default_x,
      obj.coords.y + obj.content.default_y + 40,
      obj.coords.w - (obj.content.default_x + obj.min_content_w + obj.content.default_x + obj.content.default_x),
      obj.coords.h - obj.content.default_y - 20, fonts.WorkSans, "left")
    love.graphics.push()
    love.graphics.origin()
    box_shadow(obj.coords.x + obj.content.x + pox, obj.coords.y + obj.content.y + poy, obj.content.w, obj.content.h, 40,
      {
        0,
        0,
        0,
        0.35
      })
    love.graphics.pop()
    love.graphics.stencil(function()
      love.graphics.rectangle("fill", obj.coords.x + obj.content.x, obj.coords.y + obj.content.y, obj.content.w,
        obj.content.h, 10)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.push()
    love.graphics.translate(obj.coords.x + obj.content.x - 10, obj.coords.y + obj.content.y - 10)
    g3d.camera.target = { 0, 0, 0 }
    g3d.camera.position = { .001, obj.content.lerp_zoom, .001 }
    g3d.camera.aspectRatio = 1 / 1
    g3d.camera.fov = math.pi / 4
    if obj.content.is_ortho then
      g3d.camera.updateOrthographicMatrix(obj.content.lerp_zoom)
    else
      g3d.camera.updateProjectionMatrix()
    end
    g3d.camera.updateViewMatrix()
    love.graphics.setMeshCullMode("front")
    love.graphics.setCanvas(obj.content.canvas)
    love.graphics.clear(.2, .2, .2, 1)
    love.graphics.setColor(1, 1, 1, 1)
    obj.content.model:draw()
    love.graphics.setCanvas()
    drawLTWH(obj.content.canvas, 10, 10, obj.content.w, obj.content.h, "vertical")
    love.graphics.pop()

    love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, obj.content.hover_a)
    love.graphics.rectangle("fill", obj.content.vi_x, obj.content.vi_y, obj.content.vi_w, obj.content.vi_h, 5)
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.content.hover_a * 2)
    drawLTWH(obj.content.view_icon, obj.content.vi_x + 5, obj.content.vi_y + 5, obj.content.vi_w - 10,
      obj.content.vi_h - 10, "horizontal")
    if obj.content.clicked then
      love.graphics.setColor(colors.main.r, colors.main.g, colors.main.b, obj.content.hover_oa)
      love.graphics.rectangle("fill", obj.content.oi_x, obj.content.oi_y, obj.content.oi_w, obj.content.oi_h, 5)
      love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, obj.content.hover_oa * 2)
      drawLTWH(obj.content.ortho_icon, obj.content.oi_x + 5, obj.content.oi_y + 5, obj.content.oi_w - 10,
        obj.content.oi_h - 10, "horizontal")
    end
    love.graphics.setStencilTest()

    obj.comments_field:draw()
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
