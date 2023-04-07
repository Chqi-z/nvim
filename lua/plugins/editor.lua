local Util = require("util")

return {

	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
		},
	},

	-- search/replace in multiple files
	{
		"windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			-- { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
			{ "<leader>fw", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			{ "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sw", Util.telescope("grep_string"), desc = "Word (root dir)" },
			{ "<leader>sW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
			{
				"<leader>uC",
				Util.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				Util.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<c-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(...)
						end,
						["<a-i>"] = function()
							Util.telescope("find_files", { no_ignore = true })()
						end,
						["<a-h>"] = function()
							Util.telescope("find_files", { hidden = true })()
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						-- ["<C-j>"] = actions.move_selection_next,
						["<C-j>"] = function(...)
							return require("telescope.actions").move_selection_next(...)
						end,
						-- ["<C-k>"] = actions.move_selection_previous,
						["<C-k>"] = function(...)
							return require("telescope.actions").move_selection_previous(...)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
						-- ["<C-c>"] = actions.close,
						["<C-c>"] = function(...) 
              return require("telescope.actions").close(...)
            end,
						-- ["<Esc>"] = actions.close,
						["<Esc>"] = function(...) 
              return require("telescope.actions").close(...)
            end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
	},

	-- easily jump to any location and enhanced f/t motions for Leap
	{
		"ggandor/flit.nvim",
		keys = function()
			---@type LazyKeys[]
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},

	-- TODO:
	-- which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			local nopts = {
				mode = "n", -- NORMAL mode
				prefix = "<leader>",
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = true, -- use `nowait` when creating keymaps
			}
			local keymaps = {
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["gz"] = { name = "+surround" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader><tab>"] = { name = "+tabs" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>g"] = { name = "+git" },
				["<leader>gh"] = { name = "+hunks" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+windows" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
			}
			local mappings = {
				-- 	["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
				["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle" },
        ["o"] = { "<cmd>ClangdSwitchSourceHeader<cr>", "switch header file/source file"},
        ["a"] = { "<cmd>AerialToggle<CR>", "Toggle Aerial" },
				-- 	["o"] = { "<cmd>AerialToggle<cr>", "Toggle Outline" },
				-- 	["s"] = {
				-- 		name = "Split Window",
				-- 		p = { "<cmd>sp<cr>", "Split Window" },
				-- 	},
				-- 	["v"] = {
				-- 		name = "Virtical Split Window",
				-- 		s = { "<cmd>vs<cr>", "Virtical Split Window" },
				-- 	},
				-- 	["c"] = {
				-- 		name = "Close Window",
				-- 		c = { "<C-w>c", "Close Current Window" },
				-- 		o = { "<C-w>o", "Close Others Windows" },
				-- 	},
				-- 	d = {
				-- 		name = "Debug",
				-- 		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
				-- 		b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
				-- 		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
				-- 		C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
				-- 		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
				-- 		g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
				-- 		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
				-- 		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
				-- 		u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
				-- 		p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
				-- 		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
				-- 		s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
				-- 		q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
				-- 		U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
				-- 	},
				-- 	b = {
				-- 		name = "Buffers",
				-- 		j = { "<cmd>BufferLinePick<cr>", "Jump" },
				-- 		f = { "<cmd>Telescope buffers<cr>", "Find" },
				-- 		b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
				-- 		n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
				-- 		-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
				-- 		e = {
				-- 			"<cmd>BufferLinePickClose<cr>",
				-- 			"Pick which buffer to close",
				-- 		},
				-- 		h = {
				-- 			"<cmd>BufferLineCloseLeft<cr>",
				-- 			"Close all to the left",
				-- 		},
				-- 		l = {
				-- 			"<cmd>BufferLineCloseRight<cr>",
				-- 			"Close all to the right",
				-- 		},
				-- 		D = {
				-- 			"<cmd>BufferLineSortByDirectory<cr>",
				-- 			"Sort by directory",
				-- 		},
				-- 		L = {
				-- 			"<cmd>BufferLineSortByExtension<cr>",
				-- 			"Sort by language",
				-- 		},
				-- 	},
				-- 	f = {
				-- 		name = "Telescope find",
				-- 		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				-- 		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				-- 		f = { "<cmd>Telescope find_files<cr>", "Find File" },
				-- 		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				-- 		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
				-- 		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				-- 		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
				-- 		R = { "<cmd>Telescope registers<cr>", "Registers" },
				-- 		t = { "<cmd>Telescope live_grep<cr>", "Text" },
				-- 		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				-- 		C = { "<cmd>Telescope commands<cr>", "Commands" },
				-- 		b = { "<cmd>Telescope file_browser<cr>", "File Browser" },
				-- 	},
				-- 	m = {
				-- 		name = "Markdown",
				-- 		p = { "<Plug>MarkdownPreviewToggle", "Markdown Preview" },
				-- 	},
				-- 	p = {
				-- 		name = "Packer",
				-- 		c = { "<cmd>PackerCompile<cr>", "Compile" },
				-- 		i = { "<cmd>PackerInstall<cr>", "Install" },
				-- 		r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
				-- 		s = { "<cmd>PackerSync<cr>", "Sync" },
				-- 		S = { "<cmd>PackerStatus<cr>", "Status" },
				-- 		u = { "<cmd>PackerUpdate<cr>", "Update" },
				-- 	},
				-- 	g = {
				-- 		name = "Git",
				-- 		-- g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
				-- 		j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
				-- 		k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
				-- 		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				-- 		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				-- 		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				-- 		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				-- 		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				-- 		u = {
				-- 			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
				-- 			"Undo Stage Hunk",
				-- 		},
				-- 		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				-- 		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				-- 		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				-- 		C = {
				-- 			"<cmd>Telescope git_bcommits<cr>",
				-- 			"Checkout commit(for current file)",
				-- 		},
				-- 		d = {
				-- 			"<cmd>Gitsigns diffthis HEAD<cr>",
				-- 			"Git Diff",
				-- 		},
				-- 	},
				-- 	l = {
				-- 		name = "LSP",
				-- 		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
				-- 		d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
				-- 		w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
				-- 		-- f = { require("lvim.lsp.utils").format, "Format" },
				-- 		f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
				-- 		i = { "<cmd>LspInfo<cr>", "Info" },
				-- 		I = { "<cmd>Mason<cr>", "Mason Info" },
				-- 		j = {
				-- 			vim.diagnostic.goto_next,
				-- 			"Next Diagnostic",
				-- 		},
				-- 		k = {
				-- 			vim.diagnostic.goto_prev,
				-- 			"Prev Diagnostic",
				-- 		},
				-- 		l = { vim.lsp.codelens.run, "CodeLens Action" },
				-- 		q = { vim.diagnostic.setloclist, "Quickfix" },
				-- 		r = { vim.lsp.buf.rename, "Rename" },
				-- 		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				-- 		S = {
				-- 			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				-- 			"Workspace Symbols",
				-- 		},
				-- 		e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
				-- },
			}
			local vopts = {
				mode = "v", -- VISUAL mode
				prefix = "<leader>",
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = true, -- use `nowait` when creating keymaps
			}
			local vmappings = {
				["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle" },
			}
			if Util.has("noice.nvim") then
				keymaps["<leader>sn"] = { name = "+noice" }
			end
			wk.register(keymaps)
			wk.register(vmappings, vopts)
			wk.register(mappings, nopts)
		end,
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "契" },
				topdelete = { text = "契" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},

	-- references
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = { delay = 200 },
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	-- buffer remove
	{
		"echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
		},
	},

	-- todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
	},
}
