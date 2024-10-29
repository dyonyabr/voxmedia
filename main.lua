require "assets.shaders"
require "lib.tools"
Timer = require "lib.Timer"

require "pages.mainPage"
require "components.windowTopBar"

WorkSans = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-Regular.ttf", 16)
WorkSansBig = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-Regular.ttf", 24)
WorkSansSemiBold = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-SemiBold.ttf", 16)
WorkSansSemiBoldBig = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-SemiBold.ttf", 24)

offset = { x = 0, y = 0 }
function set_offset(x, y)
    offset = { x = x, y = y }
    love.graphics.translate(x, y)
end

local main_page = MainPage:new()
local window_top_bar = WindowTopBar:new()


function love.load()
    window_top_bar:load()
    main_page:load()
end

function love.update(dt)
    set_cursor("arrow")

    window_top_bar:update(dt)
    main_page:update(dt)
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

love.graphics.setBackgroundColor(colors.dark.r, colors.dark.g, colors.dark.b, 1)
function love.draw()
    main_page:draw()
    window_top_bar:draw()
end
