require "lib.tools"

require "pages.mainPage"
require "components.windowTopBar"

WorkSans = love.graphics.newFont("assets/fonts/Work_Sans/WorkSans-VariableFont_wght.ttf", 16)

local main_page = MainPage:new()
local window_top_bar = WindowTopBar:new()

function love.load()
    window_top_bar:load()
    main_page:load()
end

function love.mousepressed(x, y, button)
    window_top_bar:mousepressed(x, y, button)
    main_page:mousepressed(x, y, button)
end

function love.keypressed(k)
    -- if k == "x" then
    --     love.window.close()
    -- elseif k == "c" then
    --     love.window.minimize()
    -- end
end

function love.update(dt)
    window_top_bar:update(dt)
    main_page:update(dt)
end

function love.draw()
    window_top_bar:draw()
    main_page:draw()
end
