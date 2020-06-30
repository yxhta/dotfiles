#================================================================
#
#================================================================
# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

#================================================================
#                    General
#================================================================
set IGNOREEOF

export PATH="$HOME/.bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export ZSH=$HOME/.dotfiles
# export PATH=~/.composer/vendor/bin:$PATH

# Language must be en_US
export LANGUAGE=en_US.UTF-8
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# Mute the beep
setopt no_beep

# asdf
. $HOME/.asdf/asdf.sh

# Load hub
eval "$(hub alias -s)"

# Better history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--extended --ansi --multi --height 40% --reverse --border"

# fbr - checkout git branch
function fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# vv - search file and open with vim
function vv() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | fzf -m --preview 'head -100 {}') &&
  nvim $selected_files
}

# ghq-cd - change directory using ghq and fzf
function gcd() {
  repo_path=$(ghq list --full-path | fzf)
  cd $repo_path
}

# ghq-hub - browse remote repository using ghq and fzf
function ghq-hub() {
  repo_path=$(ghq list --full-path | fzf)
  repo_name=${repo_path##*github.com/}
  hub browse $repo_name
}

# fzf-git-add - make git add more interactively
function fadd() {
  local out q n addfiles
  while out=$(
      git status --short |
      awk '{if (substr($0,2,1) !~ / /) print $2}' |
      fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
    fi
  done
}
#================================================================
#                    Zplug
#================================================================
source ~/.zplug/init.zsh

zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-completions'
zplug 'mafredri/zsh-async', from:github
zplug 'sindresorhus/pure', use:pure.zsh, from:github, as:theme
# zplug "b4b4r07/enhancd", use:init.sh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
# zplug load --verbose
zplug load >/dev/null

#================================================================
#                    GCP
#================================================================
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
