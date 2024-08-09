local config = require('mpd.config')

local M = {}

function M.setup(opts)
  config.values = vim.tbl_deep_extend('keep', opts or {}, config.values)
end

M.actions = require('mpd._ui').actions
M.find_song = require('mpd._ui').song
M.find_album = require('mpd._ui').album
M.set_volume = require('mpd._ui').set_volume

M.playing = require('mpd._mpd').playing
M.get_volume = require('mpd._volume').get_mpd_volume

M.pause = require('mpd._mpd').pause
M.play = require('mpd._mpd').play
M.toggle = require('mpd._mpd').toggle
M.next = require('mpd._mpd').next
M.prev = require('mpd._mpd').prev
M.shuffle = require('mpd._mpd').shuffle

return M
