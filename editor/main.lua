require "shared"

function love.load()
    shader_load()
end

function love.draw()
    love.graphics.printf("Editor is working", 0, 300, love.graphics.getWidth(), "center")
end

function love.keypressed(k)
    if k == "x" then
        love.event.quit()
    end
end

function love.quit()
    send("exit\n")
end
