#!/bin/bash

##################
# SCRIPT CONFIGS #
##################

# enable script verbose mode
VERBOSE=false

# torrent client download folder
TORRENT_DOWNLOAD_FOLDER=/home/rfpereira/data/torrents
# usenet client download folder
USENET_DOWNLOAD_FOLDER=/home/rfpereira/data/downloads
# supported video file extensions
VIDEO_FILE_EXTENSIONS="\.m2ts$|\.mkv$|\.webm$|\.flv$|\.vob$|\.ogg$|\.ogv$|\.drc$|\.gifv$|\.mng$|\.avi$|\.mov$|\.qt$|\.wmv$|\.yuv$|\.rm$|\.rmvb$|/.asf$|\.amv$|\.mp4$|\.m4v$|\.mp*$|\.m?v$|\.svi$|\.3gp$|\.flv$|\.f4v$"

####################
# SCRIPT FUNCTIONS #
####################

function findFoldersInPath {
    folderDir=$1

    echo "Searching for folders in \"$folderDir\"..."

    while IFS=  read -r -d $'\0'; do
        folders+=("$REPLY")
    done < <(find "$folderDir" -mindepth 2 -maxdepth 2 -type d -print0)
}

function removeFoldersWithNoVideoFiles {
    for folder in "${folders[@]}"
    do
        if $VERBOSE; then
            echo "Testing folder \"$folder\"..."
        fi;
        videoFiles=$(find "$folder" -type f | grep -E $VIDEO_FILE_EXTENSIONS)
        if [ -z "$videoFiles" ]; then
            echo "Folder \"$folder\" has no video files! Removing it... "
            # remove with recursive and force due to folder's content
            rm -rf "$folder"
        fi;
    done
}

##########
# SCRIPT #
##########

# variable to store the list of folders
folders=()

findFoldersInPath $TORRENT_DOWNLOAD_FOLDER
findFoldersInPath $USENET_DOWNLOAD_FOLDER

removeFoldersWithNoVideoFiles

