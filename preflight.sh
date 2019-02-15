#!/bin/bash

success="\e[32m ✓ \e[0m"
fail="\e[31m ✗ \e[0m"
can_proceed=true

# Sublime
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
