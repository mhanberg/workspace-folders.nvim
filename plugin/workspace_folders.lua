if not vim.fs.joinpath then
	function vim.fs.joinpath(...)
		return (table.concat({ ... }, "/"):gsub("//+", "/"))
	end
end

local uv = vim.uv or vim.loop

if not vim.g.workspace then
	local file = vim.fs.find(function(name)
		return vim.fn.fnamemodify(name, ":e") == "code-workspace"
	end, { upward = true })

	if file[1] then
		local workspace
		local path = file[1]
		local dir = vim.fs.dirname(path)
		local handle = io.open(path)
		if handle then
			workspace = vim.json.decode(handle:read("*a"))
			handle:close()
		end
		local name = vim.fn.fnamemodify(path, ":t:r")

		if workspace then
			workspace["name"] = name

			local folders = vim.tbl_map(function(folder)
				local uri = vim.uri_from_fname(uv.fs_realpath(vim.fs.joinpath(dir, folder.path)))
				local folder_name = vim.fs.basename(uv.fs_realpath(folder.path))

				return { name = folder_name, uri = uri }
			end, workspace.folders)

			workspace["folders"] = folders
			vim.g.workspace = workspace
		end
	end
end
