local e = {}
local fmod = math.fmod
local abs = math.abs
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local floor = math.floor
local rad = math.rad

e.GetBackdrop = function()
	return {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = 1,
		edgeSize = 16,
		insets = {top = 5, right = 5, left = 5, bottom = 5}
	}
end
e.windowWidth = 662
e.windowHeight = 548
e.boardWidth = 554
e.boardHeight = 464
e.artPath = "Interface\\AddOns\\Resize\\Textures\\"

local t = CreateFrame("Frame", nil, UIParent)
t:SetWidth(e.windowWidth)
t:SetHeight(e.windowHeight)
t:SetPoint("Center")
t:EnableMouse(true)
t:SetToplevel(true)
t:Show()
t:SetHitRectInsets(0, 0, - 14, 0)
local g = t:GetFrameLevel()
local n = e.GetBackdrop()
n.edgeFile = e.artPath.."windowBorder"
--n.bgFile = e.artPath.."windowBackground"
n.edgeSize = 32
n.tileSize = 64
n.insets.right = 3
t:SetBackdrop(n)
t:SetBackdropColor(.7, .7, .7, 1)
t:SetMovable(true)
t:RegisterForDrag("LeftButton")

t:SetScript("OnDragStart", function(e)
	e:StartMoving()
end)

t:SetScript("OnDragStop", function(e)
	e:StopMovingOrSizing()
end)

local l = CreateFrame("Frame", nil, t)
l:SetHeight(128)
l:SetPoint("Topleft", t, "Topleft", 32, 32)
l:SetPoint("Topright", t, "Topright", 0, 32)

local n = l:CreateTexture(nil, "OVERLAY")
n:ClearAllPoints()
n:SetPoint("Topright", l, "Topleft", 16, 0)
n:SetWidth(64)
n:SetHeight(64)
n:SetTexture(e.artPath.."windowCoverLeft")

local n = l:CreateTexture(nil, "OVERLAY")
n:SetPoint("Topleft", l, "Topright",  - 44, 0)
n:SetWidth(64)
n:SetHeight(64)
n:SetTexture(e.artPath.."windowCoverRight")

local n = l:CreateTexture(nil, "ARTWORK")
n:SetPoint("Topleft", 16, 0)
n:SetWidth(t:GetWidth() - 92)
n:SetHeight(64)
local a = n:GetWidth()
a = fmod(a, 128) / 128 + floor(a / 128)
n:SetTexCoord(0, a, 0, 1)
n:SetTexture(e.artPath.."windowCoverCenter", true)
t.topCover = n

local o = CreateFrame("Frame", nil, t)
o:SetPoint("Bottomright", 0, 0)
o:SetWidth(32)
o:SetHeight(32)
o:Show()
o:SetFrameLevel(g + 7)
o:EnableMouse(true)

o:SetScript("OnMouseDown", function(o, n)
	if n == "RightButton" then
		t:SetWidth(e.windowWidth)
		t:SetHeight(e.windowHeight)
	else
		t.resizing = true
		t:StartSizing("Right")
	end
end)

o:SetScript("OnMouseUp", function(e)
	t.resizing = nil
	t:StopMovingOrSizing()
end)

local n = o:CreateTexture(nil, "Artwork")
n:SetPoint("Topleft", 0, 0)
n:SetWidth(32)
n:SetHeight(32)
n:SetTexture(e.artPath.."resize")
--n:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
t:SetMaxResize(e.windowWidth * 1.5, e.windowHeight * 1.5)
t:SetMinResize(e.windowWidth / 2, e.windowHeight / 2)
t:SetResizable(true)

t:SetScript("OnSizeChanged", function(o)
	local n = o:GetWidth()
	local n = n / e.windowWidth
	t.gameBoardContainer:SetScale(n)
	local e = e.windowHeight * n
	o:SetHeight(e)
	local n = t.topCover
	n:SetWidth(t:GetWidth() - 92)
	local e = n:GetWidth()
	e = fmod(e, 128) / 128 + floor(e / 128)
	n:SetTexCoord(0, e, 0, 1)
end)

local n = CreateFrame("ScrollFrame", nil, t)
n:SetWidth(e.boardWidth)
n:SetHeight(e.boardHeight)
n:SetPoint("Topleft", 53,  - 70)
n:Show()

local r = CreateFrame("Frame", nil, t)
r:SetWidth(e.boardWidth)
r:SetHeight(e.boardHeight)
r:ClearAllPoints()
r:Show()
r:EnableMouse(true)
r:EnableMouseWheel(true)
r:SetPoint("Center")
local l = e.GetBackdrop()
r:SetBackdrop(l)
r:SetBackdropColor(0, 0, 0, 0)
r:SetBackdropBorderColor(1, 0, 0, 0)
n:SetScrollChild(r)
t.gameBoardContainer = n

local se = 260
local be = - 248

r:SetScript("OnUpdate", function(n, o)
	local s, a = GetCursorPosition()
	local g, h, S, u = n:GetRect()
	local c = n:GetEffectiveScale()
	if n.fineX then
		if abs(n.fineX - s) < 5 and abs(n.fineY - a) < 5 then
			return
		end
		n.fineX = nil
		n.fineY = nil
	end
	local l, o
	l = s / c - g
	if l >= 0 and l <= S then
		o = a / c - h
		if o >= 0 and o <= u then
			if n.lastX ~= l or n.lastY ~= o then
				local c = e.boardWidth / 2
				local s = e.boardHeight - 16 - 20
				local a, h = l, o
				local S = a - c
				local a =  - (h - s)
				local h = se ^ 4
				local u = (be * S ^ 2)
				local a = 2 * a * (se ^ 2)
				local u = h - be * (u + a)
				local h, a
				if u > 0 then
					local e = sqrt(u)
					a =  - atan(((se ^ 2) - e) / (be * S))
					if(S < 0)then
						a = a - 180
					end
					h = fmod(a + 360, 360)
				end
				n.lastX = l
				n.lastY = o
				N = h or(N)
				if N > 25 and N < 155 then
					if(N < 90)then
						N = 25
					else
						N = 155
					end
				end
				local h = (se * cos(rad(N)))
				local S = (se * sin(rad(N)))
				local a = (e.boardWidth / 2)
				local u = (e.boardHeight - 16) - 20
				local g, o, l, n
				for e = 1, 4 do
					n = ((e - 1) / 10 * 1 / 1.85)
					o = a + h * n
					l = u + S * n + .5 * be * (n ^ 2)
					if e == 4 then
						ue = fmod(atan2(s - l + 4, c - o) + 180, 360)
					end
				end
			end
		end
	end
end)