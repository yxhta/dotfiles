#!/usr/bin/env zsh
set -eu

test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
task_json='[{"name":"task with space","description":"A tab\tand\nnewline"}]'
ls_result=0
fzf_result=0
run_result=0

mise() {
  if [[ "$1" == tasks ]]; then
    print -r -- "$task_json"
    return "$ls_result"
  fi
  [[ "$1" == run ]]
  printf '%s\0' "$@" > "$test_dir/run"
  return "$run_result"
}

fzf() {
  local line
  printf '%s\n' "$@" > "$test_dir/fzf-args"
  cat > "$test_dir/fzf-input"
  if (( fzf_result == 0 )); then
    IFS= read -r line < "$test_dir/fzf-input"
    print -r -- "$line"
  fi
  return "$fzf_result"
}

alias mr='mise run'
source "${0:A:h:h}/zsh/functions/mr"
[[ -z "${aliases[mr]-}" ]]

print -rS -- 'history baseline'
mr --raw 'task with space' '' $'line\nbreak'
printf '%s\0' run --raw 'task with space' '' $'line\nbreak' > "$test_dir/expected"
cmp "$test_dir/run" "$test_dir/expected"
[[ ! -e "$test_dir/fzf-input" ]]
[[ "$history[$HISTCMD]" == 'history baseline' ]]

mr
printf '%s\0' run 'task with space' > "$test_dir/expected"
cmp "$test_dir/run" "$test_dir/expected"
[[ "$(cat "$test_dir/fzf-input")" == $'task with space\tA tab\\tand\\nnewline' ]]
[[ "$(cat "$test_dir/fzf-args")" == *'--tabstop=17'* ]]
[[ "$history[$HISTCMD]" == 'mise run task\ with\ space' ]]

task_json='[{"name":"task;$HOME"}]'
mr
[[ "$history[$HISTCMD]" == 'mise run task\;\$HOME' ]]
eval "$history[$HISTCMD]"
printf '%s\0' run 'task;$HOME' > "$test_dir/expected"
cmp "$test_dir/run" "$test_dir/expected"

task_json='[{"name":"short","description":"First"},{"name":"abcdefghijklmnopqrstuvwxyz","description":"Second"}]'
mr
[[ "$(cat "$test_dir/fzf-args")" == *'--tabstop=28'* ]]
printf '%s\0' run short > "$test_dir/expected"
cmp "$test_dir/run" "$test_dir/expected"

for fzf_result in 1 130 2; do
  rm -f "$test_dir/run"
  history_before=$history[$HISTCMD]
  result=0
  mr || result=$?
  if (( fzf_result == 2 )); then
    (( result == 2 ))
  else
    (( result == 0 ))
  fi
  [[ ! -e "$test_dir/run" ]]
  [[ "$history[$HISTCMD]" == "$history_before" ]]
done
fzf_result=0

task_json='[]'
rm -f "$test_dir/fzf-input"
mr 2> "$test_dir/error"
[[ "$(cat "$test_dir/error")" == *'mr: no mise tasks found'* ]]
[[ ! -e "$test_dir/fzf-input" && ! -e "$test_dir/run" ]]
ls_result=7
result=0
mr || result=$?
(( result == 7 ))
[[ ! -e "$test_dir/fzf-input" && ! -e "$test_dir/run" ]]
ls_result=0

task_json='[{"name":"task with space"}]'
run_result=9
result=0
mr || result=$?
(( result == 9 ))
[[ "$history[$HISTCMD]" == 'mise run task\ with\ space' ]]
result=0
mr 'task with space' || result=$?
(( result == 9 ))

print -- 'mr checks passed'
