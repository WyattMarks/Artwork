local debug = {}
debug.variables = {}
debug.added = {}
debug.binds = {}
debug.offset = 10
debug.settings = {}

--self.variables["(F1) Velocity] = true
--self.binds["f1"] = {"(F1) Velocity", "toggle"}
--self.binds["up"] = {"(^/v) Timescale", "incremental", 1, {'up', 'down', .1}}
--self.binds["down"] = {"(^/v) Timescale", "incremental", 2, {'up', 'down', .1}}
--self.binds["right"] = {"(</>) Wind", "incremental", 2, {'left', 'right', .1, 20, -20}}
--V contains settings for incremental options: v = {key1, key2, increment, max, min}
function debug:empty()
    self.variables = {};
    self.added = {};
    self.binds = {};
    self.settings = {};
end


function debug:add(key, value, changeable, v)
	self.variables[key] = value
	local added = false
	for k,v in pairs(self.added) do
		if v == key then added = true end
	end

	if not added then self.added[#self.added + 1] = key end
	
	if changeable == "toggle" then
		local func;

		if type(v) == "table" then
			func = v[2];
			v = v[1];
		end

		self.binds[v] = {key, changeable, func}
		local c = string.find(key, ")")
		key = key:sub(c+2):lower()
		key = key:gsub(' ', '')
		self.settings[key] = value
	elseif changeable == "incremental" then
		self.binds[v[1]] = {key, changeable, 1, v}
		self.binds[v[2]] = {key, changeable, -1, v}
		local c = string.find(key, ")")
		key = key:sub(c+2):lower()
		key = key:gsub(' ', '')
		self.settings[key] = value
	end
end

function debug:load()
	self.font = love.graphics.newFont(20)
end

function debug:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(self.font)
	local y = 10
	for i=1, #self.added do
		local k = self.added[i]
		local v = self.variables[k]
		local str = tostring(k)
		if v ~= '' then
			str = str .. ":"
		end
        
		v = tostring(v)
		
		love.graphics.print(v, screenWidth - self.offset - self.font:getWidth(v), y)
		love.graphics.print(str, screenWidth - self.offset * 2 - self.font:getWidth(v) - self.font:getWidth(str), y)
		
		y = y + self.font:getHeight() + 2
	end
end

--self.binds["down"] = {"(^/v) Timescale", "incremental", 2, {'up', 'down', .1}}

function debug:keypressed(key)
	if self.binds[key] then
		local change = self.binds[key][2]
		local str = self.binds[key][1]
		if change == 'toggle' then
			if self.binds[key][3] then
				self.binds[key][3](not self.variables[str]);
			end

			self:add(str, not self.variables[str], change, {key, self.binds[key][3]});
		elseif change == 'incremental' then
			local increment = self.binds[key][4][3]
            local neg = self.binds[key][3]


            local val = math.floor(0.5 + (self.variables[str] + increment * neg) / increment) * increment;  --This is to stop 0 displaying
                                                                                                            --as 1.2377 e-16 because shitty
                                                                                                            --floating point math.
            if not (self.binds[key][4][4] and (val > self.binds[key][4][4] or val < self.binds[key][4][5])) then  --Don't go out of max/min if they exist
                self:add(str, val, change, self.binds[key][4] )
            end
		end
	end
end

return debug;