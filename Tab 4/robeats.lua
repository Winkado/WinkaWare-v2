--[[
    RoBeats (hi Spotco :D)
    rAnDoM FuNcTiOn nAmEs mAkE It hArD To aUtO PlAy (only for retards)

    By Spencer#0003
]]

local game = game;
local getinfo = getinfo;
local getconstant = getconstant;
local getconstants = getconstants;
local getprotos = getprotos;
local getreg = getreg;
local getupvalue = getupvalue;
local getupvalues = getupvalues;
local makefolder = makefolder;
local is_synapse_function = is_synapse_function;
local loadfile = loadfile;
local pcall = pcall;
local rawget = rawget;
local table_find = table.find;
local typeof = typeof;

-- Install Belkworks and load library
if (not NEON) then
    if (not isfile("neon/init.lua")) then
        makefolder("neon");
        writefile("neon/init.lua", game:HttpGet("https://raw.githubusercontent.com/belkworks/neon/master/init.lua"));
    end;
    pcall(loadfile("neon/init.lua"));
end;

local quick = NEON:github("belkworks", "quick");
local library = NEON:github("LegoHacks", "Utilities", "UI.lua");

-- Auto updater
local client = quick.Service.Players.LocalPlayer;
local mainClient, spRemoteEvent, gameJoin, lobbyJoin; do
    -- Scan registry for dependencies
    local hookedBlob = false;
    for i, v in next, getreg() do
        if (typeof(v) == "function" and not is_synapse_function(v) and #getupvalues(v) == 1 and getinfo(v).short_src:find("LocalMain")) then
            -- local mainClient = getupvalue(getupvalue(v, 1), 8);
            local mainClosure = getupvalue(v, 1);
            mainClient = quick.find(getupvalues(mainClosure), function(upv)
                return (typeof(upv) == "table" and rawget(upv, "_evt"));
            end);
        elseif (typeof(v) == "table" and rawget(v, "new") and table_find(getconstants(v.new), "on_songkey_pressed")) then
            songModule = v;
        elseif (typeof(v) == "table" and rawget(v, "playerblob_has_vip_for_current_day")) then
            v.playerblob_has_vip_for_current_day = function()
                return library.flags.unlockAll;
            end;
            hookedBlob = true;
        end;

        if (mainClient and songModule and hookedBlob) then break end;
    end;

    -- Get other dependencies from main client script
    spRemoteEvent = mainClient._evt;
    gameJoin = mainClient._game_join;
    lobbyJoin = mainClient._lobby_join;
end;

-- Force load lobby to prevent auto updater errors
if (not client.Character) then
    lobbyJoin:setup_lobby();
    lobbyJoin:start_lobby();
end;

-- Obtain even more dependencies
local gameLocal = getupvalue(gameJoin.load_game, 9);
local trackSystem = getupvalue(gameLocal.new, 18);
local networkIds = quick.findWhere(getupvalues(spRemoteEvent.server_generate_encodings), {EVT_TEST = 0});

local lobbyLocal = quick.find(getupvalues(lobbyJoin.setup_lobby), function(upv)
    return (typeof(upv) == "table" and rawget(upv, "destroy_unstarted_game_and_exit_to_lobby"));
end);

local gearStats = quick.find(getupvalues(trackSystem.new), function(upv)
    return (typeof(upv) == "table" and rawget(upv, "get_note_times"));
end);

local scoreManager = quick.find(getupvalues(gameLocal.new), function(upv)
    return (typeof(upv) == "table" and rawget(upv, "new") and table_find(getconstants(upv.new), "get_registered_hits"));
end);

local spUtil = quick.find(getupvalues(lobbyLocal.transition_local_camera_cframe), function(upv)
    return (typeof(upv) == "table" and rawget(upv, "angles_vec3_lv"));
end);

local getNoteTimes = quick.find(spUtil, function(func)
    return (typeof(func) == "function" and #getupvalues(func) == 1 and #getconstants(func) == 4 and getinfo(func).name:match("^_%w+"));
end);

local songDatabase = quick.find(getupvalues(gameJoin.start_game_tutorial_mode), function(upv)
    return (typeof(upv) == "table" and rawget(upv, "new") and table_find(getconstants(upv.new), "name_to_key"));
end).singleton();

-- Enums
local note_score_enums = {
    PERFECT = getNoteTimes(spUtil, 1, 0, 0, 2, 0);
    GREAT = getNoteTimes(spUtil, 1, 0, 2, 0);
    OKAY = getNoteTimes(spUtil, 1, 1, 0);
    MISS = 0;
};

local trackSystemProtos = getprotos(trackSystem.new);
local track_system_enums = {
    GET_TRACK = getconstant(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "NoteIndexNone"));
    end), 1);

    GET_NOTES = getinfo(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "set_note_colors"));
    end)).name;

    GET_SLOT = getconstant(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "TrackSystem:update"))
    end), 11);

    TRACK_SYSTEM = getconstant(quick.find(getprotos(gameLocal.new), function(proto)
        return (table_find(getconstants(proto), "control_just_pressed"));
    end), 31);

    TEST_HIT = getconstant(quick.find(trackSystemProtos, function(proto)
        local constants = getconstants(proto);
        return (table_find(constants, "count") and table_find(constants, "get") and table_find(constants, "get_track_index"));
    end), 10);

    HIT = getconstant(quick.find(trackSystemProtos, function(proto)
        local constants = getconstants(proto);
        return (table_find(constants, "count") and table_find(constants, "get") and table_find(constants, "get_track_index"));
    end), 11);

    TEST_RELEASE = getconstant(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "release"));
    end), 6);

    RELEASE = getconstant(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "release"));
    end), 7);

    SHOULD_REMOVE = getconstant(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "TrackSystem:update"));
    end), 7);

    TEARDOWN = getinfo(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "teardown"));
    end)).name;

    UPDATE = getinfo(quick.find(trackSystemProtos, function(proto)
        return (table_find(getconstants(proto), "TrackSystem:update"));
    end)).name;
};

trackSystemProtos = nil;

for _, v in next, track_system_enums do
    if (typeof(v) ~= "string" or v:sub(1, 1) ~= "_") then
        client:Kick("\nAuto updater failed.");
        break;
    end;
end;

-- Hook network to prevent bans
local oldSend = spRemoteEvent.fire_event_to_server;
spRemoteEvent.fire_event_to_server = function(self, remote, ...)
    if (remote == networkIds.EVT_EventReport_ClientExploitDetected) then
        return;
    end;

    return oldSend(self, remote, ...);
end;

-- Hook score manager & delta randomiser
local noteBounds = { -- this probably doesn't work at all but it's a start
    PERFECT = { Low = 180, High = 500 };
    GREAT = { Low = 750, High = 950 };
    OKAY = { Low = 1500, High = 2080 };
};

local scoreManagerNew = scoreManager.new;
scoreManager.new = function(...)
    local random = Random.new();
    local sManager = scoreManagerNew(...);
    local postData = getinfo(quick.find(sManager, function(func)
        return (getinfo(func).name:match("^_%w+"));
    end)).name;
    
    local oldPostData = sManager[postData];
    sManager[postData] = function(self, ...)
        local args = {...};

        if (library.flags.autoPlayer and args[5].Delta) then
            local bounds; do
                for i, v in next, noteBounds do
                    if (library.flags.noteType == note_score_enums.PERFECT) then
                        bounds = noteBounds.PERFECT;
                    elseif (library.flags.noteType == note_score_enums.GREAT) then
                        bounds = noteBounds.GREAT;
                    elseif (library.flags.noteType == note_score_enums.OKAY) then
                        bounds = noteBounds.OKAY;
                    end;

                    if (bounds) then break end;
                end;
            end;

            if (bounds) then
                args[5].Delta = (library.flags.randomisation and -(random:NextNumber(bounds.Low, bounds.High) / 10) or args[5].Delta);
            end;
        end;

        return oldPostData(self, unpack(args));
    end;

    return sManager;
end;

-- Get note type
local note_result_map = {
    note_score_enums.PERFECT;
    note_score_enums.GREAT;
    note_score_enums.OKAY;
    note_score_enums.MISS;
};

local function getNoteType()
    local r = Random.new();

    for i, v in next, {library.flags.perfect, library.flags.great, library.flags.okay} do
        if (r:NextNumber(0, 100) <= v) then
            library.flags.noteType = note_result_map[i];
            return library.flags.noteType;
        end;
    end;

    return note_score_enums.MISS;
end;

-- Autoplay function
local cachedGearStats = {};
local function autoPlay(info)
    local ts = info[track_system_enums.TRACK_SYSTEM](info);
    local slot = info[track_system_enums.GET_SLOT]();
    local notes = getupvalue(ts[track_system_enums.GET_NOTES], 3);

    for i = 1, notes:count() do
        local noteType = getNoteType();
        local note = notes:get(i);
        local track = note:get_track_index();
        local testResult, testScoreResult, testTimeResult = note[track_system_enums.TEST_HIT](note, info);
        local releaseResult, releaseScoreResult, releaseTimeResult = note[track_system_enums.TEST_RELEASE](note, info);

        if (library.flags.autoPlayer and not note[track_system_enums.SHOULD_REMOVE](note, slot)) then
            local currentTrack = ts[track_system_enums.GET_TRACK](ts, track);

            if (testResult and testScoreResult == noteType) then
                currentTrack:press();
                note[track_system_enums.HIT](note, slot, testScoreResult, i, testTimeResult);

                if (not releaseTimeResult) then
                    currentTrack:release();
                end;
            elseif (releaseResult and releaseScoreResult == noteType) then
                currentTrack:release();
                note[track_system_enums.RELEASE](note, slot, releaseScoreResult, i, releaseTimeResult);
            end;
        end;
    end;
end;

-- Hook tracksystem
local trackSystemNew = trackSystem.new;
trackSystem.new = function(self, gameData, ...)
    -- local playerData = quick.findWhere(gameData._players._slots._table, {_id = client.UserId});

    -- if (playerData) then
    --     local perfect, great, okay = gearStats:get_note_times(playerData._gear_stats);
    --     cachedGearStats.Perfect = perfect;
    --     cachedGearStats.Great = great;
    --     cachedGearStats.Okay = okay;
    -- end;

    local ts = trackSystemNew(self, gameData, ...);
    local oldUpdate = ts[track_system_enums.UPDATE];

    ts[track_system_enums.UPDATE] = function(...)
        autoPlay(getupvalue(oldUpdate, 3));
        return oldUpdate(...);
    end;

    return ts;
end;

local roBeats = library:CreateWindow("RoBeats"); do
    roBeats:AddToggle({
        text = "Enabled";
        flag = "autoPlayer";
    });

    roBeats:AddToggle({
        text = "Delta Randomiser (WIP)";
        flag = "randomisation";
    });

    roBeats:AddSlider({
        text = "Perfect";
        flag = "perfect";
        min = 0;
        max = 100;
    });

    roBeats:AddSlider({
        text = "Great";
        flag = "great";
        min = 0;
        max = 100;
    });

    roBeats:AddSlider({
        text = "Okay";
        flag = "okay";
        min = 0;
        max = 100;
    });

    roBeats:AddSlider({
        text = "Miss";
        flag = "miss";
        min = 0;
        max = 100;
    });

    local storedSongs = {};
    -- this code is bad and rushed but it's not my problem :sunglasses:
    roBeats:AddButton({
        text = "Unlock all songs";
        callback = function()
            if (library.flags.unlockAll) then return end; library.flags.unlockAll = true;
            local defaultSong = songDatabase:name_to_key("MondayNightMonsters1");

            local oldNew = songModule.new;
            songModule.new = function(...)
                local songSystem = oldNew(...);
                local oldPressed = songSystem.on_songkey_pressed;

                songSystem.on_songkey_pressed = function(self, song)
                    local actualSong = tonumber(song);
                    song = defaultSong;

                    local title = songDatabase:get_title_for_key(actualSong);

                    if (not storedSongs[title]) then
                        for i, v in next, getreg() do
                            if (typeof(v) == "table" and rawget(v, "HitObjects") and v.AudioFilename == title) then
                                storedSongs[title] = v;
                                break;
                            end;
                        end;
                    end;

                    getupvalue(songDatabase.add_key_to_data, 1):add(song, storedSongs[title]);
                    return oldPressed(self, song);
                end;

                return songSystem;
            end;
        end;
    });
end;

library:Init();