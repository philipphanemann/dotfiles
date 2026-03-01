local source_priority = {
	copilot = 50,
	conventional_commits = 3,
	git = 2,
	lsp = 1,
	path = 0,
	snippets = -1,
	buffer = -2,
	lazydev = -10,
}
local prefix = "<Leader>a"
local free_model_copilot = "claude-sonnet-4.5"
-- Used in codecompanion config
local cc_base = vim.fn.stdpath("config") .. "/ai/codecompanion"

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = true, debounce = 200 },
			panel = { enabled = true },
		},
	},
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				-- Snippet Engine
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
			"fang2hou/blink-copilot",
			{
				"Kaiser-Yang/blink-cmp-git",
				dependencies = "nvim-lua/plenary.nvim",
			},
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "enter",

				-- Add non-stretch accept that is much more confortable to use
				["<C-z>"] = { "select_and_accept" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "git", "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
				providers = {
					lazydev = {
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					git = {
						module = "blink-cmp-git",
						name = "Git",
						enabled = function()
							return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
						end,
						opts = {
							-- options for the blink-cmp-git
						},
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = {
				implementation = "lua",
				sorts = {
					-- 1) Custom source-priority comparator
					function(a, b)
						local pa = source_priority[a.source_id] or 0
						local pb = source_priority[b.source_id] or 0
						if pa ~= pb then
							return pa > pb
						end
						-- 2) Fallback to Blink’s default scoring
						return a.score > b.score
					end,
					-- 3) Then by sort_text to stabilize ties
					"sort_text",
				},
			},

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"Davidyz/VectorCode",
		version = "*", -- optional, depending on whether you're on nightly or release
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
			"folke/snacks.nvim",
			"ravitemer/codecompanion-history.nvim",
		},
		opts = {
			-- adapters and models
			interactions = {
				chat = {
					adapter = {
						name = "copilot",
						model = free_model_copilot,
					},
					tools = {
						opts = {
							default_tools = {
								-- core bundle with most of CCs tools
								"full_stack_dev",

								-- useful MCP servers
								"git",
								"vectorcode",
								"context7",

								-- web stuff
								"duckduckgo_search",
								"fetch_webpage",
							},
						},

						groups = {
							-- one group to rule them all :)
							["all_the_tools"] = {
								description = "All CC tools + MCP + web",
								tools = {
									-- core bundle with most of CCs tools
									"full_stack_dev",

									-- useful MCP servers
									-- NOTE: these are available in the mcp group,
									-- but we make them explicitly available here so
									-- the chat does not need to go through the @{mcp} tool
									-- to get to these very important ones
									"git",
									"vectorcode",
									"context7",

									-- meta-group containing all MCP server tools
									"mcp",

									-- web stuff
									"duckduckgo_search",
									"fetch_webpage",

									-- probably nice to have?
									"next_edit_suggestion",
								},
								opts = { collapse_tools = true },
							},
						},
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = free_model_copilot,
					},
				},
			},

			extensions = {
				-- register MCP Hub as a CodeCompanion extension (official integration)
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						-- expose MCP resources as #{mcp:*} variables
						make_vars = true,
						-- add MCP prompts as /mcp:* slash commands
						make_slash_commands = true,
						-- show MCP tool results directly in chat
						show_result_in_chat = true,
						-- convert MCP servers and tools to CodeCompanion tools/groups
						make_tools = true,
						-- optionally show each server tool individually in chat UI
						show_server_tools_in_chat = true,
						-- add_mcp_prefix_to_tool_names = false,
					},
				},
				-- register VectorCode as a CodeCompanion extension
				vectorcode = {
					opts = {
						add_tool = true,
						add_slash_command = true,
					},
					tool_opts = {
						-- configure all tools with common settings
						["*"] = {
							require_approval_before = false,
							include_in_toolbox = true,
						},
						-- specific config for querying vectorcode DB
						query = {
							chunk_mode = false,
							max_num = 10, -- max files to retrieve
							default_num = 5, -- default files to retrieve
						},
					},
				},
				-- register history extension
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "gh",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "gH",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 0,
						-- Picker interface (auto resolved to a valid picker)
						picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
						---Optional filter function to control which chats are shown when browsing
						chat_filter = function(chat_data)
							-- only use chats from cwd
							local same_cwd = (chat_data.cwd == vim.fn.getcwd())

							-- only keep chats from last 14 days
							local last_seven_days = os.time() - (14 * 24 * 60 * 60)
							local is_recent = chat_data.updated_at ~= nil and chat_data.updated_at >= last_seven_days

							return same_cwd and is_recent
						end,
						-- Customize picker keymaps (optional)
						picker_keymaps = {
							rename = { n = "r", i = "<M-r>" },
							delete = { n = "d", i = "<M-d>" },
							duplicate = { n = "<C-y>", i = "<C-y>" },
						},
						---Automatically generate titles for new chats
						auto_generate_title = true,
						title_generation_opts = {
							---Adapter for generating titles (defaults to current chat adapter)
							adapter = "copilot", -- "copilot"
							---Model for generating titles (defaults to current chat model)
							model = free_model_copilot, -- "gpt-4o"
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 3, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 3,
							format_title = function(original_title)
								-- this can be a custom function that applies some custom
								-- formatting to the title.
								return original_title
							end,
						},
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = false,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,

						-- Summary system
						summary = {
							-- Keymap to generate summary for current chat (default: "gcs")
							create_summary_keymap = "gZ",
							-- Keymap to browse summaries (default: "gbs")
							browse_summaries_keymap = "gz",

							generation_opts = {
								adapter = "copilot", -- defaults to current chat adapter
								model = free_model_copilot, -- defaults to current chat model
								context_size = 90000, -- max tokens that the model supports
								include_references = true, -- include slash command content
								include_tool_outputs = true, -- include tool execution results
								system_prompt = nil, -- custom system prompt (string or function)
								format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
							},
						},

						-- Memory system (requires VectorCode CLI)
						memory = {
							-- Automatically index summaries when they are generated
							auto_create_memories_on_summary_generation = true,
							-- Path to the VectorCode executable
							vectorcode_exe = "vectorcode",
							-- Tool configuration
							tool_opts = {
								-- Default number of memories to retrieve
								default_num = 10,
							},
							-- Enable notifications for indexing progress
							notify = true,
							-- Index all existing memories on startup
							-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
							index_on_startup = true,
						},
					},
				},
			},

			-- UI preferences
			display = {
				action_palette = { provider = "snacks" },
				chat = {
					-- needs to be false, otherwise cant switch adapters :rolleyes:
					show_settings = false,
					show_context = true,
				},
			},

			prompt_library = {
				markdown = {
					dirs = {
						-- globel prompts in this config
						cc_base .. "/prompts",

						-- project local prompts
						".codecompanion/prompts",
					},
				},
			},

			rules = {
				-- Personal defaults (live nvim config)
				personal = {
					description = "Personal defaults (always loaded)",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/personal.md",
					},
				},

				-- task rules (loaded per-prompt via opts.rules)
				task_research = {
					description = "Task: Search then answer",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/task/research.md",
						cc_base .. "/rules/output/research.md",
					},
				},
				task_gtd = {
					description = "Task: GTD (plan + execute)",
					parser = "codecompanion",
					files = { cc_base .. "/rules/task/gtd.md" },
				},
				task_change_summary = {
					description = "Task: Summarize git changes",
					parser = "codecompanion",
					files = { cc_base .. "/rules/task/change-summary.md" },
				},
				task_write_docs = {
					description = "Task: Write documentation",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/task/research.md",
						cc_base .. "/rules/task/write-docs.md",
						cc_base .. "/rules/output/docs.md",
					},
				},
				task_review_changes = {
					description = "Task: Review staged/unstaged diffs",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/task/review-changes.md",
						cc_base .. "/rules/output/review-changes.md",
					},
				},
				task_write_tests = {
					description = "Task: Write tests",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/task/write-tests.md",
						cc_base .. "/rules/output/write-tests.md",
					},
				},
				task_explain_arch = {
					description = "Task: Explain architecture",
					parser = "codecompanion",
					files = {
						cc_base .. "/rules/task/explain-architecture.md",
						cc_base .. "/rules/output/explain-architecture.md",
					},
				},

				-- project rules (autoloaded when present in the repo)
				project = {
					description = "Collection of common files for all projects",
					files = {
						".clinerules",
						".cursorrules",
						".goosehints",
						".rules",
						".windsurfrules",
						".github/copilot-instructions.md",
						"AGENT.md",
						"AGENTS.md",
						{ path = "CLAUDE.md", parser = "claude" },
						{ path = "CLAUDE.local.md", parser = "claude" },
						{ path = "~/.claude/CLAUDE.md", parser = "claude" },
						".codecompanion/rules/project.md",
					},
					is_preset = true,
				},

				-- additional project rules (load on demand)
				project_extra = {
					description = "Additional project rules (load on demand)",
					files = {
						".codecompanion/rules/**/*.md",
					},
				},

				opts = {
					chat = {
						enabled = true,
						autoload = { "personal", "project" },
					},
				},
			},
		},

		keys = {
			{ prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "Actions palette", mode = { "n", "v" } },
			{ prefix .. "c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat toggle", mode = { "n", "v" } },
      -- stylua: ignore
      { prefix .. "C", function() require("codecompanion.adapters.http.copilot.stats").show() end, desc = "Copilot stats", mode = "n" },
			{ prefix .. "A", "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to chat", mode = "v" },
			{ prefix .. "B", "<cmd>CodeCompanionChat Add<cr>", desc = "Add current buffer to chat", mode = "n" },
			{ prefix .. "i", "<cmd>CodeCompanion<cr>", desc = "Inline assistant", mode = { "n", "v" } },
			{ prefix .. "e", ":'<,'>CodeCompanion /explain<cr>", desc = "Explain selection", mode = "v" },
			{ prefix .. "f", ":'<,'>CodeCompanion /fix<cr>", desc = "Fix selection", mode = "v" },
			{ prefix .. "t", ":'<,'>CodeCompanion /tests<cr>", desc = "Generate tests", mode = "v" },
			{ prefix .. "R", "<cmd>CodeCompanionChat RefreshCache<cr>", desc = "Refresh tool cache", mode = "n" },
		},
	},
}
