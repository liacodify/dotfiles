return {
  "hat0uma/csvview.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  opts = {
    display_mode = "border",
    parser = { comments = { "#", "//" } },
    keymaps = {
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },
  ft = { "csv", "tsv" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "csv", "tsv" },
      callback = function()
        vim.cmd("CsvViewEnable")
      end,
    })
  end,
}