#!/bin/sh
# Removes all user and system font caches
atsutil databases -remove
# Removes all user caches
atsutil databases -removeUser
# Stops the Font service
atsutil server -shutdown
# Starts the Font service
atsutil server -ping
