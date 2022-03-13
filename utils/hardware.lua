local Module = {}

function Module:get_number_of_cpu_core()
	local core_id

	for line in io.lines("/proc/cpuinfo") do
		core_id = string.match(line, "processor%s+:%s+(%d+)")
	end

	return core_id + 1
end

return Module
