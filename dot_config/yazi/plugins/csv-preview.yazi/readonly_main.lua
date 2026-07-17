--- @since 26.5.6

local M = {}

local function fail(job, message)
	ya.preview_widget(job, ui.Text.parse(message):area(job.area):wrap(ui.Wrap.YES))
end

function M:peek(job)
	local child, err = Command("sh")
		:arg({
			"-c",
			'exec "${XDG_CONFIG_HOME:-$HOME/.config}/yazi/plugins/csv-preview.yazi/render.py" "$1" "$w" "$h"',
			"sh",
			tostring(job.file.url),
		})
		:env("w", tostring(job.area.w))
		:env("h", tostring(job.area.h))
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return fail(job, "csv-preview: " .. err)
	end

	local i, lines, errors = 0, {}, {}
	repeat
		local line, event = child:read_line()
		if event == 1 then
			errors[#errors + 1] = line
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines[#lines + 1] = line
		end
	until i >= job.skip + job.area.h
	child:start_kill()

	if #errors > 0 then
		fail(job, table.concat(errors))
	elseif job.skip > 0 and i < job.skip + job.area.h then
		ya.emit("peek", { math.max(0, i - job.area.h), only_if = job.file.url, upper_bound = true })
	else
		ya.preview_widget(job, ui.Text.parse(table.concat(lines)):area(job.area):wrap(ui.Wrap.NO))
	end
end

function M:seek(job)
	require("code"):seek(job)
end

return M
