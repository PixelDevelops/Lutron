local StarterGui = game:GetService("StarterGui")

if getgenv().LutronExists == true then
	StarterGui:SetCore("SendNotification", {
		Title = "Already executed!",
		Text = "Can't open Lutron? The keybind is [RIGHT ALT].",
		Duration = 5
	})
end

getgenv().LutronExists = true

local Missing = {}
local ScriptFunctions = {
	["Drawing.new"] = {},
	["firesignal"] = {},
	["firetouchinterest"] = {},
	["getconnections"] = {},
	["getconstants"] = { "debug.getconstants" },
	["getgc"] = { "get_gc_objects" },
	["getinfo"] = { "debug.getinfo" },
	["getloadedmodules"] = { "get_loaded_modules", "getmodules", "get_modules" },
	["getupvalue"] = { "debug.getupvalue" },
	["getupvalues"] = { "debug.getupvalues" },
	["hookmetamethod"] = {},
	["httprequest"] = { "http_request", "request", "syn.request" },
	["islclosure"] = { "is_l_closure" },
	["newcclosure"] = { "new_c_closure" },
	["require"] = {},
	["setconstant"] = { "debug.setconstant" },
	["setthreadidentity"] = { "setidentity", "setcontext", "setthreadcontext", "syn.set_thread_identity" },
	["setupvalue"] = { "debug.setupvalue" },
	["traceback"] = { "debug.traceback" }
}

local function ParseFunction(str)
	local Parsed, Index = getfenv(), 1
	while Parsed and type(Parsed) == "table" do
		local dotIndex = str:find("%.")
		Parsed = Parsed[str:sub(Index, dotIndex and dotIndex - 1 or #str - Index + 1)]
		if dotIndex then
			str = str:sub(dotIndex + 1)
			Index = str:find("%.") or 1
		end
	end
	return type(Parsed) == "function" and Parsed or false
end

for Used, Aliases in next, ScriptFunctions do
	local HasFunction = ParseFunction(Used) ~= false
	if HasFunction == false then
		for _, Alias in next, Aliases do
			local ParsedFunction = ParseFunction(Alias)
			if ParsedFunction then
				ParseFunction()[Used] = ParsedFunction
				HasFunction = true
				break
			end
		end
		if HasFunction == false then
			Missing[#Missing + 1] = Used
		end
	end
end

if #Missing > 0 then
	StarterGui:SetCore("SendNotification", {
		Title = "Exploit unsupported",
		Text = "Your exploit is not supported. Lutron may not run properly.",
		Duration = 5
	})
end

local SupportedGames = ({
	
})[game.PlaceId]

if SupportedGames then
	loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/PixelDevelops/Lutron/main/"..SupportedGames))()
else
	StarterGui:SetCore("SendNotification", {
		Title = "Game not supported",
		Text = "Lutron does not support this game, sorry.",
		Duration = 5
	})
	
	return
end
