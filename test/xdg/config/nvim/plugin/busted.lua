-- Custom configuration for busted

-- If busted is not available this configuration is not running as part of a
-- test, so there is nothing to do.
local success, say = pcall(require, 'say')
if not success then
	return
end
local assert = require 'luassert'

---Globally unique keys to retrieve the values from the current test state.
local NVIM_STATE_KEY, ROW_STATE_KEY, COL_STATE_KEY = {}, {}, {}

---Add the Neovim client to the current test state.
local function nvim_client(state, args, _level)
	assert(args.n > 0, "No Neovim channel provided to the modifier")
	assert(rawget(state, NVIM_STATE_KEY) == nil, "Neovim already set")
	rawset(state, NVIM_STATE_KEY, args[1])
	return state
end

---Adds a (row, column) position pair (1-indexed) to the current test state.
local function at_position(state, args, _level)
	assert(args.n == 2, 'Wrong number of arguments given to modifier')
	rawset(state, ROW_STATE_KEY, args[1])
	rawset(state, COL_STATE_KEY, args[2])
	return state
end

---Assertion that the current Neovim client at the current position has the
---given highlight group.
local function has_hlgroup(state, args)
	assert(args.n == 1, 'No highlight group provided')
	local nvim = rawget(state, NVIM_STATE_KEY)
	local row = rawget(state, ROW_STATE_KEY) - 1
	local column = rawget(state, COL_STATE_KEY) - 1
	local hlgroup = args[1]

	local syntax = nvim
		:exec_lua('return vim.inspect_pos(...)', {0, row, column, {syntax=true}})
		.syntax
	local result = vim.iter(syntax)
		:map(function(x) return x.hl_group end)
		:find(hlgroup)

	return result == hlgroup
end

---Assert that the current buffer has the expected file type
local function has_filetype(state, args, _level)
	assert(args.n == 1, 'No file type provided')
	local nvim = rawget(state, NVIM_STATE_KEY)
	local filetype = args[1]

	return filetype == nvim:get_option_value('filetype', {})
end

say:set('assertion.hlgroup_at.positive', 'Expected highlight group %s')
say:set('assertion.hlgroup_at.negative', 'Unexpected highlight group %s')

say:set('assertion.has_filetype.positive', 'Expected file type %s')
say:set('assertion.has_filetype.negative', 'Unexpected file type %s')

assert:register('modifier', 'nvim', nvim_client)
assert:register('modifier', 'at_position', at_position)
assert:register(
	'assertion', 'has_hlgroup', has_hlgroup,
	'assertion.hlgroup_at.positive', 'assertion.hlgroup_at.negative'
)
assert:register(
	'assertion', 'has_filetype', has_filetype,
	'assertion.has_filetype.positive', 'assertion.has_filetype.negative'
)
