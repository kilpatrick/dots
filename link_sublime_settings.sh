#!/bin/bash

sublime_settings_files=(
    Batch File.sublime-settings,
    Build.sublime-settings,
    CSS.sublime-settings,
    Default\ \(OSX\).sublime-keymap,
    Default.sublime-theme,
    HTML.sublime-settings,
    INI.sublime-settings,
    JavaScript\ \(Babel\).sublime-settings,
    JavaScript.sublime-settings,
    Markdown.sublime-settings,
    Package\ Control.sublime-settings,
    Preferences.sublime-settings,
    Python.sublime-settings,
    reStructuredText.sublime-settings,
    Shell-Unix-Generic.sublime-settings,
    SublimeLinter.sublime-settings,
    XML.sublime-settings
)

for filename in $sublime_settings_files; do
    # TODO: Check to see if these exists already.
    (cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/ && ln -s  "../../../../../dev/dots/SublimeUserSettings/${filename}" "./${filename}")
done

# SublimeLinter/Monokai (SL).tmTheme

# INI
# INI Syntax highlighting for Sublime Text 2
# https://github.com/clintberry/sublime-text-2-ini

# SublimeLinter-rubocop
# SublimeLinter 3 plugin for Ruby, using rubocop
# github.com/SublimeLinter/SublimeLinter-rubocop

if [ -f ~/bin/subl ]; then
    echo $top_padding
    echo "WARNING: ~/bin/subl already exists. Symlink Not Created."
    echo $bottom_padding
else
    ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
fi
