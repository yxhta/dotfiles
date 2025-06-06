# ============================================================================
# Color Configuration
# ============================================================================

# Load color constants and enable colored output
autoload -U colors && colors

# Enable colored output from ls and other commands on FreeBSD-based systems
export CLICOLOR=1

# LS_COLORS for GNU ls (if using GNU coreutils)
if command -v dircolors &> /dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Enable colored output for grep family
export GREP_COLOR='1;32'
export GREP_OPTIONS='--color=auto'

# Less pager colors for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'      # begin bold
export LESS_TERMCAP_md=$'\e[1;32m'      # begin blink
export LESS_TERMCAP_me=$'\e[0m'         # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m'  # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'         # reset reverse video
export LESS_TERMCAP_us=$'\e[1;4;31m'    # begin underline
export LESS_TERMCAP_ue=$'\e[0m'         # reset underline