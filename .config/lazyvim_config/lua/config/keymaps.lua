-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.co/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- stylua: ignore start

-- Add a keymap for toggling BasedPyright settings
-- This toggles BasedPyright's typeCheckingMode between "basic" and "recommended"
-- and additionally enables/disables inlay hints
Snacks.toggle
  .new({
    name = "BasedPyright Strict Mode",
    get = function()
      local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
      return client
        and client.config.settings.basedpyright.analysis.typeCheckingMode == "recommended"
    end,
    set = function(_)
      require("utils.lsp_utils").toggle_basedpyright_settings({ silent = true })
    end,
  })
  :map("<leader>uP")


Snacks.toggle
  .new({
    name = "virtual_lines",
    get = function()
      return vim.diagnostic.config().virtual_lines
    end,
    set = function(_)
      require("utils.lsp_utils").toggle_virtual_lines({ silent = true })
    end,
  })
  :map("<leader>uv")
--
-- Add a keympa to toggle yamlls using schemastore or not
Snacks.toggle
  .new({
    name = "YAML SchemaStore Toggle",
    get = function()
      local client = vim.lsp.get_clients({ name = "yamlls" })[1]
      return client and client.config.settings.yaml.schemaStore.enable
    end,
    set = function(_)
      require("utils.lsp_utils").toggle_yaml_schema_store({ silent = true })
    end,
  })
  :map("<leader>uy")

-- Toggle automatic spell checker language switching
Snacks.toggle
  .new({
    name = "Spell Language Auto Switching",
    get = function()
      return require("utils.spell_utils").is_enabled()
    end,
    set = function(_)
      require("utils.spell_utils").toggle()
    end,
  })
  :map("<leader>uk")

-- Add some DAP mappings
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Debugger: Start" })
vim.keymap.set("n", "<F6>", function() require("dap").pause() end, { desc = "Debugger: Pause" })
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Debugger: Step Over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Debugger: Step Into" })
vim.keymap.set("n", "<F17>", function() require("dap").terminate() end, { desc = "Debugger: Terminate" }) -- Shift+F5
vim.keymap.set("n", "<F23>", function() require("dap").step_out() end, { desc = "Debugger: Step Out" }) -- Shift+F11
-- stylua: ignore end
--
-- Highlight the current line
vim.keymap.set("n", "<Leader>ck", function()
  local line_num = vim.fn.line(".")
  vim.fn.matchadd("Search", "\\%" .. line_num .. "l")
end, { desc = "highlight line", silent = true })

-- Clear all highlighted matches
vim.keymap.set("n", "<Leader>cj", function()
  vim.fn.clearmatches()
end, { desc = "clear highlighted lines", silent = true })

-- python convenience
function PythonImportStatement()
  -- Get the full path of the current file
  local path = vim.fn.expand("%:p")

  -- Find the project root by looking for a directory containing an __init__.py file
  local root = vim.fn.finddir("**/__init__.py", vim.fn.expand("%:p:h") .. ";")
  root = vim.fn.fnamemodify(root, ":h")

  -- Calculate the relative path from the root to the file
  local relative_path = vim.fn.fnamemodify(path, ":.:" .. root .. "/")

  -- Remove file extension and replace path separators with dots
  local module_path = relative_path:gsub("%.py$", ""):gsub("/", ".")

  -- Create the import statement
  local import_statement = "from " .. module_path .. " import *"

  -- Print the import statement
  print(import_statement)

  -- Optionally, you can copy the import statement to the clipboard
  vim.fn.setreg("+", import_statement)
end

function yank_file_path_to_clipboard()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
  print("Yanked file path to clipboard: " .. file_path)
end

vim.api.nvim_set_keymap("i", "<C-p>", "import pdbp; pdbp.set_trace()<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>yp", ":lua yank_file_path_to_clipboard()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>yI", ":lua PythonImportStatement()<CR>", { noremap = true, silent = true })

-- Disable LazyVim's Alt+j/k line movement
-- since Esc + j/k is treated as such if it does not timeout
-- https://chatgpt.com/share/6818ae78-ee58-8009-bf99-4dd6b09540c2
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
