# mediacenter-maintenance

This repository has the scripts to perform the maintenance at my media center for the *rr applications I use.

## Remove unmonitored video files

This script will go through all the child directories and check if they contain any video file that is no longer monitored by any of the *rr applications.

```bash
sudo ./remove_unmonitored_video_files.sh
```

## Remove folders without video files

This script will go through all the child directories and check if they contain any video files. If they are empty or only contain files that are not video files, the folder and its content will be removed from the disk.

```bash
sudo ./remove_folders_without_video_files.sh
```