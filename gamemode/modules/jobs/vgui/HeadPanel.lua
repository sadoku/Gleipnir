local PANEL = {}

function PANEL:Init()
	self.LastPaint = RealTime()
	self.Hover = false
end

function PANEL:SetModel(model)
	self.Entity = ClientsideModel(model, RENDERGROUP_OPAQUE)
	self.Entity:SetNoDraw(true)
	local bone = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
	local bonep, bonea = self.Entity:GetBonePosition(bone)
	self.Pos = bonep
	local seq = self.Entity:LookupSequence("LineIdle01")
	if(seq > 0) then
		self.Entity:ResetSequence(seq)
	end
end

function PANEL:Paint()
	local x,y,w,h = self:GetBounds()
	surface.SetDrawColor(50,50,50,self:GetAlpha())
	surface.DrawRect(0,0, w, h)
	surface.SetDrawColor(110,110,100, self:GetAlpha())
	surface.DrawRect(1, 1, w-2,h-2)
	if(not self.Entity) then return end
	local campos = self.Pos+Vector(20,0,0)
	x,y = self:LocalToScreen(0,0)
	cam.Start3D(campos, (self.Pos-campos):Angle(), 70, x+1,y+1, w-2, h-2)
		cam.IgnoreZ(true)
		render.SuppressEngineLighting(true)
		render.SetBlend(self:GetAlpha()/255)
		if(self.Hover) then
			render.SetColorModulation(1,1,1)
		else
			render.SetColorModulation(0.75,0.75,0.75)
		end
		self.Entity:DrawModel()
		render.SetColorModulation(1,1,1)
		render.SetBlend(1)
		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)
	cam.End3D()
	self.Entity:FrameAdvance(RealTime()-self.LastPaint)
	self.LastPaint = RealTime()
end

function PANEL:OnCursorEntered()
	self.Hover = true
end

function PANEL:OnCursorExited()
	self.Hover = false
end

vgui.Register("HeadPanel", PANEL)
