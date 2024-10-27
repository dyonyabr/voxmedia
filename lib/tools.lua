colors = {
    main = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    dark = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
    main_text = { r = 0.9, g = 0.9, b = 0.9, a = 1 },
    secondary_text = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
    highlight = { r = 0.2, g = 0.6, b = 0.8, a = 1 },
    button = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
    bright = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
    button_hover = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
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

function is_mouse_hover(x, y, w, h)
    local px, py = love.mouse.getPosition()
    return is_hover(x, y, w, h, px, py)
end

function drawLTWH(image, x, y, width, height, keep_aspect)
    local imgWidth = image:getWidth()
    local imgHeight = image:getHeight()

    local scaleX = width / imgWidth
    local scaleY = height / imgHeight

    if keep_aspect then
        local scale = math.min(scaleX, scaleY)
        scaleX = scale
        scaleY = scale
    end

    local offsetX = (width - imgWidth * scaleX) / 2
    local offsetY = (height - imgHeight * scaleX) / 2

    love.graphics.draw(image, x + offsetX, y + offsetY, 0, scaleX, scaleY)
end
