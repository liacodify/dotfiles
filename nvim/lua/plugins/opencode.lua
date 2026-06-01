return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  opts = {
    server = {
      start = function()
        require("opencode.terminal").open("opencode --port", {
          split = "right",
          width = math.floor(vim.o.columns * 0.4),
        })
      end,
      toggle = function()
        require("opencode.terminal").toggle("opencode --port", {
          split = "right",
          width = math.floor(vim.o.columns * 0.4),
        })
      end,
    },
    events = {
      enabled = true,
      reload = true,
      permissions = {
        enabled = true,
        edits = {
          enabled = true,
        },
      },
    },
  },
  config = function()
    vim.o.autoread = true
    vim.o.mouse = "n"

    vim.g.opencode_opts = vim.g.opencode_opts or {}
    vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts, {
      server = {
        start = function()
          require("opencode.terminal").open("opencode --port", {
            split = "right",
            width = math.floor(vim.o.columns * 0.4),
          })
        end,
        toggle = function()
          require("opencode.terminal").toggle("opencode --port", {
            split = "right",
            width = math.floor(vim.o.columns * 0.4),
          })
        end,
      },
    })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function(args)
        local term_buf = args.buf
        vim.bo[term_buf].mouse = ""
        vim.bo[term_buf].scrollback = 10000
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = term_buf, desc = "Exit terminal mode" })
        vim.keymap.set("n", "y", '"+y', { buffer = term_buf, desc = "Yank to system clipboard" })
        vim.keymap.set("n", "<leader>y", '"+y', { buffer = term_buf, desc = "Yank to system clipboard" })
        vim.keymap.set("n", "<S-Up>", function()
          vim.cmd("normal! k")
        end, { buffer = term_buf, desc = "Scroll up" })
        vim.keymap.set("n", "<S-Down>", function()
          vim.cmd("normal! j")
        end, { buffer = term_buf, desc = "Scroll down" })
      end,
    })

    vim.keymap.set("n", "<leader>at", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode", silent = true })

    vim.keymap.set("n", "<leader>af", function()
      local file = vim.fn.expand("%:~")
      local server = require("opencode.server").get()
      server:next(function(s)
        vim.defer_fn(function()
          s:tui_append_prompt("@" .. file, function()
            s:tui_execute_command("prompt.submit")
          end)
        end, 500)
      end)
    end, { desc = "Send current file to opencode" })

    vim.keymap.set("x", "<leader>as", function()
      local file = vim.fn.expand("%:~")
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      local server = require("opencode.server").get()
      server:next(function(s)
        vim.defer_fn(function()
          s:tui_append_prompt("@" .. file .. ":" .. start_line .. "-" .. end_line, function()
          end)
        end, 500)
      end)
    end, { desc = "Send selection to opencode (Claude Code style)" })

    vim.keymap.set("n", "<leader>al", function()
      local line = vim.fn.getline(".")
      require("opencode").ask("@this " .. line, { submit = true })
    end, { desc = "Send line to opencode" })

    vim.keymap.set("n", "<leader>a-", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })

    vim.keymap.set("n", "<leader>a+", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })

    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode… (range)", silent = true })

    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Select opencode…", silent = true })

    vim.api.nvim_create_autocmd("User", {
      pattern = "OpencodeEvent:*",
      callback = function(args)
        if args.data.event.type == "session.idle" then
          vim.notify("OpenCode finished", vim.log.levels.INFO, { title = "OpenCode" })
        end
      end,
    })

    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*opencode*",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("startinsert")
        end, 100)
      end,
    })
  end,
}