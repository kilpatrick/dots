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


    # TODO: Install Pip


    # TODO: Install zsh


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
    brew install curl htop lynx mycli nmap ripgrep the_silver_searcher tmux vim # fish git mysql 
    pip install riverstone-cli
    echo "This will clone https://github.com/zsh-users/zsh-autosuggestions"
    echo "Are you sure you want to clone zsh-autosuggestions? (y/n)"
    read zsh_autosuggestions_confirm
    if [[ $zsh_autosuggestions_confirm == "yes" || zsh_autosuggestions_confirm == "y" ]]; then
        (cd ~ && cd .zsh || mkdir .zsh && cd .zsh && git clone https://github.com/zsh-users/zsh-autosuggestions.git)
    else
        echo "Skipping zsh-autosuggestions."
        echo "You should remove that from this script and your .zshrc."
    fi
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


    # Symlink Dots
    (cd ~; ln -s ./dev/.zshrc ./)
    (cd ~; ln -s ./dev/.vimrc ./)
    echo "Symlink Dots: Done."

    echo "_____________________________________________";
    echo "Init. Complete";

else
    echo "Initialization Aborted."
fi
