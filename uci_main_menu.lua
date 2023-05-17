uci_main_menu = {}
local uci_print = require("uci_print")
local config

function uci_main_menu.Section()
  local inp, opt, i = nil, {}, 0
  print("-----------------------------------------------------")
  local status , value = pcall(x.get_all, x, config)
  for _, index in pairs(value) do
    i = i + 1
    opt[tostring(i)] = index[".name"]
    print(string.format(i, index[".name"]))
  end
  print("take section")
  repeat inp = io.read() until opt[inp]
  if inp == "x" then return opt[inp]() end
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
  local inp, opt, i = nil, {}, 0
  local status, value = pcall(x.get_all, x, config)
  for key, val in pairs(value) do
    i = i + 1
    opt[tostring(i)] = key
    if type(val) == "table" then
      print(i, key)
    else
      print(i, key, val)
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
  repeat inp = io.read()
    if(inp ~= "") then
    table.insert(value, inp)
    end
  until inp == ""
  return option, value
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
  print("[x] exit")

  return handleInput{
    ["1"] = uci_print.PrintFileNames,
    ["2"] = function() uci_print.PrintConfigFile(config) end,
    ["3"] = function() uci_print.PrintConfigSection(config, uci_main_menu.Section()) end,
    ["4"] = function() local section, type = uci_main_menu.SectionInput()
      uci_print.CreateNewSection(section, type, config)  end,
    ["5"] = function() uci_print.DeleteSection(uci_main_menu.Section(), config) end,
    ["6"] = function() local option, value = uci_main_menu.OptionInput(uci_main_menu.Option())
    uci_print.SetValueForOptions(config, uci_main_menu.Section(), option, value) end,
    ["7"] = function() uci_print.DeleteOptions(config, uci_main_menu.Section(), uci_main_menu.Option()) end,
    ["8"] = function() local status, value = pcall(x.commit, config)
    if not status then print("error" .. value .. " with commit") end
    return uci_main_menu.UCIMainMenu() end,
    ["x"] = os.exit,
  }
end

function handleInput(options)
  local input
 repeat input = io.read() until options[input]
 return options[input]()
end

function uci_main_menu.SwapToUCIMenu(configdir)
  config = configdir
  uci_main_menu.UCIMainMenu()
end


return uci_main_menu 