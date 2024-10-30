function lerp(a, b, t)
    return a + (b - a) * t
end

function posmod(a, b)
    return ((a % b) + b) % b
end

function clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

local cur_hover = { 0, 0, 0, 0 }
local cur_hover_circle = { 0, 0, 0 }

function is_hover(x, y, w, h, px, py, ox, oy)
    x = x + ox
    y = y + oy
    local da = not (px < x or py < y or px > x + w or py > y + h)
    local new = (cur_hover[1] == 0 and cur_hover[2] == 0 and cur_hover[3] == 0 and cur_hover[4] == 0)
    local inside = not new and ((cur_hover[1] == x and cur_hover[2] == y and cur_hover[3] == w and cur_hover[4] == h) or
        (cur_hover[1] <= x and cur_hover[2] <= y and cur_hover[3] >= w and cur_hover[4] >= h))
    if (new or inside) and da then
        cur_hover = { x, y, w, h }
        return true
    end
    return false
end

function is_mouse_hover(x, y, w, h, ox, oy, pox, poy)
    if ox == nil then ox = 0 end
    if oy == nil then oy = 0 end
    if pox == nil then pox = 0 end
    if poy == nil then poy = 0 end
    local px, py = love.mouse.getPosition()
    px = px - pox
    py = py - poy
    return is_hover(x, y, w, h, px, py, ox, oy)
end

function is_hover_circle(x, y, radius, px, py, ox, oy)
    x = x + ox
    y = y + oy
    local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
    local da = distance <= radius
    local new = (cur_hover[1] == 0 and cur_hover_circle[2] == 0 and cur_hover_circle[3] == 0)
    local inside = not new and
        ((cur_hover_circle[1] == x and cur_hover_circle[2] == y and cur_hover_circle[3] == radius) or
            (cur_hover_circle[1] <= x and cur_hover_circle[2] <= y and cur_hover_circle[3] >= radius))
    if (new or inside) and da then
        cur_hover_circle = { x, y, radius }
        return true
    end
    return false
end

function is_mouse_hover_circle(x, y, radius, ox, oy, pox, poy)
    if ox == nil then ox = 0 end
    if oy == nil then oy = 0 end
    if pox == nil then pox = 0 end
    if poy == nil then poy = 0 end
    local px, py = love.mouse.getPosition()
    px = px - pox
    py = py - poy
    return is_hover_circle(x, y, radius, px, py, ox, oy)
end

function drawLTWH(image, x, y, width, height, aspect)
    local imgWidth = image:getWidth()
    local imgHeight = image:getHeight()

    local scaleX = width / imgWidth
    local scaleY = height / imgHeight

    if aspect ~= nil then
        local scale
        if aspect == "vertical" then
            scale = math.max(scaleX, scaleY)
        elseif aspect == "horizontal" then
            scale = math.min(scaleX, scaleY)
        end
        scaleX = scale
        scaleY = scale
    end

    local offsetX = (width - imgWidth * scaleX) / 2
    local offsetY = (height - imgHeight * scaleX) / 2

    love.graphics.draw(image, x + offsetX, y + offsetY, 0, scaleX, scaleY)
end

function box_shadow(x, y, w, h, shadowSpread, shadowColor)
    box_shadow_shader:send("rectPos", { x + offset.x, y + offset.y })
    box_shadow_shader:send("rectSize", { w, h })
    box_shadow_shader:send("shadowSpread", shadowSpread)
    box_shadow_shader:send("shadowColor", shadowColor)

    love.graphics.setShader(box_shadow_shader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()
end

function circle_shadow(x, y, radius, shadowSpread, shadowColor)
    circle_shadow_shader:send("circleCenter", { x + offset.x, y + offset.y })
    circle_shadow_shader:send("radius", radius)
    circle_shadow_shader:send("shadowSpread", shadowSpread)
    circle_shadow_shader:send("shadowColor", shadowColor)

    love.graphics.setShader(circle_shadow_shader)
    love.graphics.circle("fill", x, y, radius + shadowSpread)
    love.graphics.setShader()
end

function box_text(text, x, y, w, h, font, align)
    -- Set the font
    love.graphics.setFont(font)

    -- Calculate how many lines of text can fit in the height
    local lineHeight = font:getHeight()
    local maxLines = math.floor(h / lineHeight)

    -- Create a formatted text object that wraps to the specified width
    love.graphics.printf(text, x, y, w, align)
end

function set_cursor(type)
    love.mouse.setCursor(love.mouse.getSystemCursor(type))
end

function tools_update(dt)
    cur_hover = { 0, 0, 0, 0 }
    cur_hover_circle = { 0, 0, 0 }
end
