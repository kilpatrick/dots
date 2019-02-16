#!/bin/zsh

function preflight_check() {
    success="\e[32m ✓ \e[0m"
    fail="\e[31m ✗ \e[0m"
    can_proceed=true

    zsh_path=/bin/zsh
    if [ -f "$zsh_path" ]; then
        echo "${success} zsh Installed"
    fi
    if [ ! -f "$zsh_path" ]; then
        echo "${fail} zsh Not Installed"
        can_proceed=false
    fi

    sublime_path=/Applications/Sublime\ Text.app/
    if [ -d "$sublime_path" ]; then
        echo "${success} Sublime Text Installed"
    fi
    if [ ! -d "$sublime_path" ]; then
        echo "${fail} Sublime Text Not Installed"
        can_proceed=false
    fi

    xcode_path="/Applications/Xcode.app/"
    if [ -d "$sublime_path" ]; then
        echo "${success} Xcode Text Installed"
    fi
    if [ ! -d "$sublime_path" ]; then
        echo "${fail} Xcode Text Not Installed"
        can_proceed=false
    fi

    echo Can Proceed: ${can_proceed}
}

top_padding="\n-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"
bottom_padding="-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --\n"


echo "WARNING: This should only be run on a new system."
preflight_check
echo "Are you sure want to continue? (y/n)"
read continue_rsp


if [[ $continue_rsp == "yes" || $continue_rsp == "y" ]]; then
    echo "_____________________________________________";
    echo "        Initializing Dev Environment         ";
    echo "_____________________________________________";
    echo "                                             ";


    # Git Setup
    echo "github username: "
    read gh_user
    git config --global user.name "$gh_user"
    echo "github email: "
    read gh_email
    git config --global user.email "$gh_email"
    echo "Github Settings: Done."


    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew: Done."


    # TODO: Install Pip
    echo "Pip: Skipped."


    # Prezto
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
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
    # brew cask install virtualbox # Install this manually without brew
    echo "VM: Done."


    # Misc
    pip install awscli
    echo "Misc: Done."


    # Terminal Tooling
    brew install curl htop lynx mysql mycli nmap ripgrep the_silver_searcher tmux vim zsh-autosuggestions       
    pip install riverstone-cli
    echo "Terminal Tooling: Done."


    # Vim Extensions
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall


    # CLI Preferences
    if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
        echo $top_padding
        echo "WARNING: com.googlecode.iterm2.plist file already exists. Renaming before creating symlink."
        echo $bottom_padding
        (mv ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist_PREVIOUS)
    fi
    (cd ~/Library/Preferences/; ln -s ../../dev/dots/iterm/com.googlecode.iterm2.plist ./)

    echo "CLI: Done."


    # Dots
    if [ -f ~/.zshrc ]; then
        (mv ~/.zshrc ~/.zshrc_PREVIOUS)
        echo $top_padding
        echo "WARNING: .zshrc file already exists. Renaming before creating symlink."
        echo $bottom_padding
    fi
    (cd ~; ln -s ./dev/dots/.zshrc ./)

    if [ -f ~/.vimrc ]; then
        (mv ~/.vimrc ~/.vimrc_PREVIOUS)
        echo $top_padding
        echo "WARNING: .vimrc file already exists. Renaming before creating symlink."
        echo $bottom_padding
    fi
    (cd ~; ln -s ./dev/dots/.vimrc ./)
    echo "Dots: Done."


    # Env Vars
    (cp ./.zshrc_vars ~/)
    echo "\nEnv Vars: WIP. Blank env var file copied to usr dir. It must be filed out to work."


    echo "\n_____________________________________________";
    echo "Initialization Complete.";
    echo "_____________________________________________\n";
    echo "You still need to:"
    echo "- [ ] Install VirtualBox"
    echo "- [ ] Generate keys and add pub key to github"
    echo "- [ ] Add values to  ~/.zshrc_vars \n"

else
    echo "Initialization Aborted."
fi
