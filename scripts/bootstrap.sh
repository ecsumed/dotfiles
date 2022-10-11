#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

info 'Current Machine: ${machine}'

setup_gitconfig () {
  if [ ! -f git/gitconfig.local.symlink ]
  then
    info 'Setup gitconfig'

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  #all files in home directory
  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not \( -path '*.git*' -o -path './config/*' \))
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
 
}

install_configfiles() {
  info 'installing config files'

  local overwrite_all=false backup_all=false skip_all=false
  #all .config files
  for src in $(find "$DOTFILES_ROOT/config" -maxdepth 1 -name '*.symlink')
  do
    dst="$HOME/.config/$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

install_pip3_dependencies () {
  info 'installing pip3 dependencies'
  pip3 install -r "$DOTFILES_ROOT/pip_requirements.txt"
}

pull_submodules() {
  git submodule update --init --recursive

  cd ~/.vim/pack/git-plugins/start/YouCompleteMe
  python3 install.py
}

install_apt_dependencies () {
  info 'installing apt dependencies'
  sudo apt-get install python3-pip exuberant-ctags -y

  sudo apt install build-essential cmake python3-dev vim-nox
}

install_binaries () {
  info 'installing binaries'

  # Starship install
  curl -sS https://starship.rs/install.sh | sh
}

confirm_and_run () {
  read -n1 -p "$2 [y,n]" input
  case $input in
    y|Y) $1 ;;
    *) echo skipping ;;
  esac
}

confirm_and_run setup_gitconfig 'Setup git?'

install_configfiles
install_dotfiles

if [ $machine == "Linux" ]; then
  confirm_and_run install_apt_dependencies 'Install apt dependencies?'
fi

confirm_and_run install_pip3_dependencies 'Install pip dependencies?'

confirm_and_run pull_submodules 'Pull submodules for vim?'

confirm_and_run install_binaries 'Install binaries?'

echo ''
echo '  All installed!'
