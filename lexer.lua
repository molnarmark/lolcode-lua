local function createToken(tokenType, tokenValue)
	return {
		type  = tokenType,
		value = tokenValue or nil
	}
end

local function matchAgainstKeywords(word)
	for _, kw in pairs(keyword) do
		if kw == word then
			return kw
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

			if matchedWord then
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
				-- Word is the first one so we just treat is as a string, possibly a variable declaration
				if words[1] == word then
					matchingStrings = false
					matchTable = {}
					table.insert(tokens, createToken(types.STRING, word))
				end

				-- Word is not a keyword, so we gotta figure out what it actually is
				if tonumber(word) and not matchingStrings then
					-- Word is a number. Amazing. Now let's handle it
					local tempWord = tonumber(word)
					local isFloat = math.modf(tempWord)

					if isFloat then
						-- Word is a number of type 'float'
						table.insert(tokens, createToken(types.FLOAT, tempWord))
					else
						-- Word is a number of type 'integer'
						table.insert(tokens, createToken(types.INTEGER, tempWord))
					end
				else
					-- Word is not a keyword and not a number, so we don't care and treat it as a string
					-- so we turn on string matching
					if not word:match("\n") then
						matchingStrings = true
					end
					table.insert(matchTable, word)
				end
			end
		end
	end

	return tokens
end