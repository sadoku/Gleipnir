function MODULE:Init()
	self:callOnLoad("inventory", function(tbl)
		self.Invent = tbl
	end)
end


function MODULE:OnContextMenuOpen()
	self:InitContainer()
	self:InitCharView()
	self:InitStatsView()

	self:InitEconomy()

	if self.Invent then
		self.Invent:ShowInvent()
	end
end

function MODULE:InitContainer()
	self.Container = self.Container or vgui.Create("DFrame")
	self.Container:SetSize(256,512)
	self.Container:SetPos(0,0)
	self.Container:MoveTo(4,50, 0.2, 0)
	self.Container:SetSize(0,0)
	self.Container:SetTitle("Character view")
	self.Container:SetVisible(true)
	self.Container:SetDraggable(false)
	self.Container:ShowCloseButton(false)
	self.Container:SetAlpha(0)

	self.Container:SizeTo(256,512, 0.1, 0, 1)
	self.Container:AlphaTo(255, 0.1, 0)
end

function MODULE:InitCharView()
	self.CharView = self.CharView or vgui.Create("DModelPanel")
	self.CharView:SetModel(LocalPlayer():GetModel())
	self.CharView:SetSize(256,256)
	self.CharView:SetPos(0,22)
	self.CharView:SetCamPos( Vector( 0, 50, 100 ) )
	self.CharView:SetLookAt( Vector( 0, 0, 0 ) )
	self.CharView:SetParent(self.Container)
end

function MODULE:InitStatsView()
	local first = false
	if(self.StatsViewContainer == nil) then
		first = true
	end
	self.StatsViewContainer = self.StatsViewContainer or vgui.Create("DPanelList", self.Container)
	self.StatsViewContainer:SetPos(0,256+22)
	self.StatsViewContainer:SetSize(256,256-22)

	self.StaminaView = self.StaminaView or vgui.Create("DLabel")
	self.StaminaView:SetText("Stamina: "..tostring(LocalPlayer().stamina))
	if(first == true) then self.StatsViewContainer:AddItem(self.StaminaView) end
	
	self.AgilityView = self.AgilityView or vgui.Create("DLabel")
	self.AgilityView:SetText("Agility: "..tostring(LocalPlayer().agility))
	if(first == true) then self.StatsViewContainer:AddItem(self.AgilityView) end

	self.BankView = self.BankView or vgui.Create("DLabel")
	self.BankView:SetText("Bank: "..tostring(LocalPlayer():GetBank()))
	if(first == true) then self.StatsViewContainer:AddItem(self.BankView) end

end


function MODULE:InitEconomy()

	self.EconomyContainer = self.EconomyContainer or vgui.Create("DFrame")
	self.EconomyContainer:SetSize(0,0)
	self.EconomyContainer:SetPos(0,0)
	self.EconomyContainer:SetSize(0,0)
	self.EconomyContainer:SizeTo(128,64, 0.1, 0, 1)
	self.EconomyContainer:ShowCloseButton(false)
	self.EconomyContainer:SetDraggable(false)
	self.EconomyContainer:SetTitle("Economy")
	self.EconomyContainer:SetAlpha(0)
	self.EconomyContainer:AlphaTo(255, 0.2, 0)
	self.EconomyContainer:MoveTo(4,50+512+10, 0.2, 0)

	self.EconomyList = self.EconomyList or vgui.Create("DPanelList", self.EconomyContainer)
	self.EconomyList:SetSize(128,64-22)
	self.EconomyList:SetPos(0,22)
	self.EconomyList:SetPadding(4)
	self.EconomyList:Clear()

	self.PocketMoneyLabel = self.PocketMoneyLabel or vgui.Create("DLabel")
	self.PocketMoneyLabel:SetText("Money: "..tostring(LocalPlayer():GetMoney()))
	self.PocketMoneyLabel:SizeToContents()
	self.EconomyList:AddItem(self.PocketMoneyLabel)

	self.BankLabel = self.BankLabel or vgui.Create("DLabel")
	self.BankLabel:SetText("Bank: "..tostring(LocalPlayer():GetBank()))
	self.BankLabel:SizeToContents()
	self.EconomyList:AddItem(self.BankLabel)

end

function MODULE:HideEconomy()
	self.EconomyContainer:SetAlpha(255)
	self.EconomyContainer:AlphaTo(0, 0.1, 0)

end

function MODULE:HideContainer()
	self.Container:SetAlpha(255)
	self.Container:AlphaTo(0, 0.1, 0)
	timer.Simple(0.2, function(self)
		self.Container:SetVisible(false)
	end, self)
	--self.Container:SetVisible(false)
end

function MODULE:OnContextMenuClose()
	self:HideContainer()
	self:HideEconomy()
	if self.Invent then
		self.Invent:HideInvent()
	end
end
