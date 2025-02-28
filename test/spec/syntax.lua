local yd = require 'yo-dawg'

describe('Syntax highlighting', function()
	local nvim

	before_each(function()
		nvim = yd.start()
		nvim:cmd({cmd = 'edit', args = {'test/files/sample.jinja'}}, {})
		nvim:set_option_value('filetype', 'jinja', {buf = 0})
	end)

	after_each(function()
		yd.stop(nvim)
	end)

	it('highlights comments', function()
		assert.nvim(nvim).at_position(1,  1).has_hlgroup('jinjaCommentDelim')
		assert.nvim(nvim).at_position(1,  2).has_hlgroup('jinjaCommentDelim')
		assert.nvim(nvim).at_position(1,  5).has_hlgroup('jinjaComment')
		assert.nvim(nvim).at_position(1, 46).has_hlgroup('jinjaCommentDelim')
		assert.nvim(nvim).at_position(1, 47).has_hlgroup('jinjaCommentDelim')
	end)

	it('highlights variable blocks', function()
		assert.nvim(nvim).at_position(4,  1).has_hlgroup('jinjaVarDelim')
		assert.nvim(nvim).at_position(4,  2).has_hlgroup('jinjaVarDelim')
		assert.nvim(nvim).at_position(4,  3).has_hlgroup('jinjaVarBlock')
		assert.nvim(nvim).at_position(4,  4).has_hlgroup('jinjaVariable')
		assert.nvim(nvim).at_position(4, 13).has_hlgroup('jinjaVarDelim')
		assert.nvim(nvim).at_position(4, 14).has_hlgroup('jinjaVarDelim')
	end)

	it('highlights operators', function()
		assert.nvim(nvim).at_position(5, 13).has_hlgroup('jinjaOperator')
	end)

	it('highlights nested arguments', function()
		assert.nvim(nvim).at_position(6, 25).has_hlgroup('jinjaNested')
	end)

	it('highlights filters', function()
		assert.nvim(nvim).at_position(5, 15).has_hlgroup('jinjaFilter')
		assert.nvim(nvim).at_position(7, 21).has_hlgroup('jinjaFilter')
	end)

	it('highlights statement blocks', function()
		assert.nvim(nvim).at_position(10, 1).has_hlgroup('jinjaTagDelim')
		assert.nvim(nvim).at_position(10, 2).has_hlgroup('jinjaTagDelim')
		assert.nvim(nvim).at_position(10, 3).has_hlgroup('jinjaTagBlock')
		assert.nvim(nvim).at_position(10, 4).has_hlgroup('jinjaStatement')
	end)
end)
