keyword = {
	COMMENT       = "BTW",
	VERSION       = "HAI",
	HALT          = "KTHXBYE",
	PRINT         = "VISIBLE",
	VAR           = "I HAS A",

	TYPE_STRING   = "YARN",
	TYPE_INTEGER  = "NUMBR",
	TYPE_FLOAT    = "NUMBAR",
	TYPE_BOOLEAN  = "TROOF",
	BOOLEAN_TRUE  = "WIN",
	BOOLEAN_FALSE = "FAIL",

	-- Not needed as of now
	INPUT         = "GIMMEH",

	AND           = "AN",
	SUM           = "SUM OF",
	DIFF          = "DIFF OF",
	MUL           = "PRODUKT OF",
	DIV           = "QUOSHUNT OF",
	MOD           = "MOD OF",
	MAX           = "BIGGR OF",
	MIN           = "SMALLR OF"
}

types = {
	FLOAT   = 0,
	INTEGER = 1,
	STRING  = 2
}

local function main(code)
	local tokens = lex(code)
	outputChatBox(inspect(tokens))
end

local exampleCode = [[
HAI 1.2
BTW This is the famous 'Hello World' program
VISIBLE "Hello World"
KTHXBYE
]]
main(exampleCode)