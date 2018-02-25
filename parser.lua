local tokenStream = {}
local tokenCounter = 0

local function peek()
	return tokenStream[tokenCounter + 1]
end

local function next()
	tokenCounter = tokenCounter + 1
	return tokenStream[tokenCounter]
end

local function eat()
	tokenCounter = tokenCounter + 1
end

function parse(stream)
	tokenStream = stream
	local token = next()

	while token do
		token = next()
		-- Do stuff with out token
	end
end