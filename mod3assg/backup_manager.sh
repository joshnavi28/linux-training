#!/bin/bash

# 1. Command-line arguments
SOURCE_DIR="$1"
BACKUP_DIR="$2"
EXT="$3"

# Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <extension>"
    exit 1
fi

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist"
    exit 1
fi

# Create backup directory if missing
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR" || exit 1
fi

# Globbing 
FILES=("$SOURCE_DIR"/*"$EXT")

# If no matching files
if [ ! -e "${FILES[0]}" ]; then
    echo "No files with extension $EXT found"
    exit 0
fi

# Export statement
export BACKUP_COUNT=0
TOTAL_SIZE=0

echo "Files to be backed up:"

#file names and sizes
for file in "${FILES[@]}"; do
    size=$(stat -c %s "$file")
    echo "$(basename "$file") - $size bytes"
done

# Backup 
for file in "${FILES[@]}"; do
    name=$(basename "$file")
    dest="$BACKUP_DIR/$name"

    if [ ! -f "$dest" ] || [ "$file" -nt "$dest" ]; then
        cp "$file" "$dest"
        ((BACKUP_COUNT++))
        TOTAL_SIZE=$((TOTAL_SIZE + $(stat -c %s "$file")))
    fi
done

# Report
echo "Backup Report" > "$BACKUP_DIR/backup_report.log"
echo "Files backed up: $BACKUP_COUNT" >> "$BACKUP_DIR/backup_report.log"
echo "Total size: $TOTAL_SIZE bytes" >> "$BACKUP_DIR/backup_report.log"
echo "Backup location: $BACKUP_DIR" >> "$BACKUP_DIR/backup_report.log"

echo "Backup completed"

