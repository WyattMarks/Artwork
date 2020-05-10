local square = {};

function square:updateCanvas()
    self.canvas = love.graphics.newCanvas( self.size, self.size );
	love.graphics.setCanvas( self.canvas );
	love.graphics.setColor ( 0,0,0 );
    love.graphics.rectangle( 'fill', 0, 0, self.size, self.size );

    local border = math.max(4, self.index)
    local size = self.size - border;


    love.graphics.setColor(self.color);
    love.graphics.rectangle("fill", border/2, border/2, size, size);
	love.graphics.setCanvas( );
end

function square:new(size, index)
    local new = {};
    for k,v in pairs(self) do
        new[k] = v;
    end

    new.size = size;
    new.index = index;

    new.color = {255,255,255};

    new:updateCanvas();

    new.angle = index * math.pi / 2;
    return new;
end

function square:draw(alpha)
    love.graphics.push();   
        love.graphics.translate(screenWidth / 2, screenHeight / 2);
        
        love.graphics.setColor(alpha, alpha, alpha);
        love.graphics.draw( self.canvas, 0, 0, self.angle, 1, 1, self.size/2, self.size/2);
    love.graphics.pop();

end

function square:update(dt)
    local index = debug.settings.invert and (#objects + 1 - self.index) or self.index;
    self.angle = self.angle + dt * index * debug.settings.speed / 10;
end








return square;