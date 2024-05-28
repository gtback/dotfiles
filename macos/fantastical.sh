#!/bin/bash

FANTASTICAL_APP="$HOME/Library/Containers/com.flexibits.fantastical2.mac/Data/Library/Preferences/com.flexibits.fantastical2.mac.plist"
FANTASTICAL_GROUP="$HOME/Library/Group Containers/85C27NK92C.com.flexibits.fantastical2.mac/Library/Preferences/85C27NK92C.com.flexibits.fantastical2.mac.plist"

# Set week to start on Monday (Sunday=1, Saturday=7)
defaults write "$FANTASTICAL_GROUP" FirstWeekday 2
# Start Week View on (Today or Selected Day=0, First Day of Week=1)
defaults write "$FANTASTICAL_APP" WeekViewStartsWith 1
# Enable setting "Show multi-day events in all-day section"
defaults write "$FANTASTICAL_GROUP" MultiDayInAllDay 1
# Enable setting "Show upcoming item in menu bar"
defaults write "$FANTASTICAL_GROUP" StatusItemShowEvent 1
