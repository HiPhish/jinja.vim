local yd = require 'yo-dawg'

describe('File type settings', function ()
	local nvim

	before_each(function()
		nvim = yd.start()
		nvim:command 'edit test/files/sample.jinja'
	end)

	after_each(function ()
		yd.stop(nvim)
	end)

	it('contain the commentstring', function()
		local commentstring = nvim:eval('&commentstring')
		assert.are_same('{# %s #}', commentstring)
	end)
end)
