#!/bin/bash

set -x

# source version app
APP_SOURCE='/Applications/Cursor.app'

# unique name for your alt install
APP_NAME='Cursor Alt' # can have spaces
APP_SETTINGS_NAME='CursorAlt' # should not hvae spaces
APP_ID="com.cursor.alt" # lowercase ideally

APP_PATH="$HOME/Applications/$APP_NAME.app"
APP_SETTINGS_PATH="$HOME/Library/Application Support/$APP_SETTINGS_NAME"
PLIST="$APP_PATH/Contents/Info.plist"


# cleanup old path
echo "Checking $APP_PATH"
if [ -e "$APP_PATH" ]; then
    echo "Found old path"
    trash "$APP_PATH"
else
    echo "No previous install to cleanup"
fi

# copy the app to our home
mkdir -p "$HOME/Applications"
cp -R "$APP_SOURCE" "$APP_PATH"

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $APP_ID" "$PLIST" \
  || /usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $APP_ID" "$PLIST"
codesign --force --deep --sign - "$APP_PATH"

# setup dedicated settings path
mkdir -p "$APP_SETTINGS_PATH"

# optional: clone existing keybindings
# cp -f "$APP_SOURCE/User/keybindings.json" "$APP_PATH/User"

# optional: clone existing settings
# cp -f ~/Library/Application\ Support/Cursor/User/settings.json ~/Library/Application\ Support/$APP_SETTINGS_NAME/User/settings.json

# use: open the second app from the terminal or from the Finder
echo "open -n \"$APP_PATH\" --args --user-data-dir \"$APP_SETTINGS_PATH\""
# open -n "$APP_PATH" --args --user-data-dir "$APP_SETTINGS_PATH"
