uci_print = {}

function uci_print.PrintFileNames()
    local file_list = main_module.scandir("/etc/config")
    if #file_list == 0 then
        print("Error no files in /etc/config")
        return os.exit()
    end
    print("Available config files")
    for index, value in ipairs(main_module.scandir("/etc/config")) do
        print(string.format("[%d] %s",index, value))
    end
end

function uci_print.PrintConfigFile(config)
    local status, value = pcall(x.get_all, x, config)
    if not status then print("Error " .. value .. "  with PrintConfigFile") return uci_main_menu.UCIMainMenu() end
    for _, valu in pairs(value) do
        print("----------------------")
            for key, val in pairs(valu) do
                if (type(val) == 'table') then
                    for _, va in pairs(val) do
                        print(key, va)
                    end
                    else
                        print(key, val)
            end
        end
    end
end

function uci_print.PrintConfigSection(config, section)
    for key, value in pairs(x:get_all(config, section)) do
        if(type(value) == "table")then
            for _,val in pairs(value) do print(key, val)   end
            else
                print(key, value)
        end
    end
end

function uci_print.CreateNewSection(section, type, config)
    print(section, type)
    if section ~= "" then
        x:set(config, section, type)
    else
        x:add(config, type)
    end
end
function uci_print.DeleteSection(section, config)
    x:delete(config, section)
    print("Section deleted")
end
function uci_print.SetValueForOptions(config, section, option, value)
    x:set(config, section, option, value)
end
function uci_print.DeleteOptions(config, section, option)
    x:delete(config, section, option)
end

return uci_print