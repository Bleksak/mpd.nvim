local config = require('mpd.config').values

local M = {}

local function pactl(args)
    local handle = io.popen('pactl ' .. table.concat(args, ' '))

    if handle == nil then
        return nil
    end

    local result = handle:read("a")
    handle:close()

    return result
end

local function get_sinks()
    return pactl({ 'list', 'sink-inputs' })
end

local function get_mpd_sink()
    local sinks_string = get_sinks()

    if sinks_string == nil then
        return nil
    end

    local last_sink_id = nil
    local last_volume = 0

    local sink_lines = vim.split(sinks_string, "\n")

    for _, line in ipairs(sink_lines) do
        local match = string.match(line, "Sink Input #(%d+)")
        if match then
            last_sink_id = tonumber(match)
            goto continue
        end

        -- Volume: front-left: 29491 /  45% / -20,81 dB,   front-right: 29491 /  45% / -20,81 dB
        match = string.match(line, "Volume: *")
        if match then
            last_volume = string.match(line, "(%d+)%%")
            goto continue
        end

        if string.match(line, "application%.name") then
            if string.match(line, "=%s*\"(.*)\"") == config.sink_name then
                return { last_sink_id, last_volume }
            end
        end

        ::continue::
    end

    return nil
end

M.get_mpd_volume = function()
    local sink_packed = get_mpd_sink()

    if sink_packed == nil then
        return nil
    end

    local volume = sink_packed[2]

    return volume
end

M.set_mpd_volume = function(volume)
    local sink_packed = get_mpd_sink()

    if sink_packed == nil then
        return nil
    end

    local sink = sink_packed[1]
    pactl({ 'set-sink-input-volume', sink, volume .. '%' })
end

return M
