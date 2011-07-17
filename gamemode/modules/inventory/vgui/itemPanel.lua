local PANEL = {}

function PANEL:Init()
	self.LastPaint = RealTime()
	self.Hover = false
end

function PANEL:SetModel(model)
	self.Entity = ClientsideModel(model, RENDERGROUP_OPAQUE)
	self.Entity:SetNoDraw(true)
	self.Pos = Vector(50,50,0)
end

function PANEL:Paint()
	local x,y,w,h = self:GetBounds()
	--[[
	surface.SetDrawColor(50,50,50,self:GetAlpha())
	surface.DrawRect(0,0, w, h)
	surface.SetDrawColor(110,110,100, self:GetAlpha())
	surface.DrawRect(1, 1, w-2,h-2)]]
	draw.RoundedBox(4, 0,0, w, h, Color(50,50,50,self:GetAlpha()))
	draw.RoundedBox(4, 1,1, w-2, h-2, Color(110,110,110, self:GetAlpha()))
	if(not self.Entity) then return end
	local campos = self.Pos
	x,y = self:LocalToScreen(0,0)
	cam.Start3D(campos, (Vector(0,0,0)-self.Pos):Angle(), 90, x+1,y+1, w-2, h-2)
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

vgui.Register("itemPanel", PANEL)
