io.stdout:setvbuf("no")

drop = require("src/drop");
square = require("src/square");
debug = require("src/debug");

mode = require("src/spiral");

local newColor = love.graphics.setColor; --11.0 temp fix, they changed color values to 0-1 instead of 0-255
function love.graphics.setColor(r,g,b,a)
	a = a or 255
	newColor(r/255,g/255,b/255,a/255)
end

function love.load()
    screenHeight = love.graphics.getHeight();
    screenWidth = love.graphics.getWidth();

    debug:load();
    mode:load();
end

function love.draw()
    mode:draw();

    debug:draw();
end

function love.update(dt)
    mode:update(dt);
end

function love.keypressed(key)
    debug:keypressed(key);

    if (key == "escape") then
        mode = require("src/menu");
        mode:load();
        debug:load();
    end
end