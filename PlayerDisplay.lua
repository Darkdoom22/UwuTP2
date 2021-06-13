
local PlayerDisplay = {}
local texts = require('texts')
require('strings')

function PlayerDisplay.Get()

    local PlayerDisplay = {
        ["Settings"] = {
            ["pos"] = {--[[xy]]},
            ["text"] = {--[[font, size, alpha, red, green, blue, stroke{alpha, red, green, blue, width}, flags{bold}]]},
            ["bg"] = {--[[bg{alpha, red, green, blue}]]},
            ["flags"] = {--[[draggable]]},
        },
        ["TextObject"] = {},
    }

    function PlayerDisplay:ColorText(color, text)
        if color then
            return string.format("\\cs(%s,%s,%s)%s", color.red, color.green, color.blue, text)
        end
    end

    function PlayerDisplay:Show()
        self["TextObject"]:visible(true)       
    end

    function PlayerDisplay:Hide()
        self["TextObject"]:visible(false)
    end

    function PlayerDisplay:Offset(pos)
       -- print(pos.x, pos.y)
        --self["Settings"]["pos"].x = pos.x
        --self["Settings"]["pos"].y = pos.y
        self["TextObject"]:pos(pos.x, pos.y)
    end

    function PlayerDisplay:Destroy()
        self = {}
    end

    function PlayerDisplay:New(settings, text)
        local this = {}
        setmetatable(this, self)
        self.__index = self
        --self["Settings"] = settings
        this["Settings"] = settings
        this["TextObject"] = texts.new(settings)
        this["TextObject"]:text(text)

        return this
    end

    return PlayerDisplay

end

return PlayerDisplay.Get()