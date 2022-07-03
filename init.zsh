export FZF_WIDGET_ROOT="$0:a:h"
export FZF_WIDGET_TMUX=0
typeset -gA FZF_WIDGET_OPTS

if [[ -z ${FZF_WIDGET_CACHE} ]]; then
  export FZF_WIDGET_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-widgets"
fi

: "Create cache directory" && () {
  [[ ! -d $FZF_WIDGET_CACHE ]] && mkdir -p $FZF_WIDGET_CACHE
}

: "Autoload functions and Create widgets" && () {
  local dir="${FZF_WIDGET_ROOT}/autoload"
  fpath=(${dir}/**/*(N-/) ${fpath})

  autoload -Uz $(fd --type file . ${dir} --exec echo {/})

  local w
  for w in $(fd --type file . ${dir}/widgets/ --exec echo {/}); do zle -N ${w}; done
}

# Support zsh-autosuggestions
if [[ -n ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]]; then
  ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
    ${ZSH_AUTOSUGGEST_IGNORE_WIDGETS}
    $(fd --type file . ${FZF_WIDGET_ROOT}/autoload/widgets/ --exec echo {/})
  )
fi

# fzf-change-directory should be drop-down, limited in length, with a preview of nested (exa?)
