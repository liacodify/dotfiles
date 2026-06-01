return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,

      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },

      on_colors = function(colors)
        colors.bg_sidebar = "NONE"
        colors.bg_float = "NONE"
      end,

      on_highlights = function(hl, c)
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { bg = "NONE" }
        hl.Pmenu = { bg = "NONE" }
        hl.TelescopeNormal = { bg = "NONE" }
        hl.TelescopeBorder = { bg = "NONE" }

        -- sidebars (NvimTree, Lazy, etc.)
        hl.NvimTreeNormal = { bg = "NONE" }
        hl.NvimTreeNormalNC = { bg = "NONE" }
        hl.NvimTreeEndOfBuffer = { bg = "NONE" }

        hl.LazyNormal = { bg = "NONE" }
        hl.MasonNormal = { bg = "NONE" }
      end,
    },
  },
}
