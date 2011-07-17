function MODULE:ShowInvent()
	self.Container = self.Container or vgui.Create("DFrame")
	self.Container:SetSize(0,0)
	self.Container:SizeTo(512,512,0.2,0)
	self.Container:SetPos(ScrW()-512-4, 4)
	self.Container:ShowCloseButton(false)
	self.Container:SetDraggable(false)
	self.Container:SetTitle("Inventory")
--	self.Container:SetDeleteOnClose(false)

	self.Divider = self.Divider or vgui.Create("DHorizontalDivider", self.Container)
	self.Divider:SetPos(0,22)
	self.Divider:SetSize(512,512)
	self.Divider:SetLeftWidth(256)
	self.Divider:SetDividerWidth(4)

	
	self.InfoList = self.InfoList or vgui.Create("DPanelList")
	self.InfoList:Clear()

	self.IModel = self.IModel or vgui.Create("DModelPanel")
	self.IModel:SetCamPos(Vector(50,50,0))
	self.IModel:SetLookAt(Vector(0,0,0))
	self.IModel:SetSize(128,128)
	self.InfoList:AddItem(self.IModel)

	self.IName = self.IName or vgui.Create("DLabel")
	self.IName:SetText("")
	self.IName:SizeToContents()
	self.IName:SetPos(128,0)
	self.InfoList:AddItem(self.IName)
	


	self.IDropUseList = self.IDropUseList or vgui.Create("DPanelList")
	self.IDropUseList:SetSize(self.InfoList:GetWide(), 30)
	self.IDropUseList:EnableHorizontal(true)
	self.IDropUseList:Clear()

	self.IDrop = self.IDrop or vgui.Create("DButton")
	self.IDrop:SetText("Drop")
	self.IDrop:SizeToContents()
	self.IDrop:SetHeight(self.IDrop:GetTall()+6)
	self.IDrop:SetWidth(100)
	self.IDrop.DoClick = function()
		RunConsoleCommand("_IDrop", tostring(self.ItemNum), tostring(self.Inventory[self.ItemNum].id))
		table.remove(self.Inventory, self.ItemNum)
		self:RebuildIList()
	end

	self.IDropUseList:AddItem(self.IDrop)

	self.IUse = self.IUse or vgui.Create("DButton")
	self.IUse:SetText("Use")
	self.IUse:SizeToContents()
	self.IUse:SetWidth(100)
	self.IUse:SetHeight(self.IUse:GetTall()+6)
	self.IDropUseList:AddItem(self.IUse)
	
	self.InfoList:AddItem(self.IDropUseList)

	self.PanelList = self.PanelList or vgui.Create("DPanelList")
	self.PanelList:SetSpacing(6)
	--self.PanelList:SetPos(0,22)
	--self.PanelList:SetSize(512,512-22)
	self.PanelList:EnableHorizontal(true)
	self:RebuildIList()


	
	self.Divider:SetLeft(self.PanelList)
	self.Divider:SetRight(self.InfoList)
	self.Container:SetVisible(true)
	local items = self.PanelList:GetItems()
	if #items >= 1 then
		items[1].OnMousePressed(items[1], MOUSE_LEFT)
	end
end

function MODULE:RebuildIList()
	self.PanelList:Clear()
	for k,v in pairs(self.Inventory) do
		local bajs = vgui.Create("SpawnIcon")
		bajs:SetModel(v.model)
		bajs:SetSize(64,64)
		that = self
		bajs.OnMousePressed = function(self, mc)
			that.IName:SetText(v.model)
			that.IName:SizeToContents()
			that.IModel:SetModel(v.model)
			that.ItemNum = k
		end
		self.PanelList:AddItem(bajs)
	end

end

function MODULE:HideInvent()
	self.Container:SetVisible(false)
end



function MODULE:Init()
	self.Inventory = {}
	self.ItemNum = 0
	concommand.Add("ShowInv", function() self:ShowInv() end)
	usermessage.Hook("NewItem", function(um)
		local ctype = um:ReadString()
		local model = um:ReadString()
		local rowid = um:ReadShort()
		util.PrecacheModel(model)
		chat.AddText("New item of type "..ctype.." with model "..model.." with id "..tostring(rowid))
		table.insert(self.Inventory, {ctype = ctype, model = model, id = rowid})
		if self.PanelList then
			self:RebuildIList()
		end
	end)
end
