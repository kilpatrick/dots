#!/bin/bash

echo "WARNING: This should only be run on a new system."
echo "Are you sure want to continue? (y/n)"
read continue_rsp

if [[ $continue_rsp == "yes" || $continue_rsp == "y" ]]; then
    echo "_____________________________________________";
    echo "        Initializing Dev Environment           ";
    echo "_____________________________________________";
    echo "                                             ";


    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew: Done."


    # TODO: Install Pip
    echo "Pip: Skipped."


    # Prezto
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    /usr/bin/env zsh -c 'setopt EXTENDED_GLOB\
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do \
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}" \
        done'
    chsh -s $(which zsh)
    echo "Prezto: Done."


    # JavaScript
    brew install node watchman yarn
    npm install n
    yarn global add json-server
    echo "JavaScript: Done."


    # Python
    brew install pyenv
    pip install ipython[all] pipenv virtualenv # flake8 nose numpy pep8 pylint
    echo "Python: Done."


    # VM
    brew cask install vagrant
    brew cask install virtualbox
    echo "VM: Done."


    # Misc
    pip install awscli
    echo "Misc: Done."


    # Terminal Tooling
    brew install curl htop lynx mycli nmap ripgrep the_silver_searcher tmux vim zsh-autosuggestions # fish git mysql
    pip install riverstone-cli
    echo "Terminal Tooling: Done."


    # Git Setup
    # Generate a new SSH key for github and add it to your account.
    # Add your name and email address used in github to your global git settings:
    echo "github username: "
    read gh_user
    git config --global user.name "$gh_user"
    echo "github email: "
    read gh_email
    git config --global user.email "$gh_email"
    echo "Github Settings: Done."


    # Dots
    if [ -f ~/.zshrc ]; then
        (mv ~/.zshrc ~/.zshrc_PREVIOUS)
        echo "WARNING: .zshrc file already exists. Renaming before creating symlink."
    fi
    (cd ~; ln -s ./dev/.zshrc ./)

    if [ -f ~/.vimrc ]; then
        (mv ~/.vimrc ~/.vimrc_PREVIOUS)
        echo "WARNING: .vimrc file already exists. Renaming before creating symlink."
    fi
    (cd ~; ln -s ./dev/.vimrc ./)
    echo "Dots: Done."


    # Env Vars
    (cp ./.zshrc_vars ~/)
    echo "Env Vars: WIP. Blank env var file copied to usr dir. It must be filed out to work."


    echo "_____________________________________________";
    echo "Initialization Complete.";

else
    echo "Initialization Aborted."
fi
