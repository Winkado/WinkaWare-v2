--[[ ==========  Executed Check  ========== ]]

if getgenv().evov2 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "EvoV2",
        Text = "EvoV2 has already been executed in this game."
    })
    return
end

getgenv().evov2 = true

--[[ ==========  Compatibility  ========== ]]

local missing = {}

local funcs = {
    ["Drawing.new"] = {},
    ["getconnections"] = {},
    ["getconstants"] = { "debug.getconstants" },
    ["getgc"] = { "get_gc_objects" },
    ["getinfo"] = { "debug.getinfo" },
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

local function parsefunc(str)
    local parsed, index = getgenv(), 1
    while parsed and type(parsed) == "table" do
        local dotindex = str:find("%.")
        parsed = parsed[str:sub(index, dotindex and dotindex - 1 or #str - index + 1)]
        if dotindex then
            str = str:sub(dotindex + 1)
            index = str:find("%.") or 1
        end
    end
    return type(parsed) == "function" and parsed or false
end

for used, aliases in next, funcs do
    local hasfunc = parsefunc(used) ~= false
    if hasfunc == false then
        for _, alias in next, aliases do
            local parsedfunc = parsefunc(alias)
            if parsedfunc then
                getgenv()[used] = parsedfunc
                hasfunc = true
                break
            end
        end
        if hasfunc == false then
            missing[#missing + 1] = used
        end
    end
end

if #missing > 0 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "EvoV2",
        Text = "Your exploit does not have all the functions required to run this script.\nMissing: " .. table.concat(missing, ", ")
    })
    return
end

--[[ ==========  Custom Functions  ========== ]]

local heartbeat = game:GetService("RunService").Heartbeat

getgenv().fastwait = function(duration)
	local elapsed = 0
	while elapsed < duration do
		elapsed = elapsed + heartbeat:Wait()
	end
end

getgenv().deepcopy = function(tab, new)
    for i, v in next, tab do
        new[i] = type(v) == "table" and {} or v
        if type(v) == "table" then
            deepcopy(v, new[i])
        end
    end
end

getgenv().fast_wait = fastwait -- for the scripts I haven't updated yet

--[[ ==========  Game Loader  ========== ]]

local custom_theme, default_theme = getgenv().evo_v2_theme, { -- for the scripts I haven't updated yet
    background_main = Color3.fromRGB(22, 22, 22),
    background_folders = Color3.fromRGB(28, 28, 28),
    background_items = Color3.fromRGB(48, 48, 48),
    background_highlight = Color3.fromRGB(62, 62, 62),
    foreground_main = Color3.fromRGB(235, 235, 235),
    foreground_accent = Color3.fromRGB(180, 180, 180),
    foreground_folders = Color3.fromRGB(210, 210, 210),
    foreground_placeholder = Color3.fromRGB(136, 136, 136),
    accent_main = Color3.fromRGB(35, 110, 200),
    scroll_main = Color3.fromRGB(100, 100, 100),
    separator_main = Color3.fromRGB(140, 140, 140),
    hover_main = Color3.fromRGB(48, 48, 48),
    hover_items = Color3.fromRGB(72, 72, 72),
    press_main = Color3.fromRGB(50, 50, 50),
    press_items = Color3.fromRGB(86, 86, 86),
    toggle_disabled = Color3.fromRGB(82, 82, 82),
    toggle_enabled = Color3.fromRGB(35, 110, 200),
    slider_highlight = Color3.fromRGB(82, 82, 82)
}

if custom_theme then
    for i, v in next, default_theme do
        if custom_theme[i] then
            default_theme[i] = custom_theme[i]
        end
    end
end

local chosengame = ({
    [3233893879] = "badbusiness.lua",
    [292439477] = "phantomforces.lua",
    [2377868063] = "strucid.lua",
    [443406476] = "project_lazarus.lua"
})[game.PlaceId]

getgenv().evo_v2_theme, getgenv().script_context = default_theme, chosengame -- for the scripts I haven't updated yet

if chosengame then
    loadstring(game:HttpGetAsync("https://projectevo.xyz/script/games/" .. chosengame))()
else
	game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "EvoV2",
        Text = "EvoV2 does not have this game"
    })
end