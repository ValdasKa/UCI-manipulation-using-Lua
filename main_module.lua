main_module = {}
local uci_main_menu = require("uci_main_menu")

function main_module.scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -h "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function main_module.UCIFunctionsMenu(config)
    return uci_main_menu.SwapToUCIMenu(config)
end

return main_module
