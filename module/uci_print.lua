uci_print = {}

function uci_print.ScanDirectory(directory)
    directory = directory or ''
    local current_directory = directory
    local file_list = {}
    local command = "ls " .. current_directory .. " -p"

    for file_name in io.popen(command):lines()do
        if string.sub(file_name, -1) == '/' then
            print("Directory is empty")
        elseif string.sub(file_name, -1) == ':' then
            current_directory = string.sub(file_name, 1, -2) .. 'wat'
            current_directory = current_directory .. '/'
            elseif string.len(file_name) == 0 then
                current_directory = directory
                else
                    if type(extensions) == 'table' then
                        for _, extension in ipairs(extensions) do
                            if string.find(file_name,"%." .. extension .. "$") then
                                table.insert(file_list, current_directory .. file_name)
                            end
                        end
                    else
                        table.insert(file_list, current_directory .. " " .. file_name)
                    end
        end
    end
    return file_list
end

function uci_print.PrintFileNames()
    local file_list = uci_print.ScanDirectory("/etc/config")
    if #file_list == 0 then print("Error no files in /etc/config")
    return os.exit()
    end

    print("Available files")
    for index, value in ipairs(uci_print.ScanDirectory("/etc/config")) do
    print(value)
    end
    return uci_main_menu.UCIMainMenu()
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
        
        return uci_main_menu.UCIMainMenu()
end
function uci_print.PrintConfigSection(config, section)
    for key, value in pairs(x:get_all(config, section)) do
        if(type(value) == "table")then
            for _,val in pairs(value) do print(key, val)   end
            else
                print(key, value)
        end
    end
    return uci_main_menu.UCIMainMenu()
end
function uci_print.CreateNewSection(section, type, config)
    print(section, type)
    if section ~= "" then
    x:set(config, section, type)
    else
    x:add(config, type)
    end
    return uci_main_menu.UCIMainMenu()
end
function uci_print.DeleteSection(section, config)
    x:delete(config, section)
    return uci_main_menu.UCIMainMenu()
end
function uci_print.SetValueForOptions(config, section, option, value)
    x:set(config, section, option, value)
    return uci_main_menu.UCIMainMenu()
end
function uci_print.DeleteOptions(config, section, option)
    x:delete(config, section, option)
    return uci_main_menu.UCIMainMenu()
end

return uci_print