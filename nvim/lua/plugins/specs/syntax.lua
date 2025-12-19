return {
  { "chrisbra/vim-zsh" },

  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
      }
    end,
  },

  {
    "chrisbra/csv.vim",
    cmd = "CSVInit",
  },
}
