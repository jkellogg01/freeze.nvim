---@param name string
---@param top? integer
---@param bottom? integer
local capture = function(name, top, bottom)
	top = top or 0
	bottom = bottom or vim.api.nvim_buf_line_count(0)
	-- TODO: come up with a system to fill in the configuration
	-- maybe create a temp config.json file, reference it with --config,
	-- and then delete it after the screenshot is taken?
	vim.fn.system({
		"freeze",
		name,
		"--lines",
		top .. "," .. bottom,
		"--output",
		"nvim-" .. os.date("%Y%m%d%H%M%S") .. ".png",
		"--font.family",
		-- HACK: need to figure out how to actually find the user's font
		"Iosevka Nerd Font Mono",
	})
end

local M = {}

---@class freeze_config
---@field window boolean
---@field theme string
---@field border { radius: integer, width: integer, color: string }
---@field shadow { blur: integer, x: integer, y: integer }
---@field padding [ integer, integer, integer, integer ]
---@field margin string
---@field background string
---@field font { family: string, size: integer, ligatures: boolean }
---@field line_height float

---@param opts freeze_config
M.setup = function(opts)
	M.opts = vim.tbl_deep_extend("force", {
		window = false,
		theme = "charm",
		border = {
			radius = 0,
			width = 0,
			color = "#515151",
		},
		shadow = {
			blur = 0,
			x = 0,
			y = 0,
		},
		padding = {
			20,
			40,
			20,
			20,
		},
		margin = {
			0,
		},
		background = "#171717",
		font = {
			family = "JetBrains Mono",
			size = 14,
			ligatures = true,
		},
		line_height = 1.2,
	}, opts)
end

--[[
functions to implement:

capture_buffer
capture_viewport
capture_selection
--]]

M.capture_buf = function()
	capture(vim.api.nvim_buf_get_name(0))
end

return M
