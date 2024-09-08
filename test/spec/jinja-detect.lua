local yd = require 'yo-dawg'

describe('Detection of various Jinja elements in non-Jinja files', function()
	local nvim

	local function set_content(...)
		nvim:buf_set_lines(0, 0, 0, true, {...})
	end

	before_each(function()
		nvim = yd.start()
	end)

	after_each(function()
		yd.start(nvim)
	end)

	it('detects comments', function()
		set_content('{# A jinja comment #}')
		assert.nvim(nvim).between_rows(1, 1).contains_jinja(1)
	end)

	it('detects statements', function()
		set_content('{% for item in items %}')
		assert.nvim(nvim).between_rows(1, 1).contains_jinja(1)
	end)

	it('detects expressions', function()
		set_content('{{ item }}')
		assert.nvim(nvim).between_rows(1, 1).contains_jinja(1)
	end)

	it('detects line comments', function()
		set_content('## A jinja comment')
		assert.nvim(nvim).between_rows(1, 1).contains_jinja(1)
	end)

	it('detects line statements', function()
		set_content('# for item in items')
		assert.nvim(nvim).between_rows(1, 1).contains_jinja(1)
	end)

	it('adjusts the file types', function()
		local content = [[
{# A jinja comment #}
<html>
    <head>
        <title>Sample HTML file</title>
    </head>
    <body>
        <p>Hello world.</p>
    </body>
</html>]]
		nvim:set_option_value('filetype', 'html', {})
		set_content(table.unpack(vim.split(content, '\n')))
		nvim:call_function('jinja#AdjustFiletype', {})
		assert.nvim(nvim).has_filetype('html.jinja')
	end)
end)
