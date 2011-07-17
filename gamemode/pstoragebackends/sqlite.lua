-- When reading this function, don't forget the scoping rules.
-- self in the main function, is not the same as self in fetch or filter.
function pennis:select(item)
	return setmetatable({}, {
		__index = {
			fetch = function(self)
				print("SELECT * FROM "..item..";")
				if self._filterExp then print("SELECT * FROM "..item.." WHERE "..self._filterExp..";") end
				query = "SELECT * FROM "..item
				if self._filterExp then query = query.." WHERE "..self._filterExp end
				query = query..";"
				print(query)
				result = sql.Query(query)
				-- If no result, end it here
				if not result then return false end
				-- Let's filter this shit
--[[				if self._filter then
					local filtered = {}
					for k,v in pairs(result) do
						_G.row = v
						if(self._filter()) then
							table.insert(filtered, v)
						end
						_G.row = nil
					end
					return filtered
				end]]
				return result
			end,
			filter = function(self, filterExp)
				self._filter = CompileString("return "..filterExp, filterExp)
				self._filterExp = filterExp
				return self
			end
		}})
end

function pennis:delete(tbl, row)
	print(row.id)
	PrintTable(row)
	sql.Query("DELETE FROM "..tbl.." WHERE id == "..sql.SQLStr(tostring(row.id))..";")
	if sql.LastError() then print("sql.LastError(): "..sql.LastError()) end
end

-- This is fine as a single function, even though a fancy API as for select would be cool.
function pennis:insert(tbl, data)
	if not pennis.cache[tbl] then
		if pennis.DEBUG then
			local debugz = debug.getinfo(2)
			local createTableD = debug.getinfo(self.createTable)
			MsgN("PENNIS: You fucked up, you have not run pennis:createTable. You can find it at line "..tostring(createTableD.linedefined).." in file "..createTableD.short_src)
			MsgN("PENNIS: The failing call was from "..debugz.short_src.." on line "..tostring(debugz.currentline))
			return false
		else return false end
	end
	local query = "INSERT INTO "..tbl.." ("
	local values = {}
	for k,v in pairs(data) do
		local valid = pennis:validateType(pennis.cache[tbl][k], v)
		if not valid then
			if pennis.DEBUG then
				-- TODO: Cleanup
				MsgN("PENNIS: The data passed in from "..debug.getinfo(2).short_src..":"..tostring(debug.getinfo(2).currentline).." was invalid.")
				return false
			else
				return false
			end
		end
		table.insert(values, sql.SQLStr(valid))
		query = query..k..","
	end
	query = string.gsub(query, ",$", "")
	query = query..") VALUES ("
	for k,v in pairs(values) do
		query = query..v..","
	end
	query = string.gsub(query, ",$", "")
	query = query..");"
	if pennis.DEBUG then MsgN("PENNIS: Generated: "..query) end
	sql.Query(query)
	if pennis.DEBUG and sql.LastError() then MsgN("PENNIS sql.LastError(): "..sql.LastError()) end
end

-- This should always be called before you use the table
function pennis:createTable(name, structure)
	local query = "CREATE TABLE IF NOT EXISTS "..name.." ("
	local values = {}
	for k,v in pairs(structure) do
		query = query.." "..k.." "..v..","
	end
	query = query.." id INTEGER PRIMARY KEY AUTOINCREMENT"
	query = query..");"
	--query = string.gsub(query, ",%);", ");")
	-- Hopefully, this should cause no errors
	sql.Query(query)
	if pennis.DEBUG then MsgN("Generated query: "..query) end
	--if pennis.DEBUG and sql.LastError() then print("sql.LastError: "..sql.LastError()) end
	-- This will overwrite anything with the same name, be careful ;)
	pennis.cache[name] = structure 
end
