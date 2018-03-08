local tokenStream = {}
local tokenCounter = 0

variableLookupTable = {}

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

local function errOut(text)
	outputChatBox("#FF0000" .. text, 0, 255, 255, true)
end

local function debugOut(text)
	if not debugMode then return end
	outputChatBox("#FFB300" .. text, 0, 255, 255, true)
end

local function stdOut(text)
	outputChatBox("#FFFFFF" .. text, 0, 255, 255, true)
end

function parse(stream)
	tokenStream = stream
	local token = next()

	while token do
		if not token then return end
		-- Do stuff with our token

		if token.type == keyword.VERSION then
			if peek().type ~= types.INTEGER and peek().type ~= types.FLOAT then
				return errOut("Error. Expected version number.")
			end
			debugOut("LOLCODE version set to v" .. peek().value)
			eat()

		elseif token.type == keyword.COMMENT then
			if peek().type ~= types.STRING then
				return errOut("Error. Expected string at comment definition.")
			end

			eat()

		elseif token.type == keyword.PRINT then
			if peek().type ~= types.STRING then
				return errOut("Error. Expected string at VISIBLE instruction.")
			end

			local lookup = peek().value

			if lookup:match("\"") then
				stdOut("LOLCODE OUTPUT: " .. lookup:gsub("\"", ""), 255, 255, 255, true)
			else
				stdOut("LOLCODE OUTPUT: " .. variableLookupTable[tostring(lookup:gsub("\"", ""))])
			end

			eat()

		elseif token.type == keyword.I then
			local has = peek()
			eat()
			local a = peek()
			eat()
			local varname = peek()
			eat()

			if has.type ~= keyword.HAS and a.type ~= keyword.A then
				return errOut("Error. Expected proper variable definition")
			end

			if varname.type ~= types.STRING then
				return errOut("Error. Expected variable name")
			end

			variableLookupTable[varname.value] = 0
			debugOut("Variable " .. varname.value .. " has been declared")

		elseif token.type == types.STRING then
			-- Assigning value to variable
			if variableLookupTable[token.value] then
				eat()
				debugOut("Variable " .. token.value .. " was set to " .. peek().value)
				variableLookupTable[token.value] = peek().value
				eat()
			end
		end

		token = next()
	end
end