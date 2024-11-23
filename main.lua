require "lib.loader"

offset = { x = 0, y = 0 }
function set_offset(x, y)
  offset = { x = x, y = y }
  love.graphics.translate(x, y)
end

editor_opened = false
function open_editor()
  editor_opened = true
  io.popen("start love editor3d")
end

local main_page = MainPage:new()
local window_top_bar = WindowTopBar:new()

function love.load(arg, morearg)
  shared_load()
  window_top_bar:load()
  main_page:load()
end

function love.keypressed(k)
  if not editor_opened then
    main_page:keypressed(k)
  end
end

function love.mousepressed(x, y, button)
  if not editor_opened then
    window_top_bar:mousepressed(x, y, button)
    main_page:mousepressed(x, y, button)
  end
end

function love.wheelmoved(x, y)
  if not editor_opened then
    main_page:wheelmoved(x, y)
  end
end

function love.mousereleased(x, y, button)
  if not editor_opened then
    main_page:mousereleased(x, y, button)
  end
end

function love.mousemoved(x, y, dx, dy)
  if not editor_opened then
    main_page:mousemoved(x, y, dx, dy)
  end
end

function love.update(dt)
  set_cursor("arrow")
  shared_update(dt)
  tools_update(dt)
  if not editor_opened then
    window_top_bar:update(dt)
    main_page:update(dt)
  end
end

love.graphics.setBackgroundColor(colors.dark.r, colors.dark.g, colors.dark.b, 1)
function love.draw()
  main_page:draw()
  window_top_bar:draw()

  love.graphics.push()
  love.graphics.origin()
  if editor_opened then
    love.graphics.setColor(0, 0, 0, .85)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Please, finish your work in the editor first.", fonts.WorkSansBig, 0,
      love.graphics.getHeight() / 2 - 7,
      love.graphics.getWidth(), "center")
  end
  love.graphics.pop()
end
