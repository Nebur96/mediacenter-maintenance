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
# radarr symlink movies folder
MOVIES_FOLDER=/home/rfpereira/data/media/movies
# sonarr symlink tv shows folder
TV_SHOWS_FOLDER=/home/rfpereira/data/media/tv

################
# SCRIPT LOGIC #
################

# file array that will store the reference to the files that do not exist either on movies or tv shows
files=()

while IFS=  read -r -d $'\0'; do
  filename=$REPLY
  if $VERBOSE; then
    echo "Checking if file \"$filename\" is being used..."
  fi;

  file=$(find $MOVIES_FOLDER/ $TV_SHOWS_FOLDER/ -samefile "$filename")
  if [ -z "$file" ]; then
    if $VERBOSE; then
      echo "File \"$file\" is not present in the movies or tvshows folders. Adding it to the list of files to remove..."
    fi;
    files+=("$filename")
  fi;
    
done < <(find $TORRENT_DOWNLOAD_FOLDER -type f -size +1M -print0)

unusedFilesCount=${#files[@]}

echo "Found \"$unusedFilesCount\" unused files."

if (($unusedFilesCount>0)); then
  for file in "${files[@]}"
  do
    echo "Deleting file \" $file\"..."
    folder=${file%/*}
    rm "$file"
    videoFiles=$(find $folder -type f | grep -E "\.webm$|\.flv$|\.vob$|\.ogg$|\.ogv$|\.drc$|\.gifv$|\.mng$|\.avi$|\.mov$|\.qt$|\.wmv$|\.yuv$|\.rm$|\.rmvb$|/.asf$|\.amv$|\.mp4$|\.m4v$|\.mp*$|\.m?v$|\.svi$|\.3gp$|\.flv$|\.f4v$")
    if [ -z "$videoFiles" ]; then
	    rm -rf "$folder"
    fi;
  done
fi;

