require'trouble'.setup {
    use_diagnostic_signs = true
}

vim.cmd [[
    augroup trouble_au
    autocmd!
    autocmd FileType Trouble setl cursorline 
    augroup END
]]
