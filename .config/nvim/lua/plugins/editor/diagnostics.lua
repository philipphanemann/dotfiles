local function set_method_marker_highlight()
    vim.api.nvim_set_hl(0, "TroublePythonMethodMarker", { italic = true })
end

set_method_marker_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("TroublePythonSymbols", { clear = true }),
    callback = set_method_marker_highlight,
})

local function python_symbol_info(ctx)
    local symbol = ctx.item.symbol
    local buf = ctx.item.buf
    local row = ctx.item.pos and ctx.item.pos[1]
    if not symbol or not symbol.name or not buf or not row or not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "python" then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, row, false)
    local line = lines[row]
    local name = vim.pesc(symbol.name)
    local args = line and (line:match("^%s*async%s+def%s+" .. name .. "%s*(.*)$")
        or line:match("^%s*def%s+" .. name .. "%s*(.*)$"))
    if not args then
        return
    end

    local method
    if ctx.item.kind == "Method" then
        method = "instance"
        for i = row - 1, 1, -1 do
            local decorator = lines[i]:match("^%s*@([%w_%.]+)")
            if not decorator then
                break
            end
            decorator = decorator:match("([%w_]+)$")
            if decorator == "staticmethod" or decorator == "classmethod" then
                method = decorator
                break
            end
        end
    end

    return args, method
end

local function omit_first_parameter(args, parameter)
    local first, rest = args:match("^%(%s*([^,]+),%s*(.*)$")
    if not first then
        first, rest = args:match("^%(%s*([^)]*)%)(.*)$")
    end
    if first and first:match("^([%a_][%w_]*)") == parameter then
        return "(" .. rest
    end
    return args
end

return {
    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
                symbols = {
                    win = { position = "right", size = 50 },
                    format = "{kind_icon} {symbol.name} {text:Comment}",
                    formatters = {
                        text = function(ctx)
                            local args, method = python_symbol_info(ctx)
                            if not args then
                                return { text = ctx.value }
                            end
                            if method == "instance" then
                                args = omit_first_parameter(args, "self")
                            elseif method == "classmethod" then
                                args = omit_first_parameter(args, "cls")
                            end
                            return { text = args }
                        end,
                        kind_icon = function(ctx)
                            local _, method = python_symbol_info(ctx)
                            if method == "staticmethod" then
                                return { text = "𝓈", hl = "TroublePythonMethodMarker" }
                            elseif method == "classmethod" then
                                return { text = "𝒸", hl = "TroublePythonMethodMarker" }
                            end

                            local kind = ctx.item.kind
                            local icon = ctx.opts.icons.kinds[kind]
                            if icon then
                                return { text = icon, hl = "TroubleIcon" .. kind }
                            end
                        end,
                    },
                },
            },
        },
        specs = {
            "folke/snacks.nvim",
            opts = function(_, opts)
                return vim.tbl_deep_extend("force", opts or {}, {
                    picker = {
                        actions = require("trouble.sources.snacks").actions,
                        win = {
                            input = {
                                keys = {
                                    ["<c-t>"] = {
                                        "trouble_open",
                                        mode = { "n", "i" },
                                    },
                                },
                            },
                        },
                    },
                })
            end,
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            -- overwrite using aerial
            { "<leader>cs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols (Trouble)" },
            { "<leader>cS", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP references/definitions/... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify("Quickfix list is empty – open Trouble first\n" .. err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify("Quickfix list is empty – open Trouble first\n" .. err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
}
