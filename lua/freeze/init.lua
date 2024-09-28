---@class freeze_config
---@field window? boolean
---@field theme? string
---@field border? { radius: integer, width: integer, color: string }
---@field shadow? { blur: integer, x: integer, y: integer }
---@field padding? integer[]
---@field margin? integer[]
---@field background? string
---@field font? { family: string, size: integer, ligatures: boolean }
---@field line_height? float
---@field show_line_numbers? boolean

local M = {}

M.setup = function(opts)
	M.user_opts = opts
end

--[[
functions to implement:

capture_buffer
capture_viewport
capture_selection
--]]

---@param bufnr integer
---@param opts freeze_config
---@param top? integer
---@param bottom? integer
M.capture = function(bufnr, opts, top, bottom)
	opts = vim.tbl_deep_extend("keep", opts, {
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
		margin = { 0 },
		background = "#171717",
		font = {
			family = "JetBrains Mono",
			size = 14,
			ligatures = true,
		},
		line_height = 1.2,
		show_line_numbers = false,
	})
	local result_path = vim.fn.stdpath("data") .. "/freeze/nvim-" .. os.date("%Y%m%d%H%M%S") .. ".png"
	top = top or 0
	bottom = bottom or vim.api.nvim_buf_line_count(bufnr)
	vim.inspect(vim.system({
		"freeze",
		vim.api.nvim_buf_get_name(bufnr),
		"--lines=" .. top .. "," .. bottom,
		"--output=" .. result_path,
		"--window=" .. tostring(opts.window or "false"),
		"--theme=" .. opts.theme,
		"--border.radius=" .. tostring(opts.border.radius),
		"--border.width=" .. tostring(opts.border.width),
		"--border.color=" .. opts.border.color,
		"--shadow.blur=" .. tostring(opts.shadow.blur),
		"--shadow.x=" .. tostring(opts.shadow.x),
		"--shadow.y=" .. tostring(opts.shadow.y),
		"--padding=" .. table.concat(opts.padding, ","),
		"--margin=" .. table.concat(opts.margin, ","),
		"--background=" .. opts.background,
		"--font.family=" .. opts.font.family,
		"--font.size=" .. tostring(opts.font.size),
		"--font.ligatures=" .. tostring(opts.font.ligatures),
		"--line-height=" .. tostring(opts.line_height),
		"--show-line-numbers=" .. tostring(opts.show_line_numbers),
	}, {}, function(result)
		print(result.code, result.stderr)
		if result.code == 0 then
			print("capture saved at", result_path)
		end
	end))
end

function M.capture_buffer(bufnr)
	M.capture(bufnr or 0, M.user_opts)
end

function M.capture_selection()
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	M.capture(0, M.user_opts, start_line, end_line)
end

function M.capture_viewport()
	local start_line = vim.fn.line("w0")
	local end_line = vim.fn.line("w$")
	M.capture(0, M.user_opts, start_line, end_line)
end

return M
