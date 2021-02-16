#!/usr/bin/env bash


# mvenv - helper tool to manage python virtual environments
# Python 2 is out of scope

WORKON_HOME=$HOME/.virtualenvs
if type asdf >/dev/null 2>&1; then
  PY_INSTALL=asdf
elif type pyenv >/dev/null 2>&1; then
  PY_INSTALL=pyenv
else
  echo "ERROR: No python version management tool found." >&2
  exit 1
fi

_verify_activate () {
  declare env_dir="$1"
  activate="${env_dir}""/bin/activate"
  if [ -f "${activate}" ]; then
    return 0
  else
    return 1
  fi
}

_activate_venv () {
  _verify_venv "${1}" || return 1
  declare env_dir="$WORKON_HOME/$1"

  if ! _verify_activate "$env_dir"; then
    echo "ERROR: The venv $1 does not contain an activate script." >&2
    return 1
  fi

  # shellcheck disable=1090
  source "$activate"
}

_mvenvcomplete () {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    local services=("rm" "mk" "ls" "help" "activate")
    COMPREPLY=($(compgen -W "${services[*]}" -- "$cur"))
  elif [ "${COMP_WORDS[1]}" = "rm" ] || [ "${COMP_WORDS[1]}" = "activate" ]; then
    COMPREPLY+=($(compgen -W "$(_ls_venvs)" -- "$cur"))
  else
    COMPREPLY=()
  fi
}

_mvenv_usage () {
  echo
  echo "CLI Options:"
  echo "    mve mk <word>         -->   creates a new venv"
  echo "    mve rm <word>         -->   removes an existing venv"
  echo "    mve ls <word>         -->   lists all available venvs"
  echo "    mve activate <word>   -->   activate a venv"
  echo ""
  echo "    mve help              -->   displays this menu"
  echo
}

_verify_home_dir () {
  RC=0
  if [ ! -d "${WORKON_HOME}" ]; then
    mkdir -p "${WORKON_HOME}"
    RC=$?
  fi
  return $RC
}

_verify_venv () {
  declare env_name="${1}"
  if [ ! -d "${WORKON_HOME}/${env_name}" ]; then
    echo "ERROR: Environment '${env_name}' does not exist. Create it with 'mve mk ${env_name}'." >&2
    return 1
  fi
  return 0
}

_mk_mvenv () {
  # Use python version specified by running location
  MVENV_PY_PATH=$(cd "$PWD" || exit; "${PY_INSTALL}" which python)
  # Make a new virtual env
  _verify_home_dir || return 1
  declare env_name="${1}"
  if [ -z "${env_name}" ]; then
    echo "Missing venv name"
  else
    echo "Creating a new venv with name: ${env_name}"
    echo "$(python -V)"
    "${MVENV_PY_PATH}" -m venv "${WORKON_HOME}"/"${env_name}"
  fi

  _activate_venv "${env_name}"
  pip install --upgrade pip
}

_rm_mvenv () {
  # Delete a virtual env
  _verify_home_dir || return 1
  declare env_name="${1}"
  if [ -z "${env_name}" ]; then
    echo "Please specify a venv"
    return 1
  fi
  echo "Removing $env_name..."
  declare env_dir="$WORKON_HOME/$env_name"
  if [ "$VIRTUAL_ENV" = "$env_dir" ]; then
    echo "ERROR: Cannot remove the active venv_('$env_name')." >&2
    echo "Either deactivate it or switch to another one." >&2
    return 1
  fi

  if [ ! -d "$env_dir" ]; then
    echo "$env_dir does not exist." >&2
  fi

  command rm -rf "$env_dir"
}

_ls_venvs () {
  for i in "${WORKON_HOME}"/*; do
    if _verify_activate "$i"; then
      basename "$i"
    fi
  done
}

mve () {
  # main function
  if [ "${1}" = "" ]; then
    _mvenv_usage
    return 1
  elif [ "${1}" = "." ]; then
    IFS='%'
    env_name="$(basename "$(pwd)")"
    unset IFS
  elif [ "$1" = "ls" ]; then
    _ls_venvs
  elif [ "$1" = "mk" ]; then
    _mk_mvenv "$2"
  elif [ "$1" = "rm" ]; then
    _rm_mvenv "$2"
  elif [ "$1" = "help" ]; then
    _mvenv_usage
  elif [ "$1" = "activate" ]; then
    _activate_venv "$2"
  fi

  return 0
}

complete -F _mvenvcomplete mve
