function get_nb_core()
	local cpu_info = io.open('/proc/cpuinfo'):read('*all')

	local nb_core = string.match(cpu_info, 'cpu cores')
	return cpu_info
end

