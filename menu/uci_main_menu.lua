uci_main_menu = {}
local uci_print = require("module.uci_print")
local config

function uci_main_menu.Section()
  local inp, opt, i = nil, {}, 0
  print("-----------------------------------------------------")
  local status , value = pcall(x.get_all, x, config)
  if not status then 
    print("Error " .. value .. " with Section") 
  end
  for _, index in pairs(value) do
    i = i + 1
    opt[tostring(i)] = index[".name"]
    print(string.format(i, index[".name"]))
  end
  print("take section")
  repeat inp = io.read() until opt[inp]
  if inp == "x" then
    return opt[inp]()
  end
  return opt[inp]
end

function uci_main_menu.SectionInput()
  local section, type
  print("add section name")
  repeat section = io.read() until section
  print("add type")
  repeat type = io.read() until type ~= ""
  return section, type
end

function uci_main_menu.Option()
  print("Select which option type want add")
  local inp, opt, i = nil, {}, 0
  local status, value = pcall(x.get_all, x, config)
  if not status then print("Error " .. value .. " with Option") end
  for key, val in pairs(value) do
    i = i + 1
    opt[tostring(i)] = key
    if type(val) == "table" then
      print(string.format("%d : %s",i, key))
    else
      print(i, key, tostring(val))
    end
  end
  
  repeat inp = io.read() until opt[inp]
  if inp == "x" then return opt[inp]() end
  return opt[inp]
end

function uci_main_menu.OptionInput(option, newvalue) 
  local status, value = pcall(x.get_all, x, config, option)
  if not status or newvalue then value = {} end
  local inp
  print("Write info that you want add if done enter empty text")
  repeat inp = io.read()
    if(inp ~= "") then
    table.insert(value, inp)
    end
  until inp == ""
  return option, value
end
function uci_main_menu.OptionType()
  local input
  print("Enter option type")
  repeat input = io.read()
  until input ~= ""
  return uci_main_menu.OptionInput(input, true)
end


function uci_main_menu.UCIMainMenu()
  print("---------------------------------------")
  print("UCI functions main menu")
  print("---------------------------------------")
  print("Config file name: ",config)
  print("---------------------------------------")
  print("[1] Print the list of configuration files available on the system")
  print("[2] Print the whole selected configuration file")
  print("[3] Print the value of your desired section")
  print("[4] Create a new section in configuration file with different types")
  print("[5] Delete a section in the configuration file")
  print("[6] Set a value for an option")
  print("[7] Delete an option")
  print("[8] Commit changes")
  print("[x] Return to main menu")
  return handleInput{
    ["1"] = function() uci_print.PrintFileNames() return uci_main_menu.UCIMainMenu() end,
    ["2"] = function() uci_print.PrintConfigFile(config) return uci_main_menu.UCIMainMenu() end,
    ["3"] = function() uci_print.PrintConfigSection(config, uci_main_menu.Section()) return uci_main_menu.UCIMainMenu() end,
    ["4"] = function() local section, type = uci_main_menu.SectionInput()
    uci_print.CreateNewSection(section, type, config) return uci_main_menu.UCIMainMenu() end,
    ["5"] = function() uci_print.DeleteSection(uci_main_menu.Section(), config) return uci_main_menu.UCIMainMenu() end,
    ["6"] = function() local option, value = uci_main_menu.OptionType()
    uci_print.SetValueForOptions(config, uci_main_menu.Section(), option, value) return uci_main_menu.UCIMainMenu() end,
    ["7"] = function() uci_print.DeleteOptions(config, uci_main_menu.Section(), uci_main_menu.Option()) return uci_main_menu.UCIMainMenu() end,
    ["8"] = function() local status, value = pcall(x.commit, config)
    if not status then print("error" .. value .. " with commit") end
    return uci_main_menu.UCIMainMenu() end,
    ["x"] = function() main_menu.MainMenu() end,
  }
end

function handleInput(options)
  local line = ""
  while line == ("" or nil) do
    io.stdout:write("Enter your option: ")
     line = io.read("*l") 
     if line == ("" or nil) then
        print("You entered an empty line. Please try again")
       end 
     end 
     if options[line] == nil then
      print("Not existing value " .. line .. " use from above listed")
      uci_main_menu.UCIMainMenu()
     end
  return options[line]()
end

function uci_main_menu.SwapToUCIMenu(configdir)
  config = configdir
  uci_main_menu.UCIMainMenu()
end


return uci_main_menu 