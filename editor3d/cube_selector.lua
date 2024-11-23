max_items = 16

curent_c = 1
function set_cur_c(val)
  curent_c = (val - 1) % max_items + 1
  cursor_inside = g3d.newModel(inv_models[curent_c].verts, "assets/textures/default_atlas.png") 
end

function change_items(k)
  if k == "q" then
    set_cur_c(curent_c - 1)
  elseif k == "e" then
    set_cur_c(curent_c + 1)
  end
end

local cube_verts = {
  { 0, 1, 1 }, { 1, 1, 1 }, { 1, 0, 1 }, { 0, 0, 1 }, { 0, 0, 1 }, { 1, 1, 1 },
  { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 }, { 0, 1, 0 }, { 0, 0, -1 }, { .4, .4, .4 },
  { 1, 0, 0 }, { 1, 0, 1 }, { 1, 1, 1 }, { 1, 1, 0 }, { 1, 0, 0 }, { .8, .8, .8 },
  { 0, 1, 0 }, { 0, 1, 1 }, { 0, 0, 1 }, { 0, 0, 0 }, { -1, 0, 0 }, { .8, .8, .8 },
  { 1, 1, 0 }, { 1, 1, 1 }, { 0, 1, 1 }, { 0, 1, 0 }, { 0, 1, 1 }, { .6, .6, .6 },
  { 0, 0, 0 }, { 0, 0, 1 }, { 1, 0, 1 }, { 1, 0, 0 }, { 0, -1, 1 }, { .6, .6, .6 },
}

local function make_cube(verts, c)
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

inv_models = {}
function create_inv_models()
  for i = 1, max_items do
    local v = {}
    make_cube(v, i)
    local model = g3d.newModel(v, "assets/textures/default_atlas.png")
    model:setTranslation(-i, i, 0)
    inv_models[#inv_models + 1] = model
  end
  cursor_inside = g3d.newModel(inv_models[curent_c].verts, "assets/textures/default_atlas.png")  
end

local cam_tar = { -curent_c + .5, curent_c + .5, 15 }
function update_inv(dt)
  cam_tar[1] = lerp(cam_tar[1], -curent_c + .5, dt * 20)
  cam_tar[2] = lerp(cam_tar[2], curent_c + .5, dt * 20)
  for i = 1, max_items do
    local scale = 1
    local posy = 0
    if i == curent_c then scale = 1.5; posy = .5 end
    local s = inv_models[i].scale
    local y = inv_models[i].translation[3]
    s[1] = lerp(s[1], scale, dt * 20)
    s[2] = lerp(s[2], scale, dt * 20)
    s[3] = lerp(s[3], scale, dt * 20)
    y = lerp(y, posy, dt * 20)
    inv_models[i]:setScale(s[1], s[2], s[3])
    inv_models[i].translation[3] = y
  end
end

local inv_canvas = gr.newCanvas(gr.getWidth(), gr.getHeight())
function inv_canvas_update()
  inv_canvas = gr.newCanvas(gr.getWidth(), gr.getHeight())
end

function draw_inv()
  gr.setCanvas(inv_canvas)
  gr.clear()
  g3d.camera.target = cam_tar
  g3d.camera.position[1] = 5 + cam_tar[1]
  g3d.camera.position[2] = 5 + cam_tar[2]
  g3d.camera.position[3] = 5 * 45 / 45 + 15
  g3d.camera.fov = math.pi / 3
  g3d.camera.updateOrthographicMatrix(20)
  g3d.camera.updateViewMatrix()
  for i = 1, max_items do
    if inv_models[i] ~= nil and i ~= curent_c then
      inv_models[i]:draw()
    end
  end
  inv_models[curent_c]:draw()
  gr.setCanvas()
  gr.draw(inv_canvas, 0, 0)
end
