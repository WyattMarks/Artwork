local drop = {};
drop.falling = true;



function drop:new(x, z, color)
    local new = {};
    for k,v in pairs(self) do
        new[k] = v;
    end

    new.x = x;
    new.x1 = x;
    new.y = 0;
    new.z = z;
    new.ID = "unassigned";


    new.color = color and color or {255,255,255};

    return new;
end


function drop:update(dt)
    self.y = self.y + debug.settings.gravity * dt;
    self.x1 = (1 / (dt * debug.settings.gravity)) * debug.settings.wind;
    self.x = self.x + dt * debug.settings.wind;



    if (self.y > screenHeight - self.z * 50) then
        if (self.falling) then
            self.falling = false;
            self.impact = {self.x, self.y, 0};
        else
            self.impact[3] = self.impact[3] + dt;

            if (self.impact[3] > 2) then
                objects[self.ID] = drop:new(math.random(-200, screenWidth+200), math.random(10, 100)/10, self.color);
                objects[self.ID].ID = self.ID;
            end
        end
    end
end

function drop:draw()
    
    local x1 = math.floor(0.5 + self.x - self.x1 / self.z );
    local y1 = math.floor(0.5 + self.y - 80 / self.z );

    local color = {math.floor(self.color[1] / self.z), math.floor(self.color[2] / self.z), math.floor(self.color[3] / self.z)};

    love.graphics.setColor(color[1],color[2],color[3]);


    if (self.falling) then
        love.graphics.line(math.floor(self.x), math.floor(self.y), x1, y1);
    else
        if (y1 < self.impact[2]) then
            love.graphics.line(math.floor(self.impact[1]), math.floor(self.impact[2]), x1, y1);
        end
        
        for i=1, 3 do
            color[i] = color[i] / (1 + self.impact[3]);
        end

        love.graphics.setColor(color[1],color[2],color[3]);

        love.graphics.ellipse("line", self.impact[1], self.impact[2], (self.impact[3] + 1) * 8 / (self.z / 2), (self.impact[3] + 1) * 3 / (self.z / 2));
    end
end







return drop;