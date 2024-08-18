#!/usr/bin/env python3

# Obsidian Capture to daily note 
#
# Dependency: This script requires Python 3
# Install Python 3: https://www.python.org/downloads/release
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Obsidian Capture to Daily Note 
# @raycast.mode silent
# @raycast.packageName Obsidian
#
# Optional parameters:
# @raycast.icon 🗿
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description Switch to Obsidian and trigger Control + Command + g hotkey 
# @raycast.author Peter Rebrun
# @raycast.authorURL An URL for one of your social medias

import os

os.system("open /Applications/Obsidian.app")

cmd = """
osascript -e 'tell application "System Events" to keystroke "g" using {control down, command down}' 
"""
# minimize active window
os.system(cmd)
