local borders = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

return {
  borders = borders,
  hover_config = {
    border = borders,
  },
  signature_help_config = {
    silent = true,
    max_height = 10,
    border = borders,
  },
}
