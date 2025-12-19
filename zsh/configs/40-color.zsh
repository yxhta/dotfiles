# ==========================================================================
# Color Configuration
# ==========================================================================

# Load color constants and enable colored output
autoload -U colors && colors

# Enable colored output from ls and other commands on FreeBSD-based systems
export CLICOLOR=1

# LS_COLORS for GNU ls (if using GNU coreutils)
if command -v dircolors >/dev/null 2>&1; then
  if [ -r "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# Enable colored output for grep family
export GREP_COLORS='ms=01;32:mc=01;32:sl=01;32:cx=01;32:fn=35:ln=32:bn=32:se=36'

# Less pager colors for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'      # begin bold
export LESS_TERMCAP_md=$'\e[1;32m'      # begin blink
export LESS_TERMCAP_me=$'\e[0m'         # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m'  # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'         # reset reverse video
export LESS_TERMCAP_us=$'\e[1;4;31m'    # begin underline
export LESS_TERMCAP_ue=$'\e[0m'         # reset underline
