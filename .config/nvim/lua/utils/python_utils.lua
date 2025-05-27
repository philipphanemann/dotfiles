local M = {}

function M.PythonFileImportStatement()
  -- Get the full path of the current file
  local path = vim.fn.expand('%:p')

  -- Find the project root by looking for a directory containing an __init__.py file
  local root = vim.fn.finddir('**/__init__.py', vim.fn.expand('%:p:h') .. ';')
  root = vim.fn.fnamemodify(root, ':h')

  -- Calculate the relative path from the root to the file
  local relative_path = vim.fn.fnamemodify(path, ':.:' .. root .. '/')

  -- Remove file extension and replace path separators with dots
  local module_path = relative_path:gsub('%.py$', ''):gsub('/', '.')

  -- Create the import statement
  local import_statement = 'from ' .. module_path .. ' import *'

  -- Print the import statement
  print(import_statement)

  -- Optionally, you can copy the import statement to the clipboard
  vim.fn.setreg('+', import_statement)
end

function M.yank_file_path_to_clipboard()
  local file_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', file_path)
  print('Yanked file path to clipboard: ' .. file_path)
end

return M
