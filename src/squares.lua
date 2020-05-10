local mode = {};


local function distance(x1, y1, x2, y2)
    return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end


function mode:load()
    self.speed = 6;
    self.x = 0;
    self.y = 0;
    self.snapshots = {
        --{TIMESTAMP, X, Y}
    }
    self.lastsnapShot = 0.3;

    objects = {};
    totalTime = 0;
    rawTime = 0;
    local index = 1;
    for i=25, 1, -1 do
        objects[index] = square:new((i + 3) / 3 * 40, i);
        index = index + 1;
    end

    debug:empty()
    debug:add('(</>) Speed', 1, 'incremental', {'right', 'left', 0.1});
    debug:add('(^/v) Squares', 25, 'incremental', {'up', 'down', 1, 100, 0});
    debug:add("(I) Invert", false, "toggle", "i");
    debug:add("(C) Colorful", false, "toggle", {"c", function(colorful)
        for k, square in pairs(objects) do 
            if (colorful) then
                local color = {math.random(0,255), math.random(0,255), math.random(0,255)};
            
                while (color[1] + color[2] + color[3]) / 3 < 100 do
                    color = {math.random(0,255), math.random(0,255), math.random(0,255)};
                end

                square.color = color;
            else
                square.color = {255,255,255};
            end

            square:updateCanvas();
        end
    end});
end

function mode:update(dt)
    for k,v in pairs(objects) do
        v:update(dt);
    end

    totalTime = totalTime + dt * debug.settings.speed / 10; --Used to calculate the angle for newly added squares
    rawTime = rawTime + dt;
    self.lastsnapShot = self.lastsnapShot + dt;

    if (#objects ~= debug.settings.squares) then
        while(#objects > debug.settings.squares) do
            table.remove(objects, 1);
        end

        while(#objects < debug.settings.squares) do
            table.insert(objects, 1, square:new((#objects + 1 + 3) / 3 * 40, #objects + 1, 1));
            local index = debug.settings.invert and (#objects + 1 - objects[1].index) or objects[1].index;
            objects[1].angle = objects[1].index * math.pi / 2 + totalTime * index;
        end
    end

    if (love.mouse.isDown(1)) then

        local mx, my = love.mouse.getPosition();
        mx = mx - screenWidth / 2;
        my = my - screenHeight / 2;

        self.x = ((mx - self.x) * dt * self.speed) + self.x;
        self.y = ((my - self.y) * dt * self.speed) + self.y;

        if (self.lastsnapShot > 0.1 and distance(self.x, self.y, mx, my) > 50) then
            self.snapshots[#self.snapshots + 1] = {rawTime, self.x, self.y};
            self.lastsnapShot = 0;
        end
    else
        --self.x = 0;
        --self.y = 0;
    end

    if (#self.snapshots > 0 and rawTime - self.snapshots[1][1] > 2) then
        table.remove(self.snapshots, 1);
    end
end


function mode:draw()

    for k, snapshot in pairs(self.snapshots) do
        love.graphics.push();
        love.graphics.translate(snapshot[2], snapshot[3]);

        local alpha = math.max(0, 255 - 255 * ((rawTime - snapshot[1]) / 2));


        for i=1, #objects do
            objects[i]:draw(alpha);
        end

        love.graphics.pop();
    end

    love.graphics.push();
    love.graphics.translate(self.x, self.y);

    for i=1, #objects do
        objects[i]:draw(255);
    end

    love.graphics.pop();
end











return mode;