#! /bin/bash

# Requirements
# rsync - available via "SSH & Web Terminal" add-on
# git

# Location
# `mkdir /config/bin/`  - recommended location
# `cd /config/bin/`
# `touch sync-hassio`
# `nano sync-hassio` - paste contents in here. Ctrl-O to save, Ctrl-X to exit
# Make executable with: `chmod u+x sync-hassio`
# https://www.taniarascia.com/how-to-create-and-use-bash-scripts/

# Initial Git configuration
# `cd /config`
# `init git`
# `git remote add origin $URL`
# `git fetch origin`
# `git checkout -t origin/master`
# `git reset --hard`
# https://stackoverflow.com/questions/5377960/whats-the-best-practice-to-git-clone-into-an-existing-folder

# To configure
# Add your github link
# Add the filepath to your primary Home Assistant config - rsync format
# Specify the local folder to copy contents to

# For many files, SSH key pairs are recommended. Otherwise you will be prompted for the password everytime
# https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# https://www.debian.org/devel/passwordlessssh

# Use it
# `bash /config/bin/sync-hassio`

GITHUB="https://github.com/garrettdowd/home-assistant/"
MAIN="root@192.168.0.4:/mnt/user/Apps/home-assistant/"
LOCAL="/config/"
PRIV_KEY="/root/.ssh/nopass_rsa"
SSH="ssh -i $PRIV_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
# SSH="" # to not use SSH for rsync

FILES[0]="secrets.yaml"
FILES[1]="ip_bans.yaml"
FILES[2]="known_devices.yaml"
FILES[3]="www/"
FILES[4]="html5_push_registrations.conf"
FILES[5]="plex.conf"
FILES[6]=".cloud/"
FILES[7]=".ios.conf"
FILES[8]=".spotify-token-cache"
FILES[9]=".storage/"


echo Syncing you data from github
git pull origin master

echo Syncing you data from main config
for i in "${!FILES[@]}"; do
	echo syncing ${FILES[$i]}
	rsync -av -e "$SSH" "$MAIN${FILES[$i]}" "${LOCAL}"
done

chown -R root:root $LOCAL