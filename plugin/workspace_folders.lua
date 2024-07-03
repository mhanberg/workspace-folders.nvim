if not vim.g.workspace then
  local file = vim.fs.find(function(name)
    return vim.fn.fnamemodify(name, ":e") == "code-workspace"
  end, { upward = true })

  if file[1] then
    local workspace
    local path = file[1]
    local dir = vim.fs.dirname(path)
    workspace = vim.json.decode(vim.fn.join(vim.fn.readfile(path), "\n"))
    local name = vim.fn.fnamemodify(path, ":t:r")

    if workspace then
      workspace["name"] = name

      local folders = vim
        .iter(workspace.folders)
        :map(function(folder)
          local full_path = vim.fs.joinpath(dir, folder.path)
          local real_path = vim.uv.fs_realpath(full_path)
          if real_path then
            return {
              name = vim.fs.basename(vim.uv.fs_realpath(folder.path)),
              uri = vim.uri_from_fname(real_path),
            }
          else
            return nil
          end
        end)
        :filter(function(folder)
          return folder ~= nil
        end)
        :totable()

      workspace["folders"] = folders
      vim.g.workspace = workspace
    end
  end
end
