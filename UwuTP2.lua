_addon.name = "UwuTP2"
_addon.author = "Uwu/Darkdoom"
_addon.version = "1.0.1 - 6/15/2021"

local resources = require('resources')
local packets = require('packets')
local files = require('files')
local texts = require('texts')
local bit = require('bit')
require('strings')
require('tables')
require('functions')
require('math')
require('coroutine')
require('pack')
local progressbar = require('progressbar')

local _DefaultSettings = {
    ["pos"] = {
        ["x"] = 1259,
        ["y"] = 403
    },
    ["text"] = {
        ["stroke"] = {
            ["alpha"] = 200,
            ["red"] = 11,
            ["green"] = 15,
            ["blue"] = 16,
            ["width"] = 2.0
        },
        ["size"] = 11,
        ["alpha"] = 255,
        ["red"] = 119,
        ["green"] = 247,
        ["blue"] = 237,
        ["font"] = "IBM Plex Mono",
    },
    ["bg"] = {
        ["alpha"] = 0,
        ["red"] = 3,
        ["green"] = 1,
        ["blue"] = 1,
    },
    ["flags"] = {
        ["bold"] = true
    }
}

--change a bunch of references and remove this whenevs
defaults = {}
defaults.pos = {}
defaults.stroke = {}
defaults.flags = {}
defaults.flags.bold = true
defaults.pos.x = 1259 
defaults.pos.y = 403  
defaults.text = {}
defaults.text.font = 'IBM Plex Mono'
defaults.text.size = 11
defaults.text.alpha = 255
defaults.text.red = 119
defaults.text.green = 247
defaults.text.blue = 237
defaults.text.stroke = {}
defaults.text.stroke.alpha = 200
defaults.text.stroke.width = 2.0
defaults.text.stroke.red = 11
defaults.text.stroke.blue = 16
defaults.text.stroke.green = 15
defaults.bg = {}
defaults.bg.alpha = 0
defaults.bg.red = 3
defaults.bg.green = 1
defaults.bg.blue = 1

_DefaultSettings["Enemy"] = {
    ["pos"] = {
        ["x"] = 775,
        ["y"] = 219
    },
    ["flags"] = {
        ["bold"] = true
    },
    ["text"] = {
        ["font"] = "IBM Plex Mono",
        ["size"] = 12,
        ["alpha"] = 255,
        ["red"] = 20,
        ["green"] = 177,
        ["blue"] = 250,
        ["stroke"] = {
            ["alpha"] = 200,
            ["red"] = 11,
            ["green"] = 15,
            ["blue"] = 16,
            ["width"] = 2.0
        },
    },
    ["bg"] = {
        ["alpha"] = 0,
        ["red"] = 3,
        ["green"] = 1,
        ["blue"] = 1
    }
}

_DefaultSettings["MoveList"] = {
    ["pos"] = {
        ["x"] = 1015,
        ["y"] = 219
    },
    ["flags"] = {
        ["bold"] = true,
    },
    ["text"] = {
        ["font"] = "IBM Plex Mono",
        ["size"] = 11,
        ["alpha"] = 255,
        ["red"] = 82,
        ["green"] = 245,
        ["blue"] = 130,
        ["stroke"] = {
            ["alpha"] = 200,
            ["red"] = 11,
            ["blue"] = 16,
            ["green"] = 15,
            ["width"] = 2.0
        },
    },
    ["bg"] = {
        ["alpha"] = 0,
        ["red"] = 3,
        ["green"] = 1,
        ["blue"] = 1
    }
}

local _ImageSettings = {
    ["alpha"] = 255,
    ["color"] = {
        ["alpha"] = 230,
        ["red"] = 255,
        ["green"] = 255,
        ["blue"] = 255,
    }, 
    ["pos"] = {
        ["x"] = 1259,
        ["y"] = 403,
    },
    ["size"] = {
        ["width"] = 16 * 4,
        ["height"] = 16 * 4,
    },
    ["draggable"] = false,
}

local PlayerDisplay = require('PlayerDisplay')

local _MobAbilities = setmetatable(resources.monster_abilities, {__index = function(t, k)
    return {name = "Aoe Melee/Unknown"}
end})

local _Spells = setmetatable(resources.spells, {__index = function(t, k)
    return {name = "Unknown Spell"}
end})

local _PlayerAbilities = setmetatable(resources.job_abilities, {__index = function(t, k)
    return {name = "Unknown Ability"}
end})

local _WeaponSkills = setmetatable(resources.weapon_skills, {__index = function(t, k)
    return {name = "Unknown WS"}
end})

local _Items = setmetatable(resources.items, {__index = function(t, k)
    return {name = "Unknown Item"}
end})

resources = nil

local UwuTP = {
    ["MoveList"] = T{},
    ["MoveListDisplay"] = T{},
    ["PlayerDisplays"] = T{},
    ["PlayerStats"] = T{},
    ["MobDisplay"] = T{},
    ["MobStats"] = T{},
}

local _Colors = {
    ["Green"] = {r=74, g=255, b=139},
    ["Yellow"] = {r=250, g=246, b=4},
    ["Red"] = {r=100, g=0, b=0},
    ["LightBlue"] = {r=57, g=244, b=254},
    ["Orange"] = {r=254, g=148, b=46},
    ["Gold"] = {r=234, g=193, b=92},
    ["Purple"] = {r=231, g=46, b=255}
}

local function BuildTargetDisplayString(mobInfo)

    if(not mobInfo)then
        return
    end

    local displayString = "%s\n":format(mobInfo.Name).."[HP%] "..tostring(mobInfo.Hpp):lpad(' ', 6).."\n\n"
    .."[D]".."%d":format(tostring(mobInfo.Distance)):lpad(' ', 9).."\n".."%s":format(mobInfo.Enmity or "").."\n"..tostring(mobInfo.Action)
    
   -- local displayString = "%s\n[HP%] %s\n\n[D]%d\n%s\n%s":format(mobInfo.Name, mobInfo.Hpp, mobInfo.Distance)
    
    return displayString

end

local function BuildDisplayString(playerInfo)

    if(not playerInfo)then
        return
    end

    if(playerInfo.Id == windower.ffxi.get_player().id)then
        local displayString = "%s":format(playerInfo.Name).." %s\n":format(playerInfo.InMenu).."[HP%] "..tostring(playerInfo.Hpp):lpad(' ', 2).."\n\n"
    .."[MP%] "..tostring(playerInfo.Mpp):lpad(' ', 2).."\n\n".."[TP] "..tostring(playerInfo.Tp):lpad(' ', #tostring(playerInfo.Tp)+1).."\n\n"..tostring(playerInfo.Action)
        return displayString
    else
        local displayString = "%s":format(playerInfo.Name).." %s\n":format(playerInfo.InMenu).."[HP%] "..tostring(playerInfo.Hpp):lpad(' ', 2).."\n\n"
        .."[MP%] "..tostring(playerInfo.Mpp):lpad(' ', 2).."[D]":lpad(' ',5).."%d":format(tostring(playerInfo.Distance)).."\n\n".."[TP] "..tostring(playerInfo.Tp):lpad(' ', #tostring(playerInfo.Tp)+1).."\n\n"..tostring(playerInfo.Action)
        return displayString
    end

end

function UwuTP:PopulateBoxes()

    local partyInfo = windower.ffxi.get_party()
    local xOffset = 0
    local yOffset = 0
    local pbarYOffset = 0

    local partyOrdered = T{}
    for k,v in pairs(partyInfo) do
        if(k=="p0")then
            rawset(partyOrdered, 1, v)
        elseif(k=="p1")then
            rawset(partyOrdered, 2, v)
        elseif(k=="p2")then
            rawset(partyOrdered, 3, v)
        elseif(k=="p3")then
            rawset(partyOrdered, 4, v)
        elseif(k=="p4")then
            rawset(partyOrdered, 5, v)
        elseif(k=="p5")then
            rawset(partyOrdered, 6, v)
        end
    end

    for k,v in ipairs(partyOrdered) do

        if(type(v) == "table" and v.mob)then

            local playerInfo = T{
                ["Name"] = v.name,
                ["Hpp"] = v.hpp,
                ["Mpp"] = v.mpp,
                ["Tp"] = v.tp,
                ["Action"] = "",
                ["Zone"] = v.zone,
                ["Id"] = v.mob.id,
                ["Distance"] = v.mob.distance:sqrt(),
                ["HPBar"] = {},
                ["MPBar"] = {},
                ["TPBar"] = {},
                ["ActionBar"] = {},
                ["CurrentSpellCastLength"] = 0,
                ["SpellFinishTime"] = 0,
                ["PartySlot"] = 0,
                ["InputDelayLength"] = 0,
                ["InputDelayFinishTime"] = 0,
                ["InMenu"] = "",
            }

            --make 2 rows of 3
            if(#UwuTP["PlayerStats"] == 3)then
                defaults.pos.x = 1085
                defaults.pos.y = defaults.pos.y + 185
            end

            --I genuinely don't understand *how* this is offseting things properly, but it does
            --probably some metatable weirdness with the psuedo-OO constructor and the object it's inheriting from? idek
            --if it works!
            local hpBar = progressbar:New(_ImageSettings)
            hpBar:SetPos({x = defaults.pos.x + xOffset, y = defaults.pos.y + pbarYOffset + 45})
            hpBar:Show()
            hpBar:SetPercent(playerInfo["Hpp"])

            playerInfo["HPBar"] = hpBar

            local mpBar = progressbar:New(_ImageSettings)
            mpBar:SetPos({x = defaults.pos.x + xOffset, y = defaults.pos.y + pbarYOffset + 85})
            mpBar:Show()
            mpBar:SetPercent(playerInfo["Hpp"])

            playerInfo["MPBar"] = mpBar

            local tpBar = progressbar:New(_ImageSettings)
            tpBar:SetPos({x = defaults.pos.x + xOffset, y = defaults.pos.y + pbarYOffset + 125})
            tpBar:Show()
            tpBar:SetPercent(playerInfo["Hpp"])

            playerInfo["TPBar"] = tpBar

            local playerDisplay = PlayerDisplay:New(defaults, BuildDisplayString(playerInfo))
            rawset(UwuTP["PlayerDisplays"], v.name, playerDisplay)
            UwuTP["PlayerDisplays"][v.name]:Offset({x = defaults.pos.x + xOffset, y = defaults.pos.y + yOffset})
            
            local actionBar = progressbar:New(_ImageSettings)
            actionBar:SetPos({x = defaults.pos.x + xOffset/100, y = defaults.pos.y + pbarYOffset + 165})
            actionBar:Show()
            actionBar:SetPercent(0)

            playerInfo["ActionBar"] = actionBar

            xOffset = 175
            playerDisplay:Show()

            UwuTP["PlayerStats"]:insert(playerInfo)

        end

    end

end


local _CurrentPartySize = 0
--reset everything
local function OnPartySizeChanged(size)
    _CurrentPartySize = size

    defaults.pos.x = 1259
    defaults.pos.y = 403

    for k,v in pairs(UwuTP["PlayerStats"]) do
        for k2,v2 in pairs(UwuTP["PlayerDisplays"]) do
            if(k2 == v.Name)then
            v["HPBar"]:Destroy()
            v["MPBar"]:Destroy()
            v["TPBar"]:Destroy()
            v["ActionBar"]:Destroy()
            v2["TextObject"]:destroy()         
            end
        end  
    end
    UwuTP["PlayerStats"] = T{}
    UwuTP["PlayerDisplays"] = T{}

    UwuTP:PopulateBoxes()

end

function UwuTP:UpdateMoveList()
    
    if(self["MoveListDisplay"]:visible() == true)then

        local str = "~[ MoveList ]~"

        for _,v in pairs(self["MoveList"]) do
            str = "%s\n %s":format(str, v:lpad(' ', v:len()+2))
        end

        if(#self["MoveList"] > 15)then
            self["MoveList"] = T{}
        end

        self["MoveListDisplay"]:text(str)
    end

end

function UwuTP:UpdateTargetStatus()

    local target = windower.ffxi.get_mob_by_target('t') or nil

    if(target)then
        self["MobStats"]["Target"]["Name"] = target.name
        self["MobStats"]["Target"]["Hpp"] = target.hpp
        self["MobStats"]["Target"]["Id"] = target.id
        self["MobStats"]["Target"]["Distance"] = target.distance:sqrt()
        self["MobDisplay"]["TextObject"]:visible(true)
        self["MobStats"]["Target"]["HPBar"]:Show()
        self["MobStats"]["Target"]["HPBar"]:SetPercent(target.hpp)

        if(target.hpp >= 75)then
            self["MobStats"]["Target"]["HPBar"]:SetFillColor(_Colors["Green"])
        elseif(target.hpp < 75 and target.hpp >= 35)then
            self["MobStats"]["Target"]["HPBar"]:SetFillColor(_Colors["Yellow"])
        elseif(target.hpp < 35)then
            self["MobStats"]["Target"]["HPBar"]:SetFillColor(_Colors["Red"])
        end

        self["MobStats"]["Target"]["ActionBar"]:Show()

        local targetDisplayString = BuildTargetDisplayString(self["MobStats"]["Target"])
        self["MobDisplay"]["TextObject"]:text(targetDisplayString)

        self["MoveListDisplay"]:visible(true)
    else
        self["MoveListDisplay"]:visible(false)
        self["MobDisplay"]["TextObject"]:visible(false)
        self["MobStats"]["Target"]["HPBar"]:Hide()
        self["MobStats"]["Target"]["ActionBar"]:Hide()
        self["MoveList"] = T{}
    end

end

function UwuTP:UpdatePlayerStatus()
   
    local partyInfo = windower.ffxi.get_party()
    local partyOrdered = T{}

    if(_CurrentPartySize ~= partyInfo.party1_count)then
        OnPartySizeChanged(partyInfo.party1_count)
    end

    for k,v in pairs(partyInfo) do
        if(k=="p0")then
            rawset(partyOrdered, 1, v)
        elseif(k=="p1")then
            rawset(partyOrdered, 2, v)
        elseif(k=="p2")then
            rawset(partyOrdered, 3, v)
        elseif(k=="p3")then
            rawset(partyOrdered, 4, v)
        elseif(k=="p4")then
            rawset(partyOrdered, 5, v)
        elseif(k=="p5")then
            rawset(partyOrdered, 6, v)
        end
    end

    for k,v in pairs(partyOrdered) do

        if(type(v) == "table")then

            for k2,v2 in pairs(UwuTP["PlayerStats"]) do

                if(v.mob and v2.Id == v.mob.id)then

                    v2.Distance = v.mob.distance:sqrt() 
                    v2.Zone = v.zone
                    v2.Hpp = v.hpp
                    v2.Mpp = v.mpp
                    v2.Tp = v.tp
                    v2.PartySlot = k
                    v2.HPBar:SetPercent(v.hpp)
                    --print(v.mob.status)
                    if(v.mob.status == 4)then
                        v2.InMenu = "(In Menu)"
                    else
                        v2.InMenu = ""
                    end

                    if(v2.Hpp >= 75)then
                        v2.HPBar:SetFillColor(_Colors["Green"])
                    elseif(v2.Hpp < 75 and v2.Hpp >= 35)then
                        v2.HPBar:SetFillColor(_Colors["Yellow"])
                    elseif(v2.Hpp < 35)then
                        v2.HPBar:SetFillColor(_Colors["Red"])
                    end
                   
                   v2.MPBar:SetPercent(v.mpp)

                    if(v2.Mpp >= 75)then
                        v2.MPBar:SetFillColor(_Colors["Green"])
                    elseif(v2.Mpp < 75 and v2.Mpp >= 35)then
                        v2.MPBar:SetFillColor(_Colors["Yellow"])
                    elseif(v2.Mpp < 35)then
                        v2.MPBar:SetFillColor(_Colors["Red"])
                    end

                   v2.TPBar:SetPercent(v.tp)

                    if(v2.Tp < 1000)then
                        v2.TPBar:SetFillColor(_Colors["Red"])
                    elseif(v2.Tp >= 1000 and v2.Tp < 2000)then
                        v2.TPBar:SetFillColor(_Colors["Orange"])
                    elseif(v2.Tp > 2000 and v2.Tp < 3000)then
                        v2.TPBar:SetFillColor(_Colors["Gold"])
                    elseif(v2.Tp == 3000)then
                        v2.TPBar:SetFillColor(_Colors["Purple"])
                    end

                    for k2,v3 in pairs(UwuTP["PlayerDisplays"]) do

                        if(k2 == v2.Name)then
        
                            local updatedDisplay = BuildDisplayString(v2)
                            v3["TextObject"]:text(updatedDisplay)
                            v3["TextObject"]:update()
    
                        end
    
                    end 

                end  

            end

        end

    end

end

local function ActionString(param, tparam, category)
    
    local str = " "

    if param and tparam and category then

        --magic

        if category == 8 then 

            if(_Spells[tparam].name:len()<10)then
                str = "[MA] %s":format(_Spells[tparam].name)
            else
                str = "[MA] %s.":format(_Spells[tparam].name:sub(0, 10))
            end
            return str

        --player ws

        elseif category == 7 and tparam > 0 and tparam <= 255  then
            
            if(_WeaponSkills[tparam].name:len()<10)then
                str = "[WS] %s":format(_WeaponSkills[tparam].name)
            else
                str = "[WS] %s.":format(_WeaponSkills[tparam].name:sub(0, 10))
            end
            return str

        --trust ws or mob ws

        elseif category == 7 and tparam > 255 then
            
            if(_MobAbilities[tparam].name:len()<10)then
                str = "[WS] %s":format(_MobAbilities[tparam].name)
            else
                str = "[WS] %s.":format(_MobAbilities[tparam].name:sub(0, 10))
            end
            return str

        --finish categories        

        elseif category == 4 or category == 3 then

            coroutine.sleep(1)
            str = " "
            return str
          
            
        elseif category == 11 then

            if(_MobAbilities[param].name:len()<10)then
                str = "[End] %s":format(_MobAbilities[param].name)
            else
                str = "[End] %s.":format(_MobAbilities[param].name:sub(0,10))
            end
            return str

        else 
            coroutine.sleep(1)
            return str

        end

    end

end

local _CurTime = os.clock()

function UwuTP:HandleActionEvent(packet)

    if(packet)then

        local actor = windower.ffxi.get_mob_by_id(packet:unpack('I', 6))
        local recast, targetId = packet:unpack('b32b32', 15, 7)
        local enemyTarget = windower.ffxi.get_mob_by_id(targetId)
        local category, param = packet:unpack('b4b16', 11, 3)
        local t1param = packet:unpack('b17', 27, 4)/4
   
        if(actor and actor.id == self["MobStats"]["Target"]["Id"])then

            self["MobStats"]["Target"]["Enmity"] = "[Enmity] %s":format(enemyTarget.name)
            if(self["MobStats"]["Target"]["Enmity"]:len()>20)then
                self["MobStats"]["Target"]["Enmity"] = "%s%s":format(self["MobStats"]["Target"]["Enmity"]:sub(0,20),".")
            end

            local actionString = ActionString(param, t1param, category)
            self["MobStats"]["Target"]["Action"] = actionString

            if(actionString ~= " " and (category == 8 or category == 6 or category == 11))then 
                if(category == 8)then
                    self["MoveList"]:insert(_Spells[t1param].name)
                elseif(category == 11)then
                    self["MoveList"]:insert(_MobAbilities[param].name)   
                end
            end

            if(category == 8)then

                _CurTime = os.clock()
                self["MobStats"]["Target"]["CurrentSpellCastLength"] = _Spells[t1param].cast_time
                self["MobStats"]["Target"]["SpellFinishTime"] = _CurTime + self["MobStats"]["Target"]["CurrentSpellCastLength"]

            elseif(category == 4)then

                self["MobStats"]["Target"]["CurrentSpellCastLength"] = 0
                self["MobStats"]["Target"]["SpellFinishTime"] = 0

            end

            --ghettoooo
            if(category == 11)then
                coroutine.sleep(3)
                self["MobStats"]["Target"]["Action"] = ""
            end

        end

        for _,v2 in pairs(self["PlayerStats"]) do

            if(actor and v2.Id == actor.id)then

                v2["Action"] = ActionString(param, t1param, category)

                if(category == 8)then

                    _CurTime = os.clock()
                    v2["CurrentSpellCastLength"] = _Spells[t1param].cast_time
                    v2["SpellFinishTime"] = _CurTime + v2["CurrentSpellCastLength"]

                elseif(category == 4)then
                    _CurTime = os.clock()
                    v2["CurrentSpellCastLength"] = 0  
                    v2["SpellFinishTime"] = 0 
                    v2["InputDelayLength"] = 3
                    v2["InputDelayFinishTime"] = _CurTime + v2["InputDelayLength"]

                elseif(category == 3)then
                    _CurTime = os.clock() 
                    v2["InputDelayLength"] = 2
                    v2["InputDelayFinishTime"] = _CurTime + v2["InputDelayLength"]

                elseif(category == 5 or category == 6 or category == 2 or category == 14 or category == 15)then
                    _CurTime = os.clock()
                    v2["InputDelayLength"] = 1
                    v2["InputDelayFinishTime"] = _CurTime + v2["InputDelayLength"]

                end
                    
                if(category == 11)then
                    coroutine.sleep(3)
                    v2["Action"] = ""
                end

            end

            for k2,v3 in pairs(self["PlayerDisplays"]) do

                if(actor and k2 == actor.name and v2.Name == actor.name)then

                    local updatedDisplay = BuildDisplayString(v2)
                    v3["TextObject"]:text(updatedDisplay)
                    v3["TextObject"]:update()

                end

            end 

        end

    end

end

windower.register_event('load', function()

    UwuTP:PopulateBoxes()

    UwuTP["MobDisplay"] = PlayerDisplay:New(_DefaultSettings["Enemy"], "")
   -- UwuTP["MobDisplay"]:Show()

    local target = windower.ffxi.get_mob_by_target('t') or nil
    local mobInfo = T{
        ["Name"] = target and target.name or "",
        ["Hpp"] = target and target.hpp or 0,
        ["Action"] = " ",
        ["Id"] = target and target.id or 0,
        ["Distance"] = target and target.distance:sqrt() or 0,
        ["HPBar"] = {},
        ["ActionBar"] = {},
        ["CurrentSpellCastLength"] = 0,
        ["SpellFinishTime"] = 0,
        ["Enmity"] = "[Enmity] "
    }

    local hpBar = progressbar:New(_ImageSettings)
    hpBar:SetPos({x = _DefaultSettings["Enemy"]["pos"]["x"], y = _DefaultSettings["Enemy"]["pos"]["y"] + 50})
    hpBar:Show()
    hpBar:SetPercent(mobInfo["Hpp"])

    mobInfo["HPBar"] = hpBar
    
    local actionBar = progressbar:New(_ImageSettings)
    actionBar:SetPos({x = _DefaultSettings["Enemy"]["pos"]["x"], y = _DefaultSettings["Enemy"]["pos"]["y"] + 130})
    actionBar:Show()
    actionBar:SetPercent(0)

    mobInfo["ActionBar"] = actionBar
    rawset(UwuTP["MobStats"], "Target", mobInfo)
    --UwuTP["MobStats"]:insert(mobInfo)


    UwuTP["MoveListDisplay"] = texts.new(_DefaultSettings["MoveList"])
    UwuTP["MoveListDisplay"]:text("~[ MoveList ] ~ ")
   -- UwuTP["MoveListDisplay"]:visible(true)


end)

windower.register_event('incoming chunk', function(id, org, _, _)

    if(id==0x28)then

        UwuTP:HandleActionEvent(org)

    end

end)

windower.register_event('zone change', function()
    --silly entity structs take *FOREVER* to load on zone 
    coroutine.sleep(10)
    local partyInfo = windower.ffxi.get_party()
    OnPartySizeChanged(partyInfo.party1_count)

end)

windower.register_event('prerender', function()

    UwuTP:UpdatePlayerStatus()
    UwuTP:UpdateTargetStatus()
    UwuTP:UpdateMoveList()

    if(UwuTP["MobStats"]["Target"]["CurrentSpellCastLength"] > 0)then
        
        _CurTime = os.clock()
        local difference = UwuTP["MobStats"]["Target"]["SpellFinishTime"] - _CurTime
        
        if(difference>0)then
            UwuTP["MobStats"]["Target"]["ActionBar"]:Show()
            local percent = (UwuTP["MobStats"]["Target"]["CurrentSpellCastLength"]/4) / difference * 100
          --  print(percent)
            if(percent<=100)then
                UwuTP["MobStats"]["Target"]["ActionBar"]:SetPercent(percent)
            end
        else
            UwuTP["MobStats"]["Target"]["ActionBar"]:Hide()
            UwuTP["MobStats"]["Target"]["ActionBar"]:SetPercent(0)
        end

    else
        UwuTP["MobStats"]["Target"]["ActionBar"]:Hide()

    end

    for _,v in pairs(UwuTP["PlayerStats"]) do

        if(v["CurrentSpellCastLength"] > 0)then
            _CurTime = os.clock()
            local difference = v["SpellFinishTime"] - _CurTime
            if(difference>0)then
                v["ActionBar"]:Show()
                --no way to determine fast cast for other players so.. yea
                local percent = (v["CurrentSpellCastLength"]/4)/difference * 100
               -- print(difference)
              --  print("%s%%":format(percent))
                if(percent<=100)then
                    v["ActionBar"]:SetPercent(percent)
                end
            else
                if(v["ActionBar"])then
                    v["ActionBar"]:Hide()
                    v["ActionBar"]:SetPercent(0)
                end
            end
        else
            if(v["ActionBar"])then
                v["ActionBar"]:Hide()
                v["ActionBar"]:SetPercent(0)
            end
        end

        if(v["InputDelayLength"] > 0)then
            _CurTime = os.clock()
            local difference = v["InputDelayFinishTime"] - _CurTime
           -- print(v["InputDelayLength"])
           -- print("Input delay: %s":format(difference))
            if(difference > 0)then
                v["ActionBar"]:Show()
                local percent = (v["InputDelayLength"]/4/difference) * 100
             --   print("%s%%":format(percent))
                if(percent<=100)then
                    v["ActionBar"]:SetPercent(percent)
                    v["Action"] = "Input Delay: %d":format(difference)
                end
            else
                if(v["ActionBar"])then
                    v["ActionBar"]:Hide()
                    v["ActionBar"]:SetPercent(0)
                    v["Action"] = ""
                    v["InputDelayFinishTime"] = 0
                    v["InputDelayLength"] = 0
                end
            end
        end

    end

end)

