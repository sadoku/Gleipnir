local CHAT = {}

function CHAT:Init()
	self.Text = {}
	self.TextEntry = vgui.Create("DTextEntry", self)
	self.TextEntry:SetAllowNonAsciiCharacters(true)
	self.TextEntry.OnEnter = function()
		chat.AddText(LocalPlayer(), Color(255,255,255), ": ", self.TextEntry:GetValue())
		self:Hide()
		self.TextEntry:Clear()
	end
	self.TextEntry.Paint = function() -- I know self is an arg, but i want to keep the old one
		surface.SetFont("Default")
		local w,h = surface.GetTextSize(self.TextEntry:GetValue())
		draw.RoundedBox(2,2,2, w+2, self.TextEntry:GetTall(), Color(50,50,50,255))
		self.TextEntry:DrawTextEntryText(Color(200,200,200,240), self.TextEntry.m_colHighlight, self.TextEntry.m_colCursor)
	end
	self.TextEntry.Clear = function(self)
		self:SetValue("")
		self:SetCaretPos(0)
	end
	self.pnlCanvas = vgui.Create("Panel", self)
	self.pnlCanvas.Paint = function()
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("ScoreboardText")
		for k,v in pairs(self.Text) do
			local left = 0
			for e,a in pairs(v) do
				if type(a) == "string" then
					local w,h = surface.GetTextSize(a)
					surface.SetTextPos(left, 12*k)
					surface.DrawText(a)
					left = left + w
				elseif type(a) == "table" and a.r then
					surface.SetTextColor(a.r, a.g, a.b, 255)
				elseif type(a) == "Player" then
					local teamColor = team.GetColor(a:Team())
					local w,h = surface.GetTextSize(a:Name())
					surface.SetTextColor(teamColor.r, teamColor.g, teamColor.b, 255)
					surface.SetTextPos(left, 12*k)
					surface.DrawText(a:Name())
					left = left + w
				else
					print(type(a))
				end
			end
		end
	end
end

function CHAT:AddText(...)
	local textToAdd = {...}
	table.insert(self.Text, textToAdd)
end

function CHAT:Show()
	self.TextEntry:SetVisible(true)
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	self:MakePopup()
	self.TextEntry:RequestFocus()
	gui.EnableScreenClicker(true)
end

function CHAT:PerformLayout()
	self.TextEntry:SetPos(2, self:GetTall()-self.TextEntry:GetTall()-2)
	self.TextEntry:SetSize(self:GetWide()-4,20)

	self.pnlCanvas:SetPos(0,0)
	self.pnlCanvas:SetSize(self:GetWide(),self:GetTall()-12)
end

function CHAT:Hide()
	self.TextEntry:SetVisible(false)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	gui.EnableScreenClicker(false)
end

function CHAT:Paint()
	surface.SetDrawColor(50,50,50,100)
	surface.DrawRect(0,0,self:GetWide(), self:GetTall())
	return true
end

function MODULE:Init()
	vgui.Register("ChatPanel", CHAT, "EditablePanel")
	self.chatp = vgui.Create("ChatPanel")
	self.chatp:SetSize(ScrW()*0.5,300)
	self.chatp:SetPos(6,ScrH()-300)
	self.chatp:Hide()
	chat.AddText = function(...)
		self.chatp:AddText(...)
	end
end

function MODULE:ChatText(plyi, plyname, text, mType)
	chat.AddText(Color(50,50,150), text)
	return true
end

function MODULE:PlayerBindPress(ply, bind, press)
	if string.find(bind, "messagemode") then
		self.chatp:Show()
		return true
	end
end
