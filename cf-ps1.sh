#! /usr/bin/env bash

if [ -n "$ZSH_VERSION" ]; then
  CF_PS1_SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
  CF_PS1_SHELL="bash"
fi

_cf_ps1_color_text() {
    local CF_PS1_COLOR_TEXT
    if [[ "$CF_PS1_SHELL" == "zsh" ]];then
        CF_PS1_COLOR_TEXT="%F{$1}$2%f"
    elif [[ "$CF_PS1_SHELL" == "bash" ]];then
        local CF_PS1_COLOR_CODE
        case "$1" in
            red) CF_PS1_COLOR_CODE="31m";;
            yellow) CF_PS1_COLOR_CODE="33m";;
            cyan) CF_PS1_COLOR_CODE="36m";;
        esac
        CF_PS1_COLOR_TEXT="\[\e[0;${CF_PS1_COLOR_CODE}\]${2}\[\e[m\]"
    fi
    echo "$CF_PS1_COLOR_TEXT"
}

_cf_ps1_get_foundation_name() {
    CF_PS1_FOUNDATION="$(jq -r '.AuthorizationEndpoint' < $CF_PS1_CF_CONFIG | perl -p -e "s/https?:\/\///")"
    if [[ "$CF_PS1_API_ENDPOINT_FOUNDATION_POSITION" =~ ^[0-9]+$ ]]; then
        CF_PS1_FOUNDATION="$(cut -d '.' -f $CF_PS1_API_ENDPOINT_FOUNDATION_POSITION <<< $CF_PS1_FOUNDATION)"
    fi
}

_cf_ps1_update() {
    CF_PS1_HOME="${CF_HOME:-$HOME}"
    CF_PS1_API_ENDPOINT_FOUNDATION_POSITION="${CF_PS1_API_ENDPOINT_FOUNDATION_POSITION:-false}"
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

cfon() {
    CF_PS1_ENABLED="on"
}

cfoff() {
    CF_PS1_ENABLED="off"
}

cf_ps1() {
    [[ "$CF_PS1_ENABLED" == "off" ]] && return
    local CF_PS1
    CF_PS1="(cf| $(_cf_ps1_color_text red $CF_PS1_FOUNDATION):$(_cf_ps1_color_text yellow $CF_PS1_ORG):$(_cf_ps1_color_text cyan $CF_PS1_SPACE))"
    echo "$CF_PS1"
}
