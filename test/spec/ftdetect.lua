local yd = require 'yo-dawg'

describe('File type detection', function()
	local nvim

	before_each(function()
		nvim = yd.start()
	end)

	after_each(function()
		yd.stop(nvim)
	end)

	describe('Based on file extension', function()
		it('recognizes the file extension `.jinja`', function()
			nvim:command('file foo.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
		end)

		it('recognizes the file extension `.jinja2`', function()
			nvim:command('file foo.jinja2')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
		end)

		it('recognizes the file extension `.j2`', function()
			nvim:command('file foo.j2')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
		end)

		it('recognizes two file extension', function()
			nvim:command('file foo.html.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
		end)

		it('handles three file extension', function()
			nvim:command('file foo.tex.html.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
		end)

		it('ignores unknown file extensions', function()
			nvim:command('file foo.nonsense.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
		end)

		it('handles file names with percent character', function()
			nvim:command('file ' ..  vim.fn.fnameescape('foo%bar.html.jinja'))
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
		end)
	end)

	describe('Idemptence', function()
		it('detects Jinja only once', function()
			-- NOTE: we use XML instead of HTML as our other file type because
			-- out of the box Neovim would detect the file content as
			-- `htmldjango` instead of `html`
			local tempname = nvim:eval('tempname() .. ".xml.jinja"')
			nvim:cmd({cmd = 'write', args = {tempname}}, {})
			nvim:buf_set_lines(0, 0, 0, true, {'{# This is a Jinja comment #}'})
			nvim:cmd({cmd = 'write', args = {tempname}}, {})
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('xml.jinja')
		end)

		it('appends `jinja` only once', function()
			nvim:command('file foo.html.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
			nvim:command('file foo.nonsense.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
		end)
	end)

	describe('Adjustment', function()
		it('adds new file type when necessary', function()
			nvim:command('file foo.nonsense.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('jinja')
			nvim:command('file foo.html.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
		end)

		it('changes file type when necessary', function()
			-- TODO
			nvim:command('file foo.html.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('html.jinja')
			nvim:command('file foo.xml.jinja')
			nvim:command('filetype detect')
			assert.nvim(nvim).has_filetype('xml.jinja')
		end)
	end)
end)
