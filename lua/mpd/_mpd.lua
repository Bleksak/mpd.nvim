local config = require('mpd.config').values

local M = {}

-- run mpc command with proper arguments
local function mpc(args)
    return vim
        .system({
            'mpc',
            '--port',
            config.port,
            '--host',
            config.host,
            unpack(args),
        })
        :wait().stdout
end

-- get all songs
function M.songs()
    return vim.split(mpc({ 'listall' }), '\n')
end

-- get all songs on album
function M.songs_on_album(album)
    return vim.split(mpc({ 'find', 'album', album }), '\n')
end

-- add all songs on album
function M.add_album(album)
    mpc({ 'findadd', 'album', album })
end

-- get all albums
function M.albums()
    return vim.split(mpc({ 'list', 'album' }), '\n')
end

-- add song to playlist
function M.add(song)
    mpc({ 'add', song })
end

-- clear playlist
function M.clear()
    mpc({ 'clear' })
end

-- pause
function M.pause()
    mpc({ 'pause' })
end

-- play
function M.play()
    mpc({ 'play' })
end

-- toggle
function M.toggle()
    mpc({ 'toggle' })
end

-- next
function M.next()
    M.pause()
    mpc({ 'next' })
end

-- prev
function M.prev()
    M.pause()
    mpc({ 'prev' })
end

-- shuffle
function M.shuffle()
    mpc({ 'shuffle' })
end

function M.playing()
    local status_line = vim.split(mpc({ 'status' }), '\n')[2]

    if status_line:find('paused') then
        return false
    else
        return true
    end
end

return M
