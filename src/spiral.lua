local mode = {};

function mode:setColor(r,g,b)
    r = math.max(0, math.min(255, r + math.random(-10, 10)));
    g = math.max(0, math.min(255, g + math.random(-10, 10)));
    b = math.max(0, math.min(255, b + math.random(-10, 10)));
    love.graphics.setColor(r,g,b);
end

function mode:load()
    math.randomseed(os.time());
    self.canvas = love.graphics.newCanvas(screenWidth, screenHeight);

    love.graphics.setBackgroundColor(0,0,0.8);
    self.totalTime = 0;
    self.stars = 0;
    self.maxR = math.sqrt( (screenHeight/2)^2 + (screenWidth/2)^2 );

    self:loadAssets();

    --for i=1, 11500 do
    --    self.update(self); --Preload painting
    --end
end

function mode:loadAssets() 
    self.star = love.graphics.newImage( "assets/star.png" );
    self.cosmos = love.graphics.newImage( "assets/cosmos.png" );
end

function mode:spiral(r, red, green, blue, angle)
    angle = angle or self.totalTime*2
    local x = r * math.cos(angle) + screenWidth / 2;
    local y = r * math.sin(angle) + screenHeight / 2;

    self:setColor(red, green, blue);

    love.graphics.circle("fill", x, y, 1 + math.random(0, 6));
end

function mode:update(dt)
    dt = .002;
    love.graphics.setCanvas( self.canvas );

    local r = self.totalTime / math.pi;
    local red =     math.max(250 - (r / 100) * 118, 137)
    local green =   math.max(250 - (r / 100) * 48, 207)
    local blue =    math.max(255 - r, 240)

    if (r > 300) then --148, 0, 211
        local newR = r - 300;
        red =   math.max(137 - (newR / 4), 97)
        green = math.max(207 - (newR / 4), 50)
        blue =  math.max(240 - (newR / 4), 167)
    end

    self:spiral(r, red, green, blue);


    self.totalTime = self.totalTime + dt;
    self.lastX = x;
    self.lastY = y;
    if r > 200 and r < 400 then
        local newR = r - 200;
        local blue =     math.max(250 - (newR / 100) * 118, 137)
        local green =   math.max(250 - (newR / 100) * 48, 207)
        local red =    math.max(255 - newR, 240)
        self:spiral(newR, red, green, blue)
    end

    if (r >= 400 and r <= 400 + 200) then --Make squiggles
        local newR = r - 400 + 225;
        local y = 25 * math.sin(newR / 9);
        
        --rotate em
        for i=0,7 do
            local theta = math.pi * i / 4;
            local rotatedX = (newR) * math.cos(theta) - (y) * math.sin(theta);
            local rotatedY = (newR) * math.sin(theta) + (y) * math.cos(theta);

            self:setColor(240, 207, 137);

            love.graphics.circle("fill", rotatedX + screenWidth / 2, rotatedY + screenHeight / 2, 1 + math.random(0, 2));
        end
    end

    --[[if (r >= self.maxR) then
        if math.random(0,10)==5 and self.stars < 15 then --slow down star placing for animation
            local randomR = math.random(650, self.maxR);
            local angle =  math.random(0,360) / 180 * math.pi;
            local scale = math.random() / 2;
            local x = r * math.cos(angle) + screenWidth / 2 - (self.star:getWidth() * scale) / 2;
            local y = r * math.sin(angle) + screenHeight / 2 - (self.star:getHeight() * scale) / 2;
        
            red = 245 + math.random(-10, 10);
            green = 245 + math.random(-10, 10);
            blue = 50 + math.random(-10, 10);
        
            self:setColor(red, green, blue);
        
            if (0 > x and x < screenWidth and 0 > y and y < screenHeight) then
                love.graphics.draw( self.star, x, y, 0, scale );
                self.stars = self.stars + 1;
            end
            
        end
    end]]

    love.graphics.setCanvas( );

    if (not self.double) then
        self.double = true;
        for i=1, 500 do
            self.update(self);
        end
        self.double = false;
    end
end

function mode:draw()
    love.graphics.setColor(255,255,255);
    love.graphics.draw(self.canvas, 0, 0);
end





return mode;