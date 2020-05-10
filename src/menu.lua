local menu = {};


function menu:load()
    self.font = love.graphics.newFont(20);
    self.smallFont = love.graphics.newFont(10);
    debug:empty();

    self.buttons = { 
        {
            x = screenWidth / 2 - 120,
            y = screenHeight / 2,
            w = 100,
            h = 50,
            text = "Squares",
            hover = false,
            func = function() mode = require("src/squares"); end
        }, {
            x = screenWidth / 2 + 20,
            y = screenHeight / 2,
            w = 100,
            h = 50,
            text = "Rain",
            hover = false,
            func = function() mode = require("src/rain"); end
        }, {
            x = screenWidth / 2 - 120,
            y = screenHeight / 2 + 60,
            w = 100,
            h = 50,
            text = "Spiral",
            hover = false,
            func = function() mode = require("src/spiral"); end
        }
    }
end

function menu:update(dt)
    if (love.mouse.isDown(1)) then
        local x, y = love.mouse.getPosition();

        for k, btn in pairs(self.buttons) do
            if ((x > btn.x and x < btn.x + btn.w) and (y > btn.y and y < btn.y + btn.h)) then
                btn.hover = true;
            else
                btn.hover = false;
            end
        end
    else
        for k, btn in pairs(self.buttons) do
            if (btn.hover) then
                btn.func();
                mode:load();
            end
        end
    end
end

function menu:draw()
    love.graphics.setColor(255,255,255);
    local str = "Click a visualization";
    love.graphics.print(str, screenWidth / 2 - self.font:getWidth(str) / 2, 300);

    for k, btn in pairs(self.buttons) do
        if (btn.hover) then
            love.graphics.setColor(50,50,50)
        else
            love.graphics.setColor(100,100,100);
        end

        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h);

        love.graphics.setColor(255,255,255);
        
        local x = btn.x + btn.w / 2 - self.smallFont:getWidth(btn.text);
        local y = btn.y + btn.h / 2 - self.smallFont:getHeight();
        love.graphics.print(btn.text, x, y);
    end
end






return menu;