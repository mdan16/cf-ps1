# cf-ps1

The cf-ps1 set the current foundation and organization and space of [Cloud Foundry](https://www.cloudfoundry.org/) to your Bash/Zsh prompt.

```
(cf| foundation:organization:space) $
```

The cf-ps1 inspired by [kube-ps1](https://github.com/jonmosco/kube-ps1).

## Requirements

- jq

## Supported Shell

- Bash
- Zsh

## Installing

### Bash

Source the cf-ps1.sh in your `~/.bashrc`

```sh
CF_PS1_API_ENDPOINT_FOUNDATION_POSITION=2 # when your cf api endtpoint is https://api.foundation.example.com 
source /path/to/cf-ps1.sh
PS1="[\u@\h \W $(cf_ps1)]\$ "
```

### Zsh

Source the cf-ps1.sh in your `~/.zshrc`

```sh
CF_PS1_API_ENDPOINT_FOUNDATION_POSITION=2 # when your cf api endtpoint is https://api.foundation.example.com 
source /path/to/cf-ps1.sh
PROMPT='$(cf_ps1)'$PROMPT
```

## Environment

| Variable | Format | Default | Description |
| :--- | :--- | :--- | :--- |
| CF_PS1_API_ENDPOINT_FOUNDATION_POSITION | integer | `false` | When a api endpoint is `https://api.foundation.example.com`, `api` will be displayed if set to `1`, `foundation` will be displayed if set to `2`. If not set, api the entire endpoint will be displayed as foundation. |
