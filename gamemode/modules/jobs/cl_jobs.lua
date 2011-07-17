

function MODULE:Init()
	-- A lil' scope hack, sorry :(
	function MODULE.ShowJobs(um)
		--[[
		self.JobContainer = vgui.Create("DFrame")
		self.JobContainer:SetSize(512,512)
		self.JobContainer:SetTitle("BAJS")
		self.JobContainer:Center()

		-- DPanelList here
		self.JobList = vgui.Create("DPanelList", self.JobContainer)
		self.JobList:SetPos(0,22)
		self.JobList:SetSize(512,512-22)
		
		-- Models
		for k,v in pairs(self.Jobs) do
			local JobButton = vgui.Create("DButton")
			JobButton:SetText(v.name)
			JobButton.DoClick = function(button)
				RunConsoleCommand("_ChangeJob", k)
			end
			self.JobList:AddItem(JobButton)
		end


		self.JobContainer:MakePopup()]]
		local candies = vgui.Create("lulpanel")
		candies:SetJobs(self.Jobs)
		candies:SetSize(ScrW(), ScrH())
		candies:MakePopup()

	end
	usermessage.Hook("ShowJobs", self.ShowJobs)
end
