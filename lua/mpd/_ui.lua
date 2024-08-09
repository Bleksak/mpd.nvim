local mpd = require('mpd._mpd')
local volume = require('mpd._volume')

local M = {}

function M.song(opts)
    vim.ui.select(mpd.songs(), opts or {}, mpd.add)
end

function M.album(opts)
    vim.ui.select(mpd.albums(), opts or {}, mpd.add_album)
end

function M.set_volume()
    local current_volume = volume.get_mpd_volume()

    vim.ui.input({ prompt = 'Volume (current ' .. current_volume .. '%): ', cancelreturn = nil }, function(input)
        if input == nil then
            return
        end
        volume.set_mpd_volume(input)
    end)
end

function M.actions(opts)
    local actions = {
        mpd.next,
        mpd.prev,
        M.song,
        M.album,
        mpd.clear,
        mpd.pause,
        mpd.play,
        mpd.toggle,
        mpd.shuffle,
        M.set_volume,
    }

    vim.ui.select({
        'Next / Skip',
        'Previous',
        'Add Song',
        'Add Album',
        'Clear Playlist',
        'Pause',
        'Play',
        'Toggle',
        'Shuffle',
        'Set Volume',
    }, opts or {}, function(choice, idx)
        if choice == nil then
            return
        end

        actions[idx]()
    end)
end

return M
