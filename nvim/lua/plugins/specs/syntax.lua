return {
  { "chrisbra/vim-zsh", ft = "zsh" },

  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
      }
    end,
  },
}
