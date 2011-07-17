local backend = "sqlite" -- If you find a reason to have this in the pennis table, feel free to share

pennis = {}
pennis.DEBUG = true -- TODO: Turn off for production
-- pennis cache structure sample:
-- {
-- 	score = {
-- 		steamid = "varchar(20)", -- Sorry, i cba to check how long a steamid can be
--		points = "int"
-- 	}
-- }
pennis.cache = {}

pennis.validationHandlers = {
	varchar = function(length, value)
		if string.len(tostring(value)) <= length then
			return tostring(value)
		else
			return false -- Maybe chop it off instead?
		end
	end,
	int = function(value)
		return tonumber(value)
	end
}
-- t: type
-- v: value
function pennis:validateType(t, v)
	if t == nil then return end
	-- Varchar is a tad special :(
	-- TODO: Fix fricking hack
	local varchar = string.match(t, "varchar%((%d*)%)")
	print(varchar)
	if varchar ~= nil then
		return pennis.validationHandlers.varchar(tonumber(varchar), v)
	end
	if pennis.validationHandlers[t] then
		return pennis.validationHandlers[t](v)
	else
		print("There is no validation handler for type "..t)
	end
end

-- TODO: When CompileFile arrives in a stable release, sandbox this.
include("pstoragebackends/"..backend..".lua")
