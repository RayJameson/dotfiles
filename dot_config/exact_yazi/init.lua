-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
	local mtime = self._file.stat.mtime
	local time = math.floor(mtime and mtime.unix or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self:size()
	return string.format("%s %s", size ~= "" and size or "-", time)
end
