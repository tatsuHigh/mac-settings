export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export HOMEBREW_CACHE=/opt/homebrew/cache
alias cat='bat --style=plain'

# fzf setting
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --select-1 --exit-0 --multi'

# search and move directory
_fzf_fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
alias fda='_fzf_fda'

autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*'      recent-dirs-max 500
  zstyle ':chpwd:*'      recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

# change directory direct in history
_fzf_cdd() {
  target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
  target_dir=`echo ${target_dir/\~/$HOME}`
  if [ -n "$target_dir" ]; then
    cd $target_dir
  fi
}
alias cdd='_fzf_cdd'

# search and cat file
_fzf_fcat() {
  local file
  file=$(find . | fzf)
  cat "$file"
}
alias fcat='_fzf_fcat'

# search and vi file
_fzf_fvi() {
  local file
  file=$(find . | fzf)
  vi "$file"
}
alias fvi='_fzf_fvi'

# show clipboard history
_fzf_history() {
    local tac=${commands[tac]:-"tail -r"}
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed 's/ *[0-9]* *//' | eval $tac | awk '!a[$0]++' | fzf-tmux +s)
    CURSOR=$#BUFFER
}
# register _fzf_history to widget
zle -N _fzf_history
# bind _fzf_history on control + R
bindkey '^R' _fzf_history

# select github repository
_fzf_fgh() {
  declare -r REPO_NAME="$(ghq list >/dev/null | fzf-tmux --reverse +m)"
  [[ -n "${REPO_NAME}" ]] && cd "$(ghq root)/${REPO_NAME}"
}
zle -N _fzf_fgh
bindkey '^G' _fzf_fgh

# starship setting
# [WARNING] must be last line
eval "$(starship init zsh)"
