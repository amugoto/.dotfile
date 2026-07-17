Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

Status:children_add(function(self)
	return " " .. tostring(self._current.cwd)
end, 3300, Status.LEFT)

require("image-meta"):setup {
	-- Yazi 기본 권한(Status:perm)은 order 1000으로 가장 먼저 표시된다.
	order = 1100,
}
