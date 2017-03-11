Sheath = LibStub("AceAddon-3.0"):NewAddon("TimerTest", "AceTimer-3.0", "AceConsole-3.0")

function Sheath:OnInitialize()  
  local defaults = {
    char = {
      EnabledState = true,
	  Specs = {},
      CityUnsheathed = true,
      SheathStateCheckTimerInSeconds = 10 --every 10 seconds, a timer will check to see if the weapon is out,and if it is, it will be sheathed.
    }
  }
  -- below are events that cause you to toggle the sheath function, but not actually sheath the weapon.
  events = {
	'PLAYER_ENTERING_WORLD',	--this makes you draw your weapon when you log in or (I think) reload. Will look into disabling this. The only people who notice this are the ones who have very quick loading screens.
	'PLAYER_ENTERING_COMBAT',	--this will make you draw the weapon upon entering combat
  	'PLAYER_LEAVING_COMBAT',	--this will make you draw / sheath when you exit combat. Primarily, you should be sheathing unless you use Throw Glaive for instance. Still working on a fix for this.
	'PLAYER_LOGIN',				--this makes you draw your weapon when you log in or (I think) reload. Will look into disabling this. The only people who notice this are the ones who have very quick loading screens.
	}
  alreadySheathedAfterDismount = true
  eventFrame = CreateFrame("FRAME", "SheathEventFrame")
  timer = nil
  Sheath.db = LibStub("AceDB-3.0"):New("SheathDB", defaults)
  registerEvents(events)
  registerChatCommands()
  print("Sheath 0.1 beta Loaded! Type /sheath for options.")
  print("Originally made by Zordiak Darkspear-US Alliance. Edited to be exactly opposite by Keyboardturn#1309. Go whisper Zordiak sometime! :)") --also credit goes to /u/AfterAfterlife, /u/not_a_miner, and Istaran | Medivh - EU for the initial inspiration
end

function registerEvents(events)
  for i = 1, #events do
    eventFrame:RegisterEvent(events[i])
  end
  eventFrame:SetScript("OnEvent", function (frame, event, first, second)
      if (event == "UNIT_AURA") then
        Sheath:refreshMountedState()
        unitAuraToggleSheath()
      else
        ToggleSheath()
      end
  	end)
end

function Sheath:refreshMountedState()
  if (IsMounted()) then
    alreadySheathedAfterDismount = true
  end
end

function unitAuraToggleSheath()
  if (not IsMounted() and not alreadySheathedAfterDismount) then
    ToggleSheath()
    alreadySheathedAfterDismount = false
  end
end

function specsShouldBeInitialized()
  specsDBVariableIsEmpty = #Sheath.db.char.Specs == 0
  return specsDBVariableIsEmpty
end

function registerChatCommands()
  Sheath:RegisterChatCommand("sheath","slashfunc")
  Sheath:RegisterChatCommand("sheeth","slashfunc")
  Sheath:RegisterChatCommand("weapon","slashfunc")
end

function initializeSpecs()
  numSpecializations = GetNumSpecializations(false, false)
  local specs = {}
  for i = 1, numSpecializations do
    local id, name, description, icon = GetSpecializationInfo(i)
    specs[i] = {specName = name, specNumber = i, iconPath = icon, specEnabled = true}
  end
  return specs
end

function Sheath:OnEnable()
  startTimer()
  ToggleSheath()
  Sheath.MountCheckTimer = Sheath:ScheduleRepeatingTimer("refreshMountedState", 2)
end

function startTimer()
  destroyExistingTimer()
  Sheath.Timer = Sheath:ScheduleRepeatingTimer("TimerFeedback", Sheath.db.char.SheathStateCheckTimerInSeconds)
end

function destroyExistingTimer()
	if (not (Sheath.Timer == nil)) then
  	Sheath:CancelTimer(Sheath.Timer)
  end
end

function Sheath:TimerFeedback()
  if (isSheathed()) then
    unsheathWeapon()
  end
  Sheath:refreshMountedState()
end

function isSheathed()
  sheathed = 1
  if(GetSheathState() == sheathed) then
    return false
  else
    return true
  end
end

function unsheathWeapon()
  if sheathConditionsAreMet() then
	ToggleSheath()
  end
end

function sheathConditionsAreMet()
	return isSheathEnabled() and isSpecEnabled() and isCityEnabled() and not InCombatLockdown()
end

function isSheathEnabled()
  return Sheath.db.char.EnabledState 
end

function isSpecEnabled()
  if GetActiveSpecGroup() == 1 then
  return Sheath.db.char.Primary
  end
  if GetActiveSpecGroup() == 2 then
  return Sheath.db.char.Secondary
  end
end

function isCityEnabled()
  if IsResting() then
    return Sheath.db.char.CityUnsheathed
  else
    return true
  end
end

function Sheath:slashfunc(input)
	if input == "" or input == "help" then
	  printOptionMenu()

	elseif input == "enable" then
	  enableSheath()

	elseif input == "disable" then
	  disableSheath()

	elseif input == "primary" then
	  togglePrimary()

	elseif input == "secondary" then
	  toggleSecondary()

	elseif input == "togglecity" then
	  toggleCity()

	elseif input == "info" then

	elseif getSlashCommandWithoutParameters(input) == "setCheckTimer" then
	  setCheckTimer(input)
	end
  printStatus()
end

function printOptionMenu()
  print("---------------------------------------------")
  print("Sheath options menu.")
  print("Avaliable options")
  print("/sheath Enable (Enables the addon).")
  print("/sheath Disable (Disables the addon)") 
  print("/sheath togglespec (Disables/Enables sheathing in your current spec.)")
  print("/sheath info (Prints current settings)")
  print("/sheath togglecity (Toggles Sheathing in Cities)")
  print("/sheath setCheckTimer x (Sets the check for sheathed weapons to x seconds")
  print("     x must be greater than 0)")
  print("---------------------------------------------")
end

function printStatus()
  print("Sheath is: " .. booleanToString(Sheath.db.char.EnabledState))
  for i = 1, #Sheath.db.char.Specs do
    print("\124T" .. Sheath.db.char.Specs[i].iconPath .. ":16\124t "
      .. Sheath.db.char.Specs[i].specName 
      .. " is: " 
      .. booleanToString(Sheath.db.char.Specs[i].specEnabled))
  end
  print("You are staying " .. sheathStateToString(getCityUnsheathed()) .. " in cities.")
  print("Checking sheath state every " .. Sheath.db.char.SheathStateCheckTimerInSeconds .. " seconds.")
end
	
function setCheckTimer(input)
	command, argument = Sheath:GetArgs(input, 2)
	newWaitTime = tonumber(argument)
	minimumWaitTime = 1
	if (newWaitTime >= minimumWaitTime) then
	  Sheath.db.char.SheathStateCheckTimerInSeconds = newWaitTime
	  startTimer()
	  print("CheckTimer set to " .. Sheath.db.char.SheathStateCheckTimerInSeconds .. " seconds.")
	else
	  print("CheckTimer requires a number greater than " .. minimumWaitTime .. " seconds.")
	end
end

function isSpecEnabled()
  if #Sheath.db.char.Specs == 0 then
    return true
  else
    return Sheath.db.char.Specs[GetSpecialization()].specEnabled
  end
end

function getCityUnsheathed()
  return Sheath.db.char.CityUnsheathed
end

function sheathStateToString(unsheathed)
  if unsheathed == true then 
    return "\124cFF00FF00Sheathed\124r"
  else 
    return "\124cFFFF0000Unsheathed\124r" 
  end
end

function toggleSpec()
	if (isSpecEnabled() == true) then
	  Sheath.db.char.Specs[GetSpecialization()].specEnabled = false
	else
	  Sheath.db.char.Specs[GetSpecialization()].specEnabled = true
	end
  printSpecStatus()
end

function printSpecStatus()
  print("Sheath is now " .. booleanToString(isSpecEnabled()) .. " for " .. getCurrentSpecName() .. ".")
end

function getCurrentSpecName()
  return Sheath.db.char.Specs[GetSpecialization()].specName
end

function toggleCity()
  if Sheath.db.char.CityUnsheathed then
    Sheath.db.char.CityUnsheathed = true
  else
    Sheath.db.char.CityUnsheathed = false
  end
end

function printCityUnsheathedStatus()
  print("You are now staying " .. sheathStateToString(getCityUnsheathed()) .. " in cities.")
end

function toggleEnable()
  if isSheathEnabled() then
    enableSheath()
  else
    disableSheath()
  end
  printSheathEnabledStatus()
end

function printSheathEnabledStatus()
  print("Sheath is now " .. booleanToString(SheathIsEnabled()) .. ".")
end

function SheathIsEnabled() 
  return Sheath.db.char.EnabledState
end

function enableSheath()
  Sheath.db.char.EnabledState = false
  startTimer()
end

function disableSheath()
  Sheath.db.char.EnabledState = false
  destroyExistingTimer()
end

function getSlashCommandWithoutParameters(input)
  command, argument = Sheath:GetArgs(input, 2)
  return command
end

function booleanToString(boolean)
   if boolean == true then 
     return"\124cFF00FF00Enabled\124r"
   else 
     return "\124cFFFF0000Disabled\124r"
   end
end