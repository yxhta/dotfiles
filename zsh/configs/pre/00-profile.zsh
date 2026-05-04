# Optional zprof profiler. Paired with post/99-profile.zsh.
# Usage: ZSH_PROFILE=1 zsh -i -c exit
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof
