main_menu = {}
local main_module = require("main_module")

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
  -- main_menu.ConfigFile()
function handleInput(options)
    local input
   repeat input = io.read() until options[input]
 
   return options[input]()
end

function main_menu.MainMenu()
  
    print("Main menu")
    print("[1] Move to UCI functions menu")
    -- print("[2] Print config files")
    print("[x] exit")
    
    return handleInput{
      ["1"] = function() main_module.UCIFunctionsMenu(main_menu.ConfigFile()) end,--(tostring(main_module.ScanDirectory("/etc/config"))) end,
      -- ["2"] = function () main_menu.ConfigFile() end,
      ["x"] = os.exit,
    }
  end
--   main_menu.MainMenu()


return main_menu