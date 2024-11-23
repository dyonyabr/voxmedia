ClickEffect = {}

function ClickEffect:new()
    local obj = {}

    obj.click_effects = {}
    obj.is_click_delete = false

    function obj:delete_click()
        if obj.is_click_delete then
            table.remove(obj.click_effects, 1); obj.is_click_delete = false
        end
    end

    function obj:do_click(x, y)
        local cl_ef = {
            radius = 0,
            a = 1,
            pos = { x = x, y = y }
        }
        obj.click_effects[#obj.click_effects + 1] = cl_ef
        obj.click_effects[# obj.click_effects].timer = Timer()
        obj.click_effects[# obj.click_effects].timer:after(.5, function()
            obj.is_click_delete = true
        end)
    end

    function obj:update(dt)
        for i = 1, #obj.click_effects do
            obj.click_effects[i].timer:update(dt)
            obj.click_effects[i].radius = obj.click_effects[i].radius + 300 * dt
            obj.click_effects[i].a = obj.click_effects[i].a - 3 * dt
        end

        obj:delete_click()
    end

    function obj:draw()
        for i = 1, #obj.click_effects do
            if obj.click_effects[i] ~= nil then
                love.graphics.setColor(colors.button_pressed.r, colors.button_pressed.g, colors.button_pressed.b,
                    obj.click_effects[i].a)
                love.graphics.circle("fill", obj.click_effects[i].pos.x,
                    obj.click_effects[i].pos.y,
                    obj.click_effects[i].radius)
            end
        end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
