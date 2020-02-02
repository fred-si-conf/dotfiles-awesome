-- This is not a widget even though it is needed by some widgets
-- It is a collection of small utilities to reuse in widgets

local utils = {}
-- Pour plus de détails sur les modes:
-- https://www.lua.org/manual/5.3/manual.html#pdf-file:read
function utils.read_file(path, mode)
	local f, ret

	f = assert(io.open(path, "r"))
	ret = f:read(mode)
	f:close()

	return ret
end

-- clear a naugthy notify using its name
function utils.clear_info(infoname)
	if infoname ~= nil then
		naughty.destroy(infoname)
		infoname = nil
	end
end

function utils.get_hostname()
	local hostname

	hostname = os.getenv("HOST")
	if not hostname then
		local f = io.popen("uname -n")
		hostname = string.gsub(f:read("*all"), "\n", "")
		f:close()
	end

	return hostname
end

function utils.get_username()
	local username

	username = os.getenv("USER")
	if not username then
		username = "master"
	end

	return username
end

-- speak a text (require festival to be installed)
function utils.speak_text(text)
	assert(io.popen("echo " .. text .. " | festival --tts"))
end

function utils.get_number_of_cpu_core()
	local core_id, line

	for line in io.lines("/proc/cpuinfo") do
		core_id = string.match(line, "processor%s+:%s+(%d+)")
	end

	return core_id + 1
end

return utils
