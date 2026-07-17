--- @since 26.5.6

local IMAGE_EXTENSIONS = {
	avif = true,
	bmp = true,
	gif = true,
	heic = true,
	jpeg = true,
	jpg = true,
	png = true,
	tif = true,
	tiff = true,
	webp = true,
}

local function extension(name)
	local ext = name:match("%.([^.]+)$")
	return ext and ext:lower() or nil
end

local function kind(name)
	local ext = extension(name)
	return ext and ext:upper() or "FILE", ext
end

local claim = ya.sync(function(st, candidates)
	local queued = {}

	for _, candidate in ipairs(candidates) do
		if st.dimensions[candidate.url] == nil then
			-- false represents an in-flight or unavailable result and prevents
			-- duplicate `sips` calls while Yazi revisits the same directory.
			st.dimensions[candidate.url] = false
			queued[#queued + 1] = candidate
		end
	end

	return queued
end)

local update = ya.sync(function(st, dimensions)
	for url, dimension in pairs(dimensions) do
		st.dimensions[url] = dimension
	end
	ui.render()
end)

local function dimensions_from(output)
	local width = output.stdout:match("pixelWidth:%s*(%d+)")
	local height = output.stdout:match("pixelHeight:%s*(%d+)")

	if width and height and tonumber(width) > 0 and tonumber(height) > 0 then
		return width .. "×" .. height
	end
end

local function setup(st, opts)
	st.dimensions = {}
	opts = opts or {}

	Status:children_add(function(self)
		local hovered = self._current.hovered
		if not hovered or hovered.cha.is_dir then
			return ""
		end

		local file_kind = kind(hovered.name)
		local dimension = st.dimensions[tostring(hovered.url)]
		local size = hovered:size()
		local text = file_kind

		if dimension then
			text = text .. " · " .. dimension
		end
		if size then
			text = text .. " · " .. ya.readable_size(size)
		end

		return " " .. text
	end, opts.order or 1100, Status.RIGHT)
end

local function fetch(_, job)
	local candidates = {}

	for _, file in ipairs(job.files) do
		local ext = extension(file.name)
		if not file.cha.is_dir and ext and IMAGE_EXTENSIONS[ext] then
			candidates[#candidates + 1] = {
				url = tostring(file.url),
				path = tostring(file.url),
			}
		end
	end

	local queued = claim(candidates)
	if #queued == 0 then
		return true
	end

	local results = {}
	for _, candidate in ipairs(queued) do
		local output = Command("/usr/bin/sips")
			:arg({ "-g", "pixelWidth", "-g", "pixelHeight", candidate.path })
			:output()

		results[candidate.url] = output and dimensions_from(output) or false
	end

	update(results)
	return true
end

return { setup = setup, fetch = fetch }
