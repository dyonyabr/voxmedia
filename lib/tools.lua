colors = {
    main = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    dark = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
    main_text = { r = 0.9, g = 0.9, b = 0.9, a = 1 },
    secondary_text = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
    highlight = { r = 0.2, g = 0.6, b = 0.8, a = 1 },
    button = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
    button_hover = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
    bright = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
    button_pressed = { r = 0.3, g = 0.3, b = 0.3, a = 1 },
    border = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
    white = { r = 0.9, g = 0.9, b = 0.9, a = 1 },
    red = { r = 0.8, g = 0.2, b = 0.2, a = 1 },
    green = { r = 0.2, g = 0.8, b = 0.4, a = 1 },
    disabled = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
}

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

function is_hover(x, y, w, h, px, py)
    return not (px < x or py < y or px > x + w or py > y + h)
end

function is_mouse_hover(x, y, w, h, ox, oy)
    if ox == nil then ox = offset.x end
    if oy == nil then oy = offset.y end
    local px, py = love.mouse.getPosition()
    px = px - ox
    py = py - oy
    return is_hover(x, y, w, h, px, py)
end

function is_hover_circle(x, y, radius, px, py)
    local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
    return distance <= radius
end

function is_mouse_hover_circle(x, y, radius, ox, oy)
    local px, py = love.mouse.getPosition()
    px = px - ox
    py = py - oy
    return is_hover_circle(x, y, radius, px, py)
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
