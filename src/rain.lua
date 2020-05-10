local mode = {};



function mode:load()
    objects = {};
    
    for i=1, 2000 do
        objects[i] = drop:new(math.random(-200, screenWidth+200), math.random(10, 100)/10);
        objects[i].ID = i;
    end

    debug:empty();
    debug:add('(^/v) Gravity', 500, 'incremental', {'up', 'down', 10, 1000, 250});
    debug:add('(</>) Wind', 200, 'incremental', {'right', 'left', 10, 500, -500});
    debug:add("(C) Colorful", false, "toggle", {"c", function(colorful)
        for k, drop in pairs(objects) do 
            if (colorful) then
                local color = {math.random(0,255), math.random(0,255), math.random(0,255)};
            
                while (color[1] + color[2] + color[3]) / 3 < 100 do
                    color = {math.random(0,255), math.random(0,255), math.random(0,255)};
                end

                drop.color = color;
            else
                drop.color = {255,255,255};
            end
        end
    end});
end

function mode:update(dt)
    for k,v in pairs(objects) do
        v:update(dt);
    end
end


function mode:draw()
    for i=1, #objects do
        objects[i]:draw();
    end
end











return mode;