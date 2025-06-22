#!/usr/bin/env sh

REPOSITORIES_ROOT="git@github.com:fred-si-conf"

CONFIG_DIRECTORY="${XDG_CONFIG_HOME:-${HOME}/.config}"
AWESOME_DIRECTORY="${CONFIG_DIRECTORY}/awesome"

error() {
    echo "Error: $1" > /dev/stderr
    exit "${2:-1}"
}

if [ -e "${AWESOME_DIRECTORY}" ]; then
    error "directory ${AWESOME_DIRECTORY} already exists"
fi

if ! which git > /dev/null 2>&1; then
    error "Git dependency not found"
fi

git clone "${REPOSITORIES_ROOT}/dotfiles-awesome.git" "${AWESOME_DIRECTORY}"
