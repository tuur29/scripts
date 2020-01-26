
# Scripts

Note: most of the scripts contain more info and a guide at the top of the file.

# Config files & Cheat Sheets

## My Gitconfig
> Contains command shortcuts and abbreviations, as well as some useful more complicated functions.

[Link](./my.gitconfig)

## My ZSH config

[Link](./my.zshrc)

## My Bash config
> Specifically for git bash on Windows, might work on unix as well

[Link](./mygit.bashrc)

## Code Snippets
> Some useful JS, PHP, HTML, CSS and General code snippets for Visual Studio Code

[Link](./global.code-snippets)

## Windows key remaps
> A few small keybindings for windows made with AutoHotKey

[Link](./winBindings.ahk)

## Custom Search Engines
> A list of all my custom search engines in Chrome.

[Link](./CustomSearchEngines.md)
or read [more info](https://support.google.com/chrome/answer/95426?co=GENIE.Platform%3DDesktop&hl=en)

## Visual Studio Code extensions
> A list of all my VSC extensions

[Link](./VSCextentions.md)

## Bash Cheat Sheet

> A cheatsheet of some of my frequent shell commands so I don't have to scour StackOverflow each time.

[Link](./BashCheatSheet.md)


# Google (Drive) Scripts

## Table Of Contents
> Fills a Google Sheet with all subfolders and files in a given Google Drive folder.

[Link](./TableOfGoogleDriveContents.txt)

## Duplicates Finder
> Makes a Google Sheet that lists all duplicate files in selected subfolders (same name & size).

[Link](./DuplicatesFinderGoogleDrive.txt)

## Check Trashed Items With Multiple Parents
> This scripts checks recently removed files and folders and sends you an email when it finds items that had multiple parents.

[Link](./CheckTrashedItemsWithMultipleParents.txt)


# Home Automation

## Amazon Dash button listener
> Simplest way to hack your Amazon Dash buttons. Listen for packets sent by a dash button on the network.

[Link](./dashbuttonlistener.sh)

## Toggle Sonoff S20 Power
> Control your S20 without any hardware modifications or app.

[Link](./toggleS20Power.js)

## Cheap Wifi Doorbell
> Send Pushbullet or Join notification if wireless doorbell rings (by connecting GPIO pin to LED wires).

[Link](./checkBell.py)

## Lights On At Sunset
> Enable a Phillips Hue profile when sun has gone down.

[Link](./lightOnAtSunset.pl)

## Turn Off Forgotten Lights
> Turn of Phillips Hue lights when a specific device hasn't been on the network for some time.

[Link](./forgottenLightsCheck.pl)

## Lights Off After Outage
> Phillips Hue light have the pesky behaviour of turning on full brightness after a power outage. This script turns them off immediately after.

[Link](./lightsOffAfterOutage.pl)

## Log all devices on network
> Very simple script that keeps track of every connected device on the network. I use this to determine actions in other scripts.

[Link](./pingDevices.sh)

## Schedule Command
> Simple script to delay a predefined command by x minutes.

[Link](./sheduleCommand.sh)


# Crawling & Downloaders

## Recursive Torrent Starter
> This script scans all subfolders for torrent files and starts downloading them in the same subfolder as said file.

[Link](./recursivetorrentdownload.sh)

## Download Tumblr With Tags In Filename
> This script will download all photos from a Tumblr blog in the original quality and adds all used tags to the filename.

[Link](./downloadTumblr.pl)


# Gaming

## MC Server Log Watcher
> This script parses a running Minecraft server log and sends a Pushbullet notification on certain events.

[Link](./checkMCServer.ps1)

## Restart MC Server
> This AutoHotkey script lets all online players know the server will be restarted before doing so.

[Link](./restartMCServer.ahk)


# Data Viz

## Time Value Pairs
> Quickly visualize and offer some simple statistics for csv files with a unix timestamp and a corresponding integer value.

[Link](./visualizeTimeValuePairs.R)


# Development

## Deploy Build To Github Pages
> This script will run a build command of your choice and push the output to the gh-pages branch. Made for webapps in JS Webapps.

[Link](./deployBuildToGithubPages.sh)


# Automation

## pauseGPMDP.js
> Pause music on a locally running 'Google Play Music Desktop Player' instance.

[Link](./pauseGPMDP.js)

## deleteArchivedTrelloCards.js
> Remove all archived cards older than 14 days form a Trello board

[Link](./deleteArchivedTrelloCards.js)
