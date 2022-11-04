#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
dockutil --no-restart --add "/System/Applications/Code.app"
dockutil --no-restart --add "/System/Applications/iTerm.app"
dockutil --no-restart --add "/System/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Opera GX.app"
dockutil --no-restart --add "/System/Applications/1Password 7.app"
dockutil --no-restart --add "/System/Applications/DeepL.app"
dockutil --no-restart --add "/System/Applications/Notion.app"
dockutil --no-restart --add "/System/Applications/Signal.app"

killall Dock

