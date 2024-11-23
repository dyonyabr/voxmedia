require "shared"
shared_load()
require "tools"

g3d = require "g3d"
gr = love.graphics
kb = love.keyboard

require "mesh"
require "cube_selector"

views = {
  "top", "side", "persp"
}
view = 3

local cube_verts = {
  { -0.001, 1.001,  1.001 }, { 1.001, 1.001, 1.001 }, { 1.001, -0.001, 1.001 }, { -0.001, -0.001, 1.001 }, { -.001, -.001, 1.001 }, { 1, 1, 1 },
  { -0.001, -0.001, -0.001 }, { 1.001, -0.001, -0.001 }, { 1.001, 1.001, -0.001 }, { -0.001, 1.001, -0.001 }, { -0.001, -0.001, -1.001 }, { .4, .4, .4 },
  { 1.001,  -0.001, -0.001 }, { 1.001, -0.001, 1.001 }, { 1.001, 1.001, 1.001 }, { 1.001, 1.001, -0.001 }, { 1.001, -0.001, -0.001 }, { .8, .8, .8 },
  { -0.001, 1.001,  -0.001 }, { -0.001, 1.001, 1.001 }, { -0.001, -0.001, 1.001 }, { -0.001, -0.001, -0.001 }, { -1.001, -0.001, -0.001 }, { .8, .8, .8 },
  { 1.001,  1.001,  -0.001 }, { 1.001, 1.001, 1.001 }, { -0.001, 1.001, 1.001 }, { -0.001, 1.001, -0.001 }, { -0.001, 1.001, 1.001 }, { .6, .6, .6 },
  { -0.001, -0.001, -0.001 }, { -0.001, -0.001, 1.001 }, { 1.001, -0.001, 1.001 }, { 1.001, -0.001, -0.001 }, { -0.001, -1.001, 1.001 }, { .6, .6, .6 },
}
local function make_cube(verts)
  for i = 0, 5 do
    local normal = cube_verts[i * 6 + 5]

    local pos = { {}, {} }
    local uv = { {}, {} }
    local color = { {}, {} }
    for j = 1, 3 do
      local col = cube_verts[i * 6 + 6]

      pos[1][1] = cube_verts[i * 6 + 1]
      pos[1][2] = cube_verts[i * 6 + 2]
      pos[1][3] = cube_verts[i * 6 + 3]
      uv[1][1] = { 0, 0 }
      uv[1][2] = { 0, 1 }
      uv[1][3] = { 1, 1 }
      color[2][1] = { 1, 1, 1, 1 }
      color[2][2] = { 1, 1, 1, 1 }
      color[2][3] = { 1, 1, 1, 1 }
      pos[2][1] = cube_verts[i * 6 + 1]
      pos[2][2] = cube_verts[i * 6 + 3]
      pos[2][3] = cube_verts[i * 6 + 4]
      uv[2][1] = { 0, 0 }
      uv[2][2] = { 1, 1 }
      uv[2][3] = { 1, 0 }
      color[1][1] = { 1, 1, 1, 1 }
      color[1][2] = { 1, 1, 1, 1 }
      color[1][3] = { 1, 1, 1, 1 }
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

love.graphics.setDefaultFilter("nearest", "nearest")

local grid_verts = {}
local grid_color = { { .075, .075, .075, 1 }, { .1, .1, .1, 1 } }
for x = 0, bounds - 1 do
  for y = 0, bounds - 1 do
    grid_verts[#grid_verts + 1] = {
      x, y, 0, 0, 0, 0, 0, 1, grid_color[1][1], grid_color[1][2], grid_color[1][3], 1
    }
    grid_verts[#grid_verts + 1] = {
      x + 1, y, 0, 0, 0, 0, 0, 1, grid_color[1][1], grid_color[1][2], grid_color[1][3], 1
    }
    grid_verts[#grid_verts + 1] = {
      x + 1, y + 1, 0, 0, 0, 0, 0, 1, grid_color[1][1], grid_color[1][2], grid_color[1][3], 1
    }
    grid_verts[#grid_verts + 1] = {
      x, y, 0, 0, 0, 0, 0, 1, grid_color[2][1], grid_color[2][2], grid_color[2][3], 1
    }
    grid_verts[#grid_verts + 1] = {
      x + 1, y + 1, 0, 0, 0, 0, 0, 1, grid_color[2][1], grid_color[2][2], grid_color[2][3], 1
    }
    grid_verts[#grid_verts + 1] = {
      x, y + 1, 0, 0, 0, 0, 0, 1, grid_color[2][1], grid_color[2][2], grid_color[2][3], 1
    }
  end
end
local grid = g3d.newModel(grid_verts)


local is_ortho = false
cam_target = { chunk_count * chunk_size / 2, chunk_count * chunk_size / 2, 0 }
local cam_rot_y = math.pi / 4
local cam_zoom = 6

local draw_cam_target = { chunk_count * chunk_size / 2, chunk_count * chunk_size / 2, 0 }
local draw_cam_rot_y = math.pi / 4
local draw_cam_zoom = 6

local cursor_sphere = g3d.newModel("assets/models/sphere.obj")
local cursor_shader = gr.newShader(g3d.shaderpath, "assets/shaders/cursor.frag")
local ccv = {}
make_cube(ccv)
local cursor_cube = g3d.newModel(ccv, "assets/textures/cur_tr.png")
local cursor_pos = { cam_target[1], cam_target[2], cam_target[3] }
local cursor = cursor_cube
ci_verts = {{}}
cursor_inside = g3d.newModel(ci_verts) 

g3d.camera.fov = math.pi / 4

mesh:init()
create_inv_models()

function love.keypressed(k)
  local dir = { 0, 0, 0 }
  dir[1] = ((k == "d") and 1 or 0) - ((k == "a") and 1 or 0)
  dir[2] = ((k == "w") and 1 or 0) - ((k == "s") and 1 or 0)
  dir[3] = ((k == "space") and 1 or 0) - ((k == "lshift") and 1 or 0)

  local angle = cam_rot_y - cam_rot_y % (math.pi / 2)
  dir[1], dir[2], dir[3] = g3d.vectors.rotated(dir[1], dir[2], dir[3], 0, 0, 1, angle)

  local prev_ct = { cam_target[1], cam_target[2], cam_target[3] }
  cam_target[1] = clamp(0, cam_target[1] + dir[1], bounds - 1)
  cam_target[2] = clamp(0, cam_target[2] + dir[2], bounds - 1)
  cam_target[3] = clamp(0, cam_target[3] + dir[3], bounds - 1)

  if cam_target[1] ~= prev_ct[1] and cam_target[2] ~= prev_ct[2] and cam_target[3] ~= prev_ct[3] then
  end

  cam_rot_y = (cam_rot_y + (((k == "right") and 1 or 0) - ((k == "left") and 1 or 0)) * math.pi / 4) % (math.pi * 2)

  cam_zoom = clamp((cam_zoom + (((k == "down") and 1 or 0) - ((k == "up") and 1 or 0)) * 2), 6, 18)

  if k == "return" then
    set_data_pos(cam_target[1], cam_target[2], cam_target[3], curent_c, true)
  elseif k == "rshift" then
    set_data_pos(cam_target[1], cam_target[2], cam_target[3], 0, true)
  elseif k == "r" then
    is_ortho = not is_ortho
  elseif k == [[\]] then
    view = (view) % 3 + 1
  end

  change_items(k)
end

function love.update(dt)
  draw_cam_target[1] = lerp(draw_cam_target[1], cam_target[1] + .5, dt * 20)
  draw_cam_target[2] = lerp(draw_cam_target[2], cam_target[2] + .5, dt * 20)
  draw_cam_target[3] = lerp(draw_cam_target[3], cam_target[3] + .5, dt * 20)
  cursor_pos[1] = cam_target[1]
  cursor_pos[2] = cam_target[2]
  cursor_pos[3] = cam_target[3]
  local test_rot = lerp_angle(draw_cam_rot_y, cam_rot_y, dt * 20)
  if math.abs(test_rot - draw_cam_rot_y) > .001 then draw_cam_rot_y = test_rot end
  draw_cam_zoom = lerp(draw_cam_zoom, cam_zoom, dt * 20)

  cursor:setTranslation(cursor_pos[1], cursor_pos[2], cursor_pos[3])
  cursor_inside:setTranslation(cursor_pos[1] + .25, cursor_pos[2] + .25, cursor_pos[3] + .25)
  cursor_inside:setScale(.5, .5, .5)
  update_inv(dt)
end

function love.draw()
  love.graphics.setDepthMode("lequal", true)
  gr.clear({ .05, .05, .05, 1 })

  local of1, of2 = g3d.vectors.rotated(0, -draw_cam_zoom, 0, 0, 0, 1, draw_cam_rot_y)
  of3 = draw_cam_zoom / 45 * 35
  if view == 1 then
    of1, of2 = 0, 0
  elseif view == 2 then
    of3 = 0
  end
  g3d.camera.target = draw_cam_target

  g3d.camera.position = { draw_cam_target[1] + of1, draw_cam_target[2] + of2, draw_cam_target[3] + of3 }
  g3d.camera.updateViewMatrix()
  if is_ortho then
    g3d.camera.updateOrthographicMatrix(draw_cam_zoom)
  else
    g3d.camera.updateProjectionMatrix()
  end
  g3d.camera.fov = math.pi / 4

  love.graphics.setMeshCullMode("back")
  grid:draw()
  love.graphics.setMeshCullMode("front")
  mesh:draw()
  if cursor_inside ~= nil then cursor_inside:draw() end
  cursor:draw()

  if not is_ortho then love.graphics.setDepthMode("lequal", true) else love.graphics.setDepthMode("notequal", true) end
  draw_inv()
end

function love.resize(w, h)
  g3d.camera.aspectRatio = love.graphics.getWidth() / love.graphics.getHeight()
  inv_canvas_update()
end

function love.quit()
  send("exit\n")
end
