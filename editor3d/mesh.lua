mesh = {}

local cube_verts = {
  { 0, 1, 1 }, { 1, 1, 1 }, { 1, 0, 1 }, { 0, 0, 1 }, { 0, 0, 1 }, { 1, 1, 1 },
  { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 }, { 0, 1, 0 }, { 0, 0, -1 }, { .4, .4, .4 },
  { 1, 0, 0 }, { 1, 0, 1 }, { 1, 1, 1 }, { 1, 1, 0 }, { 1, 0, 0 }, { .8, .8, .8 },
  { 0, 1, 0 }, { 0, 1, 1 }, { 0, 0, 1 }, { 0, 0, 0 }, { -1, 0, 0 }, { .8, .8, .8 },
  { 1, 1, 0 }, { 1, 1, 1 }, { 0, 1, 1 }, { 0, 1, 0 }, { 0, 1, 1 }, { .6, .6, .6 },
  { 0, 0, 0 }, { 0, 0, 1 }, { 1, 0, 1 }, { 1, 0, 0 }, { 0, -1, 1 }, { .6, .6, .6 },
}

chunk_size = 16
chunk_count = 4
bounds = chunk_count * chunk_size

local function i2pos(index, size)
  local z = math.floor((index - 1) / (size * size))
  local y = math.floor((index - 1 - z * size * size) / size)
  local x = (index - 1) % size
  return x + 1, y + 1, z + 1
end

local function pos2i(x, y, z, size)
  return (z - 1) * size * size + (y - 1) * size + x
end

local data = {}
local chunks = {}

local function get_data(i)
  return data[i]
end

local function set_data(i, c)
  data[i] = c
end

function get_data_pos(x, y, z)
  return get_data(pos2i(x, y, z, bounds))
end

function set_data_pos(x, y, z, c, update)
  set_data(pos2i(x, y, z, bounds), c)
  if update then
    local cx, cy, cz = math.floor(x / chunk_size), math.floor(y / chunk_size), math.floor(z / chunk_size)
    local lx, ly, lz = x % chunk_size, y % chunk_size, z % chunk_size
    make_chunk(chunks[pos2i(cx, cy, cz, chunk_count)], cx * chunk_size, cy * chunk_size, cz * chunk_size)
    if lx == 0 then
      local chunk = chunks[pos2i(cx - 1, cy, cz, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx - 1, cy, cz, chunk_count)], (cx - 1) * chunk_size, cy * chunk_size,
          cz * chunk_size)
      end
    elseif lx == chunk_size - 1 then
      local chunk = chunks[pos2i(cx + 1, cy, cz, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx + 1, cy, cz, chunk_count)], (cx + 1) * chunk_size, cy * chunk_size,
          cz * chunk_size)
      end
    elseif ly == 0 then
      local chunk = chunks[pos2i(cx, cy - 1, cz, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx, cy - 1, cz, chunk_count)], cx * chunk_size, (cy - 1) * chunk_size,
          cz * chunk_size)
      end
    elseif ly == chunk_size - 1 then
      local chunk = chunks[pos2i(cx, cy + 1, cz, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx, cy + 1, cz, chunk_count)], cx * chunk_size, (cy + 1) * chunk_size,
          cz * chunk_size)
      end
    elseif lz == 0 then
      local chunk = chunks[pos2i(cx, cy, cz - 1, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx, cy - 1, cz, chunk_count)], cx * chunk_size, cz * chunk_size,
          (cz - 1) * chunk_size)
      end
    elseif lz == chunk_size - 1 then
      local chunk = chunks[pos2i(cx, cy, cz + 1, chunk_count)]
      if chunk then
        make_chunk(chunks[pos2i(cx, cy + 1, cz, chunk_count)], cx * chunk_size, cz * chunk_size,
          (cz + 1) * chunk_size)
      end
    end
  end
end

local dirs = { { 0, 0, 1 }, { 0, 0, -1 }, { 1, 0, 0 }, { -1, 0, 0 }, { 0, 1, 0 }, { 0, -1, 0 } }
local function make_cube(x, y, z, cx, cy, cz, verts, c)
  for i = 0, 5 do
    local draw = true
    local nx, ny, nz = x + dirs[i + 1][1] + cx, y + dirs[i + 1][2] + cy, z + dirs[i + 1][3] + cz
    if nx >= 0 and nx < bounds and ny >= 0 and ny < bounds and nz >= 0 and nz < bounds then
      local n = get_data(pos2i(nx, ny, nz, bounds))
      draw = n == 0
    end
    if draw then
      if verts == nil then
        verts = {}
      end
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
          verts[#verts + 1] = { pos[t][v][1] + x, pos[t][v][2] + y, pos[t][v][3] + z,
            uv[t][v][1], uv[t][v][2],
            normal[1], normal[2], normal[3],
            color[t][v][1], color[t][v][2], color[t][v][3], color[t][v][4] }
        end
      end
    end
  end
end

function make_chunk(chunk, cx, cy, cz)
  local verts = {}
  for x = 0, chunk_size - 1 do
    for y = 0, chunk_size - 1 do
      for z = 0, chunk_size - 1 do
        local c = get_data(pos2i(x + cx, y + cy, z + cz, bounds))
        if c ~= 0 then
          make_cube(x, y, z, cx, cy, cz, verts, c)
        end
      end
    end
  end
  if verts == nil or #verts < 3 then
    verts = { {}, {} }
  end
  chunk.model = g3d.newModel(verts, "assets/textures/default_atlas.png", { cx, cy, cz })
end

function mesh:init()
  for x = 0, bounds - 1 do
    for y = 0, bounds - 1 do
      for z = 0, bounds - 1 do
        local c = 0
        set_data(pos2i(x, y, z, bounds), c)
      end
    end
  end

  for x = 0, chunk_count - 1 do
    for y = 0, chunk_count - 1 do
      for z = 0, chunk_count - 1 do
        local chunk = { model = nil }
        make_chunk(chunk, x * chunk_size, y * chunk_size, z * chunk_size)
        chunks[pos2i(x, y, z, chunk_count)] = chunk
      end
    end
  end
end

function mesh:draw()
  for x = 0, chunk_count - 1 do
    for y = 0, chunk_count - 1 do
      for z = 0, chunk_count - 1 do
        local model = chunks[pos2i(x, y, z, chunk_count)].model
        model:draw()
      end
    end
  end
end
