GLEIP = GLEIP or {}
GLEIP.Modules = GLEIP.Modules or {}
GLEIP.Modules.Modules = GLEIP.Modules.Modules or {}
GLEIP.Modules.BasePath = "gleipnir/gamemode/modules"
local FileTable = {}
local LoadedTemp = {}
function GLEIP.Modules:TraverseDir(dir, parent)
	local TemporaryDirectoryStorage = {}
	local CachedFileFind = file.FindInLua(dir)
	for v,k in pairs(CachedFileFind) do
		if (!string.match(k, "^(%p+)") and (!string.match(k, '([~])$'))) then
			if(string.GetExtensionFromFilename(self:SanitizePath(dir)..k) != "lua"--[[file.IsDir("../gamemodes/"..self:SanitizePath(dir)..k)]]) then
				TemporaryDirectoryStorage[k] = { path = self:SanitizePath(dir)..k}
				--TemporaryDirectoryStorage[k]['parent'] = parent
				TemporaryDirectoryStorage[k]['dir'] = self:TraverseDir(self:SanitizePath(dir)..k.."/*", TemporaryDirectoryStorage[k])
				GLEIP.Util:Print(self:SanitizePath(dir)..k.." is a dir")
			else
				GLEIP.Util:Print(self:SanitizePath(dir)..k.." is not a dir")
				-- Probaly the worst way you can do a regular expression, sue me
				TemporaryDirectoryStorage[string.gsub(k, ".lua", "")] = {file = k, path = self:SanitizePath(dir)..k}
			end
		end
	end
	return TemporaryDirectoryStorage
end

local function PreliminaryModuleLoad( fileInfo, id, parent )
	local LoadedTemp = parent or LoadedTemp
	_G['MODULE'] = {}
	GLEIP.Util:Print("About to include "..fileInfo.dir.info.path)
	include(tostring(fileInfo.dir.info.path))
	LoadedTemp[id] = _G['MODULE']
	_G['MODULE'] = nil
	LoadedTemp[id].Name = LoadedTemp[id].Name or "No name"
	LoadedTemp[id].id = id
	LoadedTemp[id].path = fileInfo.path
	return LoadedTemp[id]
end

local function CheckDependencies( moduleTable )
	for v,k in pairs( moduleTable.Dependencies ) do
		if( LoadedTemp[ k.name ] != nil )  then
			GLEIP.Util:Print("Found dependency "..tostring(k.name).." of "..tostring(moduleTable.Name))
		else
			GLEIP.Util:Print("Failed to find "..tostring(moduleTable.Name).."'s dependency "..tostring(k.name))
			return false
		end
	end
	return true
end

function GLEIP.Modules:ConvertPT(path)
	local path = string.gsub(path, "gleipnir/gamemode/modules/", "")
	local Last = FileTable
	local ExplodedPath = string.Explode("/", path)
	for v,k in pairs(ExplodedPath) do
		local LuaRemoved = string.gsub(k, ".lua", "")
		if(Last != nil and Last[k] != nil and Last[k].dir != nil) then
			Last = Last[k].dir
			if(v == #ExplodedPath) then
				return Last
			end
		elseif(Last[LuaRemoved] != nil and (Last[LuaRemoved].file != nil or Last[k].file != nil)) then
			-- It's a file, they can't contain stuff
			return Last[LuaRemoved]
		else
			GLEIP.Util:Print("FAILED TO FIND PATH: "..path)
			return {}, false
		end

	end
end
local function SanxboxIt(functionz, tablz)
	local sandbox = {}
	setmetatable(sandbox, {
		__index = function(table, key)
			return _G['key']
		end,
		__newindex = function(table,key, value)
			tablz[key] = value
		end
	})
end

callBack = {}
local function LoadModule(moduleTable, parent)
	if(CheckDependencies(moduleTable)) then

--[[		local moduleEnv = setmetatable({
			moduleLoadedCallback = function(self, name) -- If the module is already loaded, it is instantly called
		
			end
		}, {__index = _G})]]

		_G['MODULE'] = moduleTable
		local parent = parent or GLEIP.Modules.Modules
		--[[
		_G['MODULE'].GetSub = function(self, sub)
			print("In GetSub")
			if(self.Subs == nil or self.Subs[sub] == nil) then GLEIP.Util:Print("Module "..self.Name.." tried to load a submodule "..tostring(sub).." which is not specified") return false end
			print("Passed if check")	
			local directory = GLEIP.Modules:ConvertPT(moduleTable.path)[sub]
			PrintTable(directory)
			local ptable = PreliminaryModuleLoad(directory, sub, self)
			ptable.parent = self
			LoadModule(ptable, self)
			-- CONTINUE HERE, for some reason does not end up in self

		end]]
		moduleTable.callOnLoad = function(self, mod, callback)
			MsgN("parent[mod]: "..tostring(parent[mod]))
			MsgN("mod: "..tostring(mod))
			if GLEIP.Modules.Modules[mod] ~= nil then
				MsgN("Calling callback for "..mod)
				callback(GLEIP.Modules.Modules[mod])
			else
				callBack[mod] = callBack[mod] or {}
				table.insert(callBack[mod], callback)
			end
		end
		if(SERVER) then
			AddCSLuaFile(moduleTable.path.."/info.lua")
		end
		for v,k in pairs(moduleTable.Files.Shared) do
			if(SERVER) then
				AddCSLuaFile(moduleTable.path.."/"..k)
			end
			local status,err = pcall(CompileFile(moduleTable.path.."/"..k,moduleTable.path.."/"..k))
			if err then
				print(k.." failed: "..tostring(err))
			end
			include(moduleTable.path.."/"..k)
		end
		if(SERVER) then
			for v,k in pairs(moduleTable.Files.Server) do
				local status, err = pcall(CompileFile(moduleTable.path.."/"..k,moduleTable.path.."/"..k))
				if err then
					print(k.." failed: "..tostring(err))
				end
				--include(moduleTable.path.."/"..k)
			end
		end
		for v,k in pairs(moduleTable.Files.Client) do
			if(CLIENT) then
				status, err = pcall(CompileFile(moduleTable.path.."/"..k, moduleTable.path.."/"..k))
				print(k.." lolled this, status: "..tostring(status).." error: "..tostring(err))
			else
				AddCSLuaFile(moduleTable.path.."/"..k)
			end
		end
		parent[moduleTable.id] = moduleTable
		if(type(parent[moduleTable.id].Init) == "function") then
			parent[moduleTable.id]:Init()
		end
		if callBack[moduleTable.id] then
			for k,v in pairs(callBack[moduleTable.id]) do
				MsgN("Callin callback "..moduleTable.id)
				v(moduleTable)
				v = nil
			end
		end
		_G['MODULE'] = nil
		return parent[moduleTable.id]
	end
end


function GLEIP.Modules:LoadModules()
	FileTable = self:TraverseDir(self.BasePath.."/*")
	PrintTable(FileTable)
	local PreliminaryModuleLoad = PreliminaryModuleLoad -- Small speed boost
	function TraverseModules(files)
		for v,k in pairs(files) do
			print(v)
			if type(v) == "table" then
				print("Chekzing "..tostring(v))
				PrintTable(v)
			else
				print("Chekzing "..tostring(v))
			end
			if(k.dir ~= nil and k.dir.info  ~= nil and k.dir.info.path ~= nil) then
				print("Loading "..tostring(k).."    LAL    "..tostring(v))
				PreliminaryModuleLoad(k, v)
			end
			--print("k.dir: "..tostring(k.dir).." k.dir.info: "..tostring(k.dir.info).." k.dir.info.path: "..tostring(k.dir.info.path))
			--[[if(k.dir) then
				for j,z in pairs(k.dir) do
					if(z.dir) then
						print("In k.dir loop: "..tostring(j))
						PrintTable(z)
						print("I'm now sending this "..tostring(j).." that is of type: "..type(z))
						if type(z) == "table" then
							print("It be a tablz, and containnz ")
							PrintTable(z)
						end
						TraverseModules(z)
					end
				end
			end]]
		end
	end
	TraverseModules(FileTable)
	for v,k in pairs(LoadedTemp) do
		LoadModule(k)
	end
	
end

function GLEIP.Modules:SanitizePath( path )
	return string.gsub(path, "([\*]+)", "")
end

-- Everything builds on events :P
GLEIP.Call = GLEIP.Call or hook.Call
hook.Call = function(name, gm, ...)
	if(GLEIP.Modules.Modules) then
		local results = {}
		for v,k in pairs(GLEIP.Modules.Modules) do
			if(k[name]) then
				local time = SysTime()
				status, error = pcall(k[name], k, ...)
				if not (name == "HUDShouldDraw" or name == "ShouldDrawLocalPlayer" or name == "CalcView" or name == "PostDrawOpaqueRenderables") and GLEIP.Debug then
					results[v] = SysTime()-time
				end
				if(status == false) then
					ErrorNoHalt(error)
					Msg("\n")
				end
				if(error != nil) then
					return error
				end
			end
		end
		for k,v in pairs(results) do
			print("For hook "..name.." in mod "..k.." it took "..tostring(v))
		end
	end
	return GLEIP.Call(name, gm, ...)
end

