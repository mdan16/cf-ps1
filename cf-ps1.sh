#! /usr/bin/env bash

CF_PS1_HOME="${CF_HOME:-$HOME}"
CF_PS1_API_ENDPOINT_FOUNDATION_POSITION="${CF_PS1_API_ENDPOINT_FOUNDATION_POSITION:-false}"

if [ -n "$ZSH_VERSION" ]; then
  CF_PS1_SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
  CF_PS1_SHELL="bash"
fi

_cf_ps1_get_foundation_name() {
    CF_PS1_FOUNDATION="$(jq -r '.AuthorizationEndpoint' < $CF_PS1_CF_CONFIG | perl -p -e "s/https?:\/\///")"
    if [[ "$CF_PS1_API_ENDPOINT_FOUNDATION_POSITION" =~ ^[0-9]+$ ]]; then
        CF_PS1_FOUNDATION="$(cut -d '.' -f $CF_PS1_API_ENDPOINT_FOUNDATION_POSITION <<< $CF_PS1_FOUNDATION)"
    fi
}

_cf_ps1_update() {
    CF_PS1_CF_CONFIG="${CF_PS1_HOME}/.cf/config.json"

    _cf_ps1_get_foundation_name
    CF_PS1_ORG="$(jq -r '.OrganizationFields.Name' < $CF_PS1_CF_CONFIG)"
    CF_PS1_SPACE="$(jq -r '.SpaceFields.Name' < $CF_PS1_CF_CONFIG)"
}

_cf_ps1_init() {
    _cf_ps1_update

    if [[ $CF_PS1_SHELL == "zsh" ]];then
        autoload -U add-zsh-hook
        add-zsh-hook precmd _cf_ps1_update
    elif [[ $CF_PS1_SHELL == "bash" ]];then
        PROMPT_COMMAND="_cf_ps1_update;${PROMPT_COMMAND}"
    fi
}

_cf_ps1_init

cf_ps1() {
    local CF_PS1
    CF_PS1="(cf| $CF_PS1_FOUNDATION:$CF_PS1_ORG:$CF_PS1_SPACE)"
    echo "$CF_PS1"
}
