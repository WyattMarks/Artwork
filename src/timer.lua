local timer = {};
timer.timers = {};

--A function (denoted by ID) that repeats(every time seconds) function func count times. if count == 0 then repeat infinitely
function timer:new(id, time, func, count)
    self.timers[id] = {func, time, count, 0};
end

function timer:remove(id)
    self.timers[id] = nil;
end

function timer:update(dt)
    for id, timer in pairs(self.timers) do 
        timer[4] = timer[4] + dt;

        if (timer[4] > timer[2]) then           --Repeat every x seconds
            timer[4] = timer[4] - timer[2];

            timer[1]();                         --Call function

            if (timer[3] ~= 0) then
                timer[3] = timer[3] - 1;        --Repeat only x times, but only if it isn't 0 (infinite)
                if (timer[3] == 0) then
                    self:remove(id);
                end
            end
        end
    end
end

return timer;