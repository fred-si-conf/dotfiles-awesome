local Module = {}

function Module:hostname()
	local hostname

	hostname = os.getenv("HOST")
    if hostname then return hostname end

    local f = io.popen("uname -n")
    hostname = string.gsub(f:read("*all"), "\n", "")
    f:close()

	return hostname
end

function Module:username()
	local username

	username = os.getenv("USER")
	if not username then
		username = "master"
	end

	return username
end

return Module
