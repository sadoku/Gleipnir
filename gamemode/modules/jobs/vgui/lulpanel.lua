--include("HeadPanel.lua")
local PANEL = {}

function PANEL:Init()
	self.CamPos = Vector(200,0,50)
	self.LookAt = Vector(0,0,0)
	self.LookAngle = (self.LookAt-self.CamPos):Angle()
	--self.CamPos = Vector(200,((self:GetWide()/2)/self:GetWide()*-100), 50)
	--self.OrgCam = self.CamPos
	self.Chars = {}
	self.job = 1
--[[		{model = "models/Eli.mdl"},
		{model = "models/breen.mdl"},
		{model = "models/Humans/Group03m/male_06.mdl"},
		{model = "models/monk.mdl"},
		{model = "models/Humans/Group01/Female_07.mdl"},
		{model = "models/Humans/Group03m/male_03.mdl"},
		{model = "models/Humans/Group02/male_06.mdl"}
	}]]
	self.CamPos = Vector(175, (-(#self.Chars*30))/2, 50)
	self.ActualCPos = self.CamPos
	self.OrgCam = self.CamPos
	self.OlCPos = self.CamPos
	
	self.JobTitle = vgui.Create("DLabel", self)
	self.JobTitle:SetFont("Trebutchet24")
	self.NameEntry = vgui.Create("DTextEntry", self)
	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetText("Name: ")
	self.GoButton = vgui.Create("DButton", self)
	self.GoButton:SetText("Done!")
	self.GoButton.DoClick = function()
		print("Choose the job "..self.Chars[self.job].name)
		RunConsoleCommand("_ChangeJob", self.job)
		self:Remove()
	end
	self.MouseOver = false
	self.MX = 0
	self.MY = 0
	self.LastPaint = RealTime()
	self.ActualCPos = self.CamPos
	self.BlurMat = Material("pp/blurscreen")
	self.AnimStart = 0
end

function PANEL:SetJobs(jobs)
	self.Chars = jobs
	for v,k in pairs(self.Chars) do
		k.panel = vgui.Create("HeadPanel", self)
		k.panel:SetPos(v*64,0)
		k.panel:SetSize(64,64)
		k.panel:SetModel(k.model)
		-- So we know what job to choose
		k.panel.job = v
		k.entity = ClientsideModel(k.view or k.model, RENDERGROUP_OPAQUE)
		k.entity:SetNoDraw(true)
		k.entity:SetPos(Vector(0,(-(#self.Chars*30))+(v*30),0))
		k.entity:SetAngles(Angle(0,0,0))


		-- Animation
		local seq = k.entity:LookupSequence("LineIdle01")
		if(seq > 0) then
			k.entity:ResetSequence(seq)
		end

		k.entity.light = {r=0.75,g=0.75,b=0.75}
		k.panel.OnCursorEntered = function(self)
			self.Hover = true
			k.entity.light = {r=1,g=1,b=1}
		end
		k.panel.OnCursorExited = function(self)
			self.Hover = false
			k.entity.light = {r=0.75,g=0.75,b=0.75}
		end
		local this = self
		k.panel.OnMousePressed = function(self, mc)
			if(mc == MOUSE_LEFT) then
				chat.AddText("FUCKS")
				this.job = self.job
				this.JobTitle:SetText(this.Chars[self.job].name)
				this.OlCPos = this.CamPos
				this.CamPos = Vector(75, k.entity:GetPos().y, 50)
				this.AnimStart = SysTime()

			end
			if(mc == MOUSE_RIGHT) then
				chat.AddText("MOUSE RIGHT")
				this.OlCPos = this.CamPos
				this.CamPos = Vector(175, (-(#this.Chars*30))/2,50)
				this.AnimStart = SysTime()
			end
		end

	end
end

function PANEL:PerformLayout()
	derma.SkinHook("Layout", "Panel", self)
	self.NameEntry:SetPos((self:GetWide()/2)-(self.NameEntry:GetWide()/2), (self:GetTall()-(self:GetTall()*0.1)))
	self.NameLabel:SetPos((self:GetWide()/2)-self.NameEntry:GetWide(), (self:GetTall()-(self:GetTall()*0.1)))
	self.JobTitle:SetPos((self:GetWide()/2)-(self.JobTitle:GetWide()/2), (self:GetTall()-(self:GetTall()*0.1))-self.NameEntry:GetTall())
	self.GoButton:SetPos((self:GetWide()/2)-(self.GoButton:GetWide()/2), (self:GetTall()-(self:GetTall()*0.1))+self.NameEntry:GetTall())
	for v,k in pairs(self.Chars) do
		k.panel:SetPos((self:GetWide()/2)-((#self.Chars*64)/2)+(v*64), 50)
	end
end

-- t = Current time
-- s = Starting value
-- c = Change needed
-- d = Easing duration
function PANEL:easeInQuad(t, s, c, d)
	local t = t/d
	local result = c*t*t+s
	if(c < 0) then
		if(result <= s+c) then
			return s+c
		end
	else
		if(result >= s+c) then
			return s+c
		end
	end
	return result
end


function PANEL:Paint()
	local smallestSize = math.min(self:GetWide(), self:GetTall())
	local x, y = self:LocalToScreen(self:GetWide()/2-(smallestSize/2), 0)
	surface.SetMaterial(self.BlurMat)
	surface.SetDrawColor(255,255,255,255)
	local x1, y1 = self:LocalToScreen( 1, 1 )
	local x2, y2 = self:LocalToScreen( self:GetWide() - 1, self:GetTall() - 1 )
	x1 = x1 + 5 y1 = y1 + 5
	x2 = x2 - 5 y2 = y2 - 5
	for i=0.33,1,0.33 do 
		self.BlurMat:SetMaterialFloat( "$blur", 5*i )
		render.UpdateScreenEffectTexture()
		surface.DrawPoly( {
			{ x = 0, y = 1, u = x1/ScrW(), v = y1/ScrH() },
			{ x = self:GetWide() - 1, y = 1, u = x2/ScrW(), v = y1/ScrH() },
			{ x = self:GetWide() - 1, y = self:GetTall(), u = x2/ScrW(), v = y2/ScrH() },
			{ x = 1, y = self:GetTall(), u = x1/ScrW(), v = y2/ScrH() }
		} )
    	end
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,0,self:GetWide(), self:GetTall())
	self.ActualCPos.x = self:easeInQuad(SysTime()-self.AnimStart, self.OlCPos.x, self.CamPos.x-self.OlCPos.x, 0.5)
	self.ActualCPos.y = self:easeInQuad(SysTime()-self.AnimStart, self.OlCPos.y, self.CamPos.y-self.OlCPos.y, 0.5)
	cam.Start3D(self.ActualCPos, self.LookAngle, 90, x, y, smallestSize,smallestSize)
		cam.IgnoreZ(true)
		render.SuppressEngineLighting(true)
		local first = true
		for v,k in pairs(self.Chars) do
			local light = k.entity.light
			render.SetColorModulation(light.r, light.g, light.b)
			k.entity:DrawModel()
			render.SetColorModulation(1,1,1)
		end
		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)
	cam.End3D()
	for v,k in pairs(self.Chars) do
		k.entity:FrameAdvance(RealTime()-self.LastPaint)
	end
	self.LastPaint = RealTime()
	return true
end
--[[
function PANEL:OnCursorMoved(x,y)
	self.MX = x
	self.MY = y
	chat.AddText("X: "..tostring(self.MX).." Y: "..tostring(self.MY))
end
]]
function PANEL:OnCursorEntered()
	self.MouseOver = true
	chat.AddText("Enter panel")
end

function PANEL:OnCursorExited()
	self.MouseOver = false
	self.MX = 0
	self.MY = 0
	chat.AddText("Leave panel")
end

derma.DefineControl("lulpanel", "Panel to own them all", PANEL, "EditablePanel")
--vgui.Register("lulpanel", PANEL, "DFrame")
