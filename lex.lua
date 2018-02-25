local function eat()

end

local function peek()

end

local function createToken(tokenType, tokenValue)
	return {
		type  = tokenType,
		value = tokenValue
	}
end

local function matchAgainstKeywords(word)
	for _, keyword in pairs(keyword) do
		if keyword == word then
			return keyword
		end
	end

	return nil
end

function lex(code)
	local tokens = {}
	local trimmedCode = trim(code, "\t")
	local lines = split(code, "\n")

	local matchingStrings = false
	local matchTable = {}

	for _, line in pairs(lines) do
		local words = split(line, " ")

		for _, word in pairs(words) do
			-- Match against keywords
			local matchedWord = matchAgainstKeywords(word)

			if matchedWord or word == "n" then
				-- string matching is on but we found a keyword or a line ending character, so we need to turn it off
				if matchingStrings then
					matchingStrings = false
					local string = table.concat(matchTable, " ")
					table.insert(tokens, createToken(types.STRING, string))
					matchTable = {}
				end
			end

			if matchedWord then
				table.insert(tokens, createToken(matchedWord, nil))

			else
				-- Word is not a keyword, so we gotta figure out what it actually is
				if tonumber(word) then
					-- Word is a number. Amazing. Now let's handle it
					local tempWord = tonumber(word)
					local isFloat = math.modf(tempWord)

					if isFloat then
						-- Word is a number of type 'float'
						table.insert(tokens, createToken(tempWord, types.FLOAT))
					else
						-- Word is a number of type 'integer'
						table.insert(tokens, createToken(tempWord, types.INTEGER))
					end
				else
					-- Word is not a keyword and not a number, so we don't care and treat it as a string
					-- so we turn on string matching
					matchingStrings = true
					table.insert(matchTable, word)
				end
			end
		end
	end

	return tokens
end