function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function split(s, delimiter)
	local result = {}

	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end

	return result
end