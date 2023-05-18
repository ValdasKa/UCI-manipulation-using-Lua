main_menu = {}
local main_module = require("module.main_module")

function main_menu.ConfigFile()
  print("Select config file from below in number")
  print("---------------------------------------------")
  local file_list = main_module.scandir("/etc/config")
  local inp, opt = nil, {}

  for index, value in ipairs(file_list) do
    opt[tostring(index)] = value
    print(string.format("%d : %s",index, value))
  end
  repeat inp = io.read() until opt[inp]
  if inp == "x" then return opt[inp]() end
  return opt[inp]
end

local function handleInputt(options)
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
      os.exit()
     end
  return options[line]()
end

function main_menu.MainMenu()
  
    print("Main menu")
    print("[1] Move to UCI functions menu")
    print("[x] exit")
    return handleInputt{
      ["1"] = function() main_module.UCIFunctionsMenu(main_menu.ConfigFile()) end,
      ["x"] = os.exit,
    }
  end

return main_menu