GLEIP = GLEIP or {}
GLEIP.Modules = GLEIP.Modules or {}
GLEIP.Modules.Modules = GLEIP.Modules.Modules or {}
GLEIP.Modules.BasePath = "gleipnir/gamemode/modules"
local FileTable = {}
local LoadedTemp = {}

function GLEIP.Modules:SanitizePath( path )
	return string.gsub(path, "([\*]+)", "")
end

function GLEIP.Modules:TraverseDir(dir, parent)
	local TemporaryDirectoryStorage = {}
	local CachedFileFind = file.FindInLua(dir)
	for v,k in pairs(CachedFileFind) do
		if (!string.match(k, "^(%p+)") and (!string.match(k, '([~])$'))) then
			if(string.GetExtensionFromFilename(self:SanitizePath(dir)..k) != "lua"--[[file.IsDir("../gamemodes/"..self:SanitizePath(dir)..k)]]) then
				TemporaryDirectoryStorage[k] = { path = self:SanitizePath(dir)..k}
				--TemporaryDirectoryStorage[k]['parent'] = parent
				TemporaryDirectoryStorage[k]['dir'] = self:TraverseDir(self:SanitizePath(dir)..k.."/*", TemporaryDirectoryStorage[k])
				--GLEIP.Util.print(self:SanitizePath(dir)..k.." is a dir")
			else
				--GLEIP.Util.print(self:SanitizePath(dir)..k.." is not a dir")
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
	--GLEIP.Util.print("About to include "..fileInfo.dir.info.path)
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
			GLEIP.Util.print("Found dependency "..tostring(k.name).." of "..tostring(moduleTable.Name))
		else
			GLEIP.Util.print("Failed to find "..tostring(moduleTable.Name).."'s dependency "..tostring(k.name))
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
			GLEIP.Util.print("FAILED TO FIND PATH: "..path)
			return {}, false
		end

	end
end
local moduleEnv = setmetatable({}, { -- This is where all your modules belong to us. (It's possible this is the worst performance hog, ever.)
		__index = function(table, key)
			-- This lets us use util functions
			return GLEIP.Util[key] or _G[key]
		end,
	})

callBack = {}

local function compileAndPcall(name, path)
	local compiled = CompileFile(path)
	if not compiled then return false end
	local err, msg = pcall(setfenv(compiled, moduleEnv))
	if !err then
		Error(name.." failed: "..msg) -- I'm just gonna kill everything here
		return false
	end
end
local function LoadModule(moduleTable, parent)
	if(CheckDependencies(moduleTable)) then
		_G['MODULE'] = moduleTable
		-- You can use this from inside modules to get a call when a module is loaded.
		-- Only useful during the init phase.
		moduleTable.callOnLoad = function(self, mod, callback)
			if GLEIP.Modules.Modules[mod] ~= nil then
				if GLEIP.Debug then
					MsgN("Calling callback for "..mod)
				end
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
			compileAndPcall(moduleTable.path.."/"..k,moduleTable.path.."/"..k)
			--include(moduleTable.path.."/"..k)
		end
		if(SERVER) then
			for v,k in pairs(moduleTable.Files.Server) do
				compileAndPcall(moduleTable.path.."/"..k,moduleTable.path.."/"..k)
				--include(moduleTable.path.."/"..k)
			end
		end
		for v,k in pairs(moduleTable.Files.Client) do
			if(CLIENT) then
				compileAndPcall(moduleTable.path.."/"..k, moduleTable.path.."/"..k)
			else
				AddCSLuaFile(moduleTable.path.."/"..k)
			end
		end
		if(type(GLEIP.Modules.Modules[moduleTable.id].Init) == "function") then
			GLEIP.Modules.Modules[moduleTable.id]:Init()
		en
		if callBack[moduleTable.id] then
			for k,v in pairs(callBack[moduleTable.id]) do
				MsgN("Callin callback "..moduleTable.id)
				v(moduleTable)
				v = nil
			end
		end
		_G['MODULE'] = nil
		return GLEIP.Modules.Modules[moduleTable.id]
	end
end

-- The function that makes it all load and run ;) (Should only be called by Gleipnir)
function GLEIP.Modules:LoadModules()
	FileTable = self:TraverseDir(self.BasePath.."/*")
	--PrintTable(FileTable)
	local PreliminaryModuleLoad = PreliminaryModuleLoad -- Small speed boost
	function TraverseModules(files)
		for v,k in pairs(files) do
			print(v)
			if type(v) == "table" then
				--print("Chekzing "..tostring(v))
				--PrintTable(v)
			else
				--print("Chekzing "..tostring(v))
			end
			if(k.dir ~= nil and k.dir.info  ~= nil and k.dir.info.path ~= nil) then
				--print("Loading "..tostring(k).."    LAL    "..tostring(v))
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

-- Everything builds on events :P
-- It has some simple profiling, enable it by setting GLEIP.Debug to true
-- A small performance boost can be had by commenting out debug
-- Perhaps some postprocessing tool ran ontop of this?
local oldcall = hook.Call
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
				if(status == false) then -- If the module fails to often, maybe notice admins and nil the module?
					ErrorNoHalt(error)
					Msg("\n")
				elseif(error != nil) then
					return error
				end
			end
		end
		for k,v in pairs(results) do
			print("For hook "..name.." in module "..k.." it took "..tostring(v))
		end
	end
	return oldcall(name, gm, ...)
end

