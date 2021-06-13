local ProgressBar = {}
local images = require('images')
local _BarBGPath = string.format('%sassets/%s.bmp', windower.addon_path, "simplebarbg")
local _BarFGPath = string.format('%sassets/%s.bmp', windower.addon_path, "barfg")
local _BarGlowPath = string.format('%sassets/%s.bmp', windower.addon_path, "glow")
function ProgressBar.Get()

    local this = {
        ["BarBG"] = {},
        ["Fill"] = {},
        ["Percent"] = 0,
        ["Glow"] = {},
    }

    function this:New(settings)

        local this = {}
        setmetatable(this, self)
        self.__index = self
        this["BarBG"] = images.new(settings)
        this["BarBG"]:path(_BarBGPath)
        this["BarBG"]:color(255, 255, 255)
        this["Glow"] = images.new(settings)
        this["Glow"]:path(_BarGlowPath)
        this["Glow"]:color(255,255,255)
        this["Fill"] = images.new(settings)
        this["Fill"]:path("/")
        this["Fill"]:color(100, 0, 0)
        this["Fill"]:width(0)
        this["Fill"]:height(5)
        --this["Fill"]:show()

        return this

    end

    function this:SetFillColor(color)

        self["Fill"]:color(color.r, color.g, color.b)

    end

    function this:ApplyTPColors(tp)

        --tp stuff
        if(tp<=1000)then
            self:SetFillColor({r=100, g=0, b=0})
        elseif(tp>1000 and tp<2000)then
            self:SetFillColor({r=0, g=100, b=0})
        elseif(tp>2000 and tp<=3000)then
            self:SetFillColor({r=0, g=0, b=100})
        end

    end

    function this:SetPercent(percent)
        if(percent==0)then
            self["Percent"] = percent
            self["Fill"]:width(percent)
        else
            self["Percent"] = percent
            self["Fill"]:width(percent-6)
        end
        --if its 100 can assume its tp - doing tp% should probably be a seperate function 
        if(percent>100 and percent <101)then
            self["Percent"] = percent
            self["Fill"]:width(100-6) -- clamp
        elseif(percent>102)then
            self["Percent"] = percent
            self["Fill"]:width((percent/30)-6)
        end

    end

    function this:Show()

        self["BarBG"]:show()
        self["Fill"]:show()
        self["Glow"]:show()

    end

    function this:Hide()

        self["BarBG"]:hide()
        self["Fill"]:hide()
        self["Glow"]:hide()

    end

    function this:Destroy()
        self["BarBG"]:hide()
        self["Fill"]:hide()
        self["Glow"]:hide()
        self["BarBG"]:destroy()
        self["Fill"]:destroy()
        self["Glow"]:destroy()
        this = nil

    end

    function this:SetPos(pos)

        if(pos)then

            self["BarBG"]:pos(pos.x, pos.y)
            self["Fill"]:pos(pos.x+3, pos.y+3)
            self["Glow"]:pos(pos.x-1, pos.y-1)

        end

    end

    return this

end

return ProgressBar.Get()