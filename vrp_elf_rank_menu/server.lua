
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

--[[
 _______  _______        _______ _______ ___ ___ ___ ___ ___ ___ ______  ___ _______ ___ ___        _______ ___     _______ 
|   _   \|   _   |______|   _   |   _   |   Y   |   Y   |   Y   |   _  \|   |       |   Y   |______|   _   |   |   |   _   |
|.  1   /|.  1   |______|.  1___|.  |   |.      |.      |.  |   |.  |   |.  |.|   | |   1   |______|.  1___|.  |   |.  1___|
|.  _   \|.  ____|      |.  |___|.  |   |. \_/  |. \_/  |.  |   |.  |   |.  `-|.  |-'\_   _/       |.  __)_|.  |___|.  __)  
|:  1    |:  |          |:  1   |:  1   |:  |   |:  |   |:  1   |:  |   |:  | |:  |   |:  |        |:  1   |:  1   |:  |    
|::.. .  |::.|          |::.. . |::.. . |::.|:. |::.|:. |::.. . |::.|   |::.| |::.|   |::.|        |::.. . |::.. . |::.|    
`-------'`---'          `-------`-------`--- ---`--- ---`-------`--- ---`---' `---'   `---'        `-------`-------`---'    
--]]

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPerm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_elf_rank_menu")
ERMclient = Tunnel.getInterface("vRP_elf_rank_menu","vRP_elf_rank_menu")
Tunnel.bindInterface("vRP_elf_rank_menu",vRPerm)

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

local logdof = "both" -- "txt" = 1 -/- "dis" = 2-/- "both" = 3			txt = text document		dis = discord msg - working			both = txt + dis 
local discordwebhook = "https://discordapp.com/api/webhooks/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


-- To Add A Rank Insert It Into StaffGroups "IMPORTANT Lowest Rank To Higest Rank" 
staffgroups = { -- may NOT be a job !!!
	-- Lowest Rank
	"DKNetwork-Sup",		-- Supporter
	"DKNetwork-Mod",		-- Moderator
	"DKNetwork-Admin",		-- Administrator
	"DKNetwork-Ledelse",	-- Management
	"DKNetwork-Dev"			-- Developer
	--Higest Rank
}

local staffremoveoldgroup = false -- if you dont want staff groups to stack
-- false = will give supporter next time then it will add moderator so you have both ranks
-- true = will give supporter next time then it will remove supporter and then add moderator so you only have the one rank


-- To Add A Rank Insert It Into PoliceGroups "IMPORTANT Lowest Rank To Higest Rank" 
policegroups = { -- has to be a job			 _config = { gtype = "job",
	"Unemployed", -- unemplayed rank hass to be here else you cannot fier a player
	"Politi Betjent",
	"Politi Cevil",
	"Politi SWAT",
	"Politi Chef"
}


-- To Add A Rank Insert It Into EMSGroups "IMPORTANT Lowest Rank To Higest Rank" 
emsgroups = { -- has to be a job			 _config = { gtype = "job",
	"Unemployed", -- unemplayed rank hass to be here else you cannot fier a player
	"EMS Ambulance Reder",
	"EMS Læge",
	"EMS Chef"
}


-- To Add A Rank Insert It Into MechanicGroups "IMPORTANT Lowest Rank To Higest Rank" 
mechanicgroups = { -- has to be a job		 _config = { gtype = "job",
	"Unemployed", -- unemplayed rank hass to be here else you cannot fier a player
	"Mekaniker",
	"Mekaniker Chef"
}


-- To Add A Rank Insert It Into LawyerGroups "IMPORTANT Lowest Rank To Higest Rank" 
lawyergroups = { -- has to be a job			 _config = { gtype = "job",
	"Unemployed", -- unemplayed rank hass to be here else you cannot fier a player
	"Advokat",
	"Advokat Chef"
}


-- To Add A Rank Insert It Into Jobs The Rank
-- MAX 30 Roles Supported !!!
jobs = { -- can be both a job and a role !!!
	"Lastbil Chauffør",
	"Taxa Køre",
	"Skovhugger",
	"Miner",
	"Håndværker",
	"Unemployed"
}

local promote_1 = "You Cant Promote You'r Self"
local promote_2 = "Confirm Promotion To"
local promote_3 = "Promoted To"
local promote_4 = "Promoted You To"
local promote_5 = "Player Rejected Promotion Or Didn't Answer"
local promote_6 = "Cant Promote To Equal Or Higer Ranked"
local demote_1 = "You Cant Demote You'r Self"
local demote_2 = "Demoted To"
local demote_3 = "Cemoted You To"
local demote_4 = "Cant Demote Equal Or Higer Ranked"
local add_job_1 = "Cant Recruit You'r Self" 
local add_job_2 = "Confirm Recruitment As"
local add_job_3 = "Given"
local add_job_4 = "Recruited You As"
local add_job_5 = "Player Rejected Recruitment Or Didn't Answer"
local remove_job_1 = "Cant Recruit You'r Self"
local remove_job_2 = "Removed"
local remove_job_3 = "From"
local remove_job_4 = "Fired You As"
local ii = "Invalid ID"

-- MASTER PERM
-- master perm = ignore the promot to same / higer rank or ignore the demote higer or equal ranks

-- admin.groupe_add_master					-- ignore the promot to same / higer rank
-- admin.groupe_remove_master				-- ignore the demote higer or equal ranks

--[[
	"admin.groupe_menu", -- main menu
	"admin.groupe_add", -- main add menu
	"admin.groupe_add_staff", -- prmote staff
	"admin.groupe_add_police", -- promote police
	"admin.groupe_add_ems", -- promote ems
	"admin.groupe_add_mechanic", -- promote mechanic
	"admin.groupe_add_lawyer", -- promote lawyer / judge
	"admin.groupe_add_jobs", -- main add jobs
	
	"admin.groupe_remove", -- main remove menu
	"admin.groupe_remove_staff", -- demote staff
	"admin.groupe_remove_police", -- demote police
	"admin.groupe_remove_ems", -- demote ems
	"admin.groupe_remove_mechanic", -- demote mechanic
	"admin.groupe_remove_lawyer", -- demote lawyer / judge
	"admin.groupe_remove_jobs", -- main remove jobs
]]--

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- FUNCTIONS
function trim(str) -- replaces "space" with "_"
  str = str:gsub("%s+", "_")
  str = string.gsub(str, "%s+", "_")
  return str
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- PROMOTE STAFF

local ch_promote_staff = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(staffgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. promote_1 .. "."}) -- cant promote your self
			else
				if user_top_value > target_top_value + 1 or master == true then
					target_top_value = target_top_value + 1
					local ranksgiven = 0
					for nr, rank in pairs(staffgroups) do
						if staffremoveoldgroup == true then
							if nr == target_top_value - 1 then
								vRP.removeUserGroup({target, rank})
							end
						end
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								vRP.request({requestTarget, "* " .. promote_2 ..": " .. rank .. " *" , 1000, function(player,ok) -- Confirm Promotion To
									if ok then
										ranksgiven = ranksgiven + 1
										vRP.addUserGroup({target,rank})
										vRPclient.notify(user,{"ID: " .. target .. " " .. promote_3 .. " " .. rank}) -- promoted to 
										vRPclient.notify(target,{"ID: " .. user .. " " .. promote_4 .. " " .. rank}) -- promoted you to 
										if logdof == "txt" or logdof == "both" then
											vRPerm.logInfoToFile("rank_menu_staff_log.txt", user_id .. " Promoted: " .. target .. " To: " .. rank .. " !")
										end
										if logdof == "dis" or logdof == "both" then
											vRPerm.logInfoToDis("Rank Menu STAFF!", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
									else
										vRPclient.notify(user,{"~r~" .. promote_5 .. "."})
									end
								end})
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(user,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(user,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(user,{"~r~" .. promote_6 .. "."}) -- you cant promote to higere or equal ranks
				end
			end
		else
		vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Promote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DEMOTE STAFF

local ch_demote_staff = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		local user_id = vRP.getUserId({player})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(staffgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(player,{"~r~" .. demote_1 .. "."}) -- cant demote your self
			else
				if user_top_value > target_top_value or master == true then
					local ranksremoved = 0
					for nr, rank in pairs(staffgroups) do
						if staffremoveoldgroup == true then
							if nr == target_top_value - 1 then
								vRP.addUserGroup({target,rank})
							end
						end
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								ranksremoved = ranksremoved + 1
								vRP.removeUserGroup({target, rank})
								vRPclient.notify(player,{"ID: " .. target .. " " .. demote_2 .. " " .. rank}) -- demoted to 
								vRPclient.notify(target,{"ID: " .. player .. " " .. demote_3 .. " " .. rank}) -- demoted you to  
								if logdof == "txt" or logdof == "both" then
									vRPerm.logInfoToFile("rank_menu_staff_log.txt", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
								end
								if logdof == "dis" or logdof == "both" then
									vRPerm.logInfoToDis("Rank Menu STAFF!", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
								end
							end
						end
					end
					if ranksremoved == 0 then
						vRPclient.notify(player,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksremoved > 1 then
						vRPclient.notify(player,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. demote_3 .. "."}) -- you cant demote higere or equal ranked
				end
			end
		else
		vRPclient.notify(player,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Demote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- PROMOTE POLICE

local ch_promote_police = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(policegroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. promote_1 .. "."}) -- cant promote your self
			else
				if user_top_value > target_top_value + 1 or master == true then
					target_top_value = target_top_value + 1
					if target_top_value == 1 then
						target_top_value = target_top_value + 1
					end
					local ranksgiven = 0
					for nr, rank in pairs(policegroups) do
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								vRP.request({requestTarget, "* " .. promote_2 ..": " .. rank .. " *" , 1000, function(player,ok)
									if ok then
										ranksgiven = ranksgiven + 1
										vRP.addUserGroup({target,rank})
										vRPclient.notify(user,{"ID: " .. target .. " " .. promote_3 .. " " .. rank}) -- promoted to 
										vRPclient.notify(target,{"ID: " .. user .. " " .. promote_4 .. " " .. rank}) -- promoted you to 
										if logdof == "txt" or logdof == "both" then
											vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
										if logdof == "dis" or logdof == "both" then
											vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
									else
										vRPclient.notify(user,{"~r~" .. promote_5 .. "."})
									end
								end})
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(user,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(user,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. promote_6 .. "."}) -- you cant promote to higere or equal ranks
				end
			end
		else
		vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Promote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DEMOTE POLICE

local ch_demote_police = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		local user_id = vRP.getUserId({player})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(policegroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(player,{"~r~" .. demote_1 .. "."}) -- cant demote your self
			else
				if user_top_value > target_top_value or master == true then
					target_top_value = target_top_value - 1
					local ranksgiven = 0
					for nr, rank in pairs(policegroups) do
						if nr == target_top_value then
							ranksgiven = ranksgiven + 1
							vRP.addUserGroup({target, rank})
							vRPclient.notify(player,{"ID: " .. target .. " " .. demote_2 .. " " .. rank}) -- demoted to 
							vRPclient.notify(target,{"ID: " .. player .. " " .. demote_3 .. " " .. rank}) -- demoted you to 
							if logdof == "txt" or logdof == "both" then
								vRPerm.logInfoToFile("rank_menu_log.txt", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
							if logdof == "dis" or logdof == "both" then
								vRPerm.logInfoToDis("Rank Menu", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(player,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(player,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. demote_4 .. "."}) -- cant demote equal or higer ranked
				end
			end
		else
		vRPclient.notify(player,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Demote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- PROMOTE EMS

local ch_promote_ems = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(emsgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. promote_1 .. "."}) -- cant promote your self
			else
				if user_top_value > target_top_value + 1 or master == true then
					target_top_value = target_top_value + 1
					if target_top_value == 1 then
						target_top_value = target_top_value + 1
					end
					local ranksgiven = 0
					for nr, rank in pairs(emsgroups) do
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								vRP.request({requestTarget, "* " .. promote_2 ..": " .. rank .. " *" , 1000, function(player,ok)
									if ok then
										ranksgiven = ranksgiven + 1
										vRP.addUserGroup({target,rank})
										vRPclient.notify(user,{"ID: " .. target .. " " .. promote_3 .. " " .. rank}) -- promoted to 
										vRPclient.notify(target,{"ID: " .. user .. " " .. promote_4 .. " " .. rank}) -- promoted you to 
										if logdof == "txt" or logdof == "both" then
											vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
										if logdof == "dis" or logdof == "both" then
											vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
									else
										vRPclient.notify(user,{"~r~" .. promote_5 .. "."})
									end
								end})
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(user,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(user,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(user,{"~r~" .. promote_6 .. "."}) -- you cant promote to higere or equal ranks
				end
			end
		else
		vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Promote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DEMOTE EMS

local ch_demote_ems = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		local user_id = vRP.getUserId({player})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(emsgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(player,{"~r~" .. demote_1 .. "."}) -- cant demote your self
			else
				if user_top_value > target_top_value or master == true then
					target_top_value = target_top_value - 1
					local ranksgiven = 0
					for nr, rank in pairs(emsgroups) do
						if nr == target_top_value then
							ranksgiven = ranksgiven + 1
							vRP.addUserGroup({target, rank})
							vRPclient.notify(player,{"ID: " .. target .. " " .. demote_2 .. " " .. rank}) -- demoted to 
							vRPclient.notify(target,{"ID: " .. player .. " " .. demote_3 .. " " .. rank}) -- demoted you to 
							if logdof == "txt" or logdof == "both" then
								vRPerm.logInfoToFile("rank_menu_log.txt", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
							if logdof == "dis" or logdof == "both" then
								vRPerm.logInfoToDis("Rank Menu", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(player,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(player,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. demote_4 .. "."}) -- cant demote equal or higer ranked
				end
			end
		else
		vRPclient.notify(player,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Demote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- PROMOTE MECHANIC

local ch_promote_mechanic = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(mechanicgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. promote_1 .. "."}) -- cant promote your self
			else
				if user_top_value > target_top_value + 1 or master == true then
					target_top_value = target_top_value + 1
					if target_top_value == 1 then
						target_top_value = target_top_value + 1
					end
					local ranksgiven = 0
					for nr, rank in pairs(mechanicgroups) do
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								vRP.request({requestTarget, "* " .. promote_2 ..": " .. rank .. " *" , 1000, function(player,ok)
									if ok then
										ranksgiven = ranksgiven + 1
										vRP.addUserGroup({target,rank})
										vRPclient.notify(user,{"ID: " .. target .. " " .. promote_3 .. " " .. rank}) -- promoted to 
										vRPclient.notify(target,{"ID: " .. user .. " " .. promote_4 .. " " .. rank}) -- promoted you to 
										if logdof == "txt" or logdof == "both" then
											vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
										if logdof == "dis" or logdof == "both" then
											vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
									else
										vRPclient.notify(user,{"~r~" .. promote_5 .. "."})
									end
								end})
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(user,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(user,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(user,{"~r~" .. promote_6 .. "."}) -- you cant promote to higere or equal ranks
				end
			end
		else
		vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Promote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DEMOTE MECHANIC

local ch_demote_mechanic = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		local user_id = vRP.getUserId({player})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(mechanicgroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(player,{"~r~" .. demote_1 .. "."}) -- cant demote your self
			else
				if user_top_value > target_top_value or master == true then
					target_top_value = target_top_value - 1
					local ranksgiven = 0
					for nr, rank in pairs(mechanicgroups) do
						if nr == target_top_value then
							ranksgiven = ranksgiven + 1
							vRP.addUserGroup({target, rank})
							vRPclient.notify(player,{"ID: " .. target .. " " .. demote_2 .. " " .. rank}) -- demoted to 
							vRPclient.notify(target,{"ID: " .. player .. " " .. demote_3 .. " " .. rank}) -- demoted you to 
							if logdof == "txt" or logdof == "both" then
								vRPerm.logInfoToFile("rank_menu_log.txt", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
							if logdof == "dis" or logdof == "both" then
								vRPerm.logInfoToDis("Rank Menu", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(player,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(player,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. demote_4 .. "."}) -- cant demote equal or higer ranked
				end
			end
		else
		vRPclient.notify(player,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Demote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- PROMOTE LAWYER

local ch_promote_lawyer = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(lawyergroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. promote_1 .. "."}) -- cant promote your self
			else
				if user_top_value > target_top_value + 1 or master == true then
					target_top_value = target_top_value + 1
					if target_top_value == 1 then
						target_top_value = target_top_value + 1
					end
					local ranksgiven = 0
					for nr, rank in pairs(lawyergroups) do
						if nr == target_top_value then
							local requestTarget = vRP.getUserSource({target})
							if requestTarget ~= nil then
								vRP.request({requestTarget, "* " .. promote_2 ..": " .. rank .. " *" , 1000, function(player,ok)
									if ok then
										ranksgiven = ranksgiven + 1
										vRP.addUserGroup({target,rank})
										vRPclient.notify(user,{"ID: " .. target .. " " .. promote_3 .. " " .. rank}) -- promoted to 
										vRPclient.notify(target,{"ID: " .. user .. " " .. promote_4 .. " " .. rank}) -- promoted you to 
										if logdof == "txt" or logdof == "both" then
											vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
										if logdof == "dis" or logdof == "both" then
											vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Promoted ID: " .. target .. " To: " .. rank .. " !")
										end
									else
										vRPclient.notify(user,{"~r~" .. promote_5 .. "."})
									end
								end})
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(user,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(user,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(user,{"~r~" .. promote_6 .. "."}) -- you cant promote to higere or equal ranks
				end
			end
		else
		vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Promote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DEMOTE LAWYER

local ch_demote_lawyer = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		local user_id = vRP.getUserId({player})
		local user_top_rank = ""
		local target_top_rank = ""
		local user_top_value = 0
		local target_top_value = 0
		for nr, rank in pairs(lawyergroups) do -- gets players and targets top rank
			if (vRP.hasGroup({user_id, rank})) then
				user_top_value = nr
				user_top_rank = rank
			end
			if (vRP.hasGroup({target, rank})) then
				target_top_value = nr
				target_top_rank = rank
			end
		end
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(player,{"~r~" .. demote_1 .. "."}) -- cant demote your self
			else
				if user_top_value > target_top_value or master == true then
					target_top_value = target_top_value - 1
					local ranksgiven = 0
					for nr, rank in pairs(lawyergroups) do
						if nr == target_top_value then
							ranksgiven = ranksgiven + 1
							vRP.addUserGroup({target, rank})
							vRPclient.notify(player,{"ID: " .. target .. " " .. demote_2 .. " " .. rank}) -- demoted to 
							vRPclient.notify(target,{"ID: " .. player .. " " .. demote_3 .. " " .. rank}) -- demoted you to 
							if logdof == "txt" or logdof == "both" then
								vRPerm.logInfoToFile("rank_menu_log.txt", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
							if logdof == "dis" or logdof == "both" then
								vRPerm.logInfoToDis("Rank Menu", user_id .. " demoted: " .. target .. " To: " .. rank .. " WTF!")
							end
						end
					end
					if ranksgiven == 0 then
						vRPclient.notify(player,"ERROR 0001! PLZ Contact Dev.")
					end
					if ranksgiven > 1 then
						vRPclient.notify(player,"ERROR 0002! PLZ Contact Dev.")
					end
				else
					vRPclient.notify(player,{"~r~" .. demote_4 .. "."}) -- cant demote equal or higer ranked
				end
			end
		else
		vRPclient.notify(player,{"~r~" .. ii .. "."}) -- invalid id
		end
	end})
end,"Demote."}

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- ALL JOBS STUFF LIST THING -- ADD
for nr, job in pairs(jobs) do
	tjob = trim(job)
	_G[tjob .. "A"] = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_add_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. add_job_1 .. "."}) -- Cant Recruit You'r Self
			else
				local requestTarget = vRP.getUserSource({target})
				if requestTarget ~= nil then
					vRP.request({requestTarget, "* " .. add_job_2 ..": " .. job .. " *" , 1000, function(player,ok) -- Confirm Recruitment As
						if ok then
							vRP.addUserGroup({target,job})
							vRPclient.notify(user,{"ID: " .. target .. " " .. add_job_3 .. " " .. job}) -- Given
							vRPclient.notify(target,{"ID: " .. user .. " " .. add_job_4 .. " " .. job}) -- Recruited You As
							if logdof == "txt" or logdof == "both" then
								vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Recruited ID: " .. target .. " To: " .. job .. " !")
							end
							if logdof == "dis" or logdof == "both" then
								vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Recruited ID: " .. target .. " To: " .. job .. " !")
							end
						else
							vRPclient.notify(user,{"~r~" .. add_job_5 .. "."}) -- Player Rejected Recruitment Or Didn't Answer
						end
					end})
				end
			end
		else
			vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end		
	end})
  end}
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- ALL JOBS STUFF LIST THING -- REMOVE
for nr, job in pairs(jobs) do
	tjob = trim(job)
	_G[tjob .. "R"] = {function(player,choice)
	vRP.prompt({player,"Players ID:","",function(player,target)
		target = parseInt(target)
		user = player
		local user_id = vRP.getUserId({user})
		if target ~= nil and target ~= "" then 
			local targetself = false
			local master = false
			if target == user_id then
				targetself = true
			end
			if (vRP.hasPermission({user_id, "admin.groupe_remove_master"})) then
				master = true
			end
			if targetself == true and master == false then
				vRPclient.notify(user,{"~r~" .. remove_job_1 .. "."}) -- Cant Recruit You'r Self
			else
				vRP.removeUserGroup({target, job})
				vRPclient.notify(user,{remove_job_2 .. " " .. job .. " " .. remove_job_3 .. " ID: " .. target}) -- Removed -- From
				vRPclient.notify(target,{"ID: " .. user .. " " .. remove_job_4 .. " " .. job}) -- Fired You As
				if logdof == "txt" or logdof == "both" then
					vRPerm.logInfoToFile("rank_menu_log.txt", "ID: " .. user_id .. " Fired ID: " .. target .. " From: " .. job .. " !")
				end
				if logdof == "dis" or logdof == "both" then
					vRPerm.logInfoToDis("Rank Menu", "ID: " .. user_id .. " Fired ID: " .. target .. " From: " .. job .. " !")
				end
			end
		else
			vRPclient.notify(user,{"~r~" .. ii .. "."}) -- invalid id
		end		
	end})
  end}
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- DUMMY MENU

local function ch_dummy_menu(player, choice)
	return
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER ADD JOB MENU CHOICES
local function ch_add_job(player,choice)
	vRP.closeMenu({player})
	SetTimeout(350, function()
		vRP.buildMenu({"Add Job Menu", {player = player}, function(menu)
			menu.name = "Add Job Menu"
			menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) --[[vRP.openMenu({player, ch_groupe_add})]] end
			local user_id = vRP.getUserId({player})
			
			for nr, job in pairs(jobs) do
				if job ~= nil and job ~= "" then
					tjob = trim(job)
					menu["> " .. job] = _G[tjob .. "A"]
				end
			end
			
			vRP.openMenu({player, menu})
		end})
	end)
end


--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER REMOVE JOB MENU CHOICES
local function ch_remove_job(player,choice)
	vRP.closeMenu({player})
	SetTimeout(350, function()
		vRP.buildMenu({"Remove Job Menu", {player = player}, function(menu)
			menu.name = "Remove Job Menu"
			menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) --[[vRP.openMenu({player, ch_groupe_remove})]] end
			local user_id = vRP.getUserId({player})
			
			for nr, job in pairs(jobs) do
				if job ~= nil and job ~= "" then
					tjob = trim(job)
					menu["> " .. job] = _G[tjob .. "R"]
				end
			end

			
			vRP.openMenu({player, menu})
		end})
	end)
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER ADD GROUPE MENU CHOICES
local function ch_groupe_add(player,choice)
	vRP.closeMenu({player})
	SetTimeout(350, function()
		vRP.buildMenu({"Add Groupe Menu", {player = player}, function(menu)
			menu.name = "Add Groupe Menu"
			menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) --[[vRP.openMenu({player, ch_groupe_menu})]] end
			local user_id = vRP.getUserId({player})
			local perms = 0
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_jobs"})) then
				perms = 1
				menu["Add Jobs"] = {ch_add_job, "<font color=\"red\">Giv job til spiller!</font>"}
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_staff"})) then
				perms = 1
				menu["> Promote Staff"] = ch_promote_staff
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_police"})) then
				perms = 1
				menu["> Promote Police"] = ch_promote_police
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_ems"})) then
				perms = 1
				menu["> Promote EMS"] = ch_promote_ems
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_mechanic"})) then
				perms = 1
				menu["> Promote Mechanic"] = ch_promote_mechanic
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_add_lawyer"})) then
				perms = 1
				menu["> Promote Lawyer"] = ch_promote_lawyer
			end
			
			if perms == 0 then
				menu["No Perms"] = {ch_dummy_menu, "<font color=\"red\">Du har ikke tilladelse til noget her inde!</font>"}
			end
			
			vRP.openMenu({player, menu})
		end})
	end)
end


--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER REMOVE GROUPE MENU CHOICES
local function ch_groupe_remove(player,choice)
	vRP.closeMenu({player})
	SetTimeout(350, function()
		vRP.buildMenu({"Remove Groupe Menu", {player = player}, function(menu)
			menu.name = "Remove Groupe Menu"
			menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) --[[vRP.openMenu({player, ch_groupe_menu})]] end
			local user_id = vRP.getUserId({player})
			local perms = 0
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_jobs"})) then
				perms = 1
				menu["Remove Jobs"] = {ch_remove_job, "<font color=\"red\">Fjern jobs fra spiller!</font>"}
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_staff"})) then
				perms = 1
				menu["> Demote Staff"] = ch_demote_staff
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_police"})) then
				perms = 1
				menu["> Demote Police"] = ch_demote_police
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_ems"})) then
				perms = 1
				menu["> Demote EMS"] = ch_demote_ems
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_mechanic"})) then
				perms = 1
				menu["> Demote Mechanic"] = ch_demote_mechanic
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove_lawyer"})) then
				perms = 1
				menu["> Demote Lawyer"] = ch_demote_lawyer
			end
			
			if perms == 0 then
				menu["No Perms"] = {ch_dummy_menu, "<font color=\"red\">Du har ikke tilladelse til noget her inde!</font>"}
			end
			
			vRP.openMenu({player, menu})
		end})
	end)
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER ADMIN GROUPE MENU CHOICES
local function ch_groupe_menu(player,choice)
	vRP.closeMenu({player})
	SetTimeout(350, function()
		vRP.buildMenu({"Groupe Menu", {player = player}, function(menu)
			menu.name = "Groupe Menu"
			menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) end
			local user_id = vRP.getUserId({player})
			local perms = 0
			
			if (vRP.hasPermission({user_id, "admin.groupe_add"})) then
				perms = 1
				menu["Add Groupe"] = {ch_groupe_add, "<font color=\"red\">Add groupe til spiller!</font>"}
			end
			
			if (vRP.hasPermission({user_id, "admin.groupe_remove"})) then
				perms = 1
				menu["Remove Groupe"] = {ch_groupe_remove, "<font color=\"red\">Remove groupe fra spiller!</font>"}
			end
			
			if perms == 0 then
				menu["No Perms"] = {ch_dummy_menu, "<font color=\"red\">Du har ikke tilladelse til noget her inde!</font>"}
			end
			
			vRP.openMenu({player, menu})
		end})
	end)
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- RESGISTER ADMIN MENU CHOICES
vRP.registerMenuBuilder({"admin", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		if (vRP.hasPermission({user_id, "admin.groupe_menu"})) then
			choices["> Groupe Menu"] = {ch_groupe_menu, "ELF's Easy Groupe Stuff"}
		end
		add(choices)
	end
end})

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
--[[
-- FUNCTIONS
function trim(str) -- replaces "space" with "_"
  str = str:gsub("%s+", "_")
  str = string.gsub(str, "%s+", "_")
  return str
end
]]--
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--

-- LOG FUNCTIONS
function vRPerm.logInfoToFile(file,info)
  file = io.open(file, "a")
  if file then
    file:write(os.date("%c").." => "..info.."\n")
  end
  file:close()
end

function vRPerm.logInfoToDis(name, info)
  if info == nil or info == '' then return FALSE end
  PerformHttpRequest(discordwebhook, function(err, text, headers) end, 'POST', json.encode({username = name, content = info}), { ['Content-Type'] = 'application/json' })
end

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--
