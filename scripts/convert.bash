#!/usr/bin/env bash

# Define color codes
GREEN='\033[0;32m'
BOLD='\033[1m'
REGULAR='\033[0m'
RED='\033[0;31m'

IFS=$'\n'

# Check if the current directory is valid for building the project
if [[ -e .root || ! -d ../build ]]; then
    echo -e "${RED}You cannot build this project under this directory!${REGULAR}"
    exit 1
fi

# Function to search for the root directory containing .root
function search_root {
    local root_dir=$(pwd)

    while [[ "$root_dir" != "/" ]]; do
        if [[ -f "$root_dir/.root" ]]; then
            echo "$root_dir"
            return
        fi
        root_dir=$(dirname "$root_dir")
    done

    # If .root file is not found
    echo -e "${RED}You are not in the project directory!${REGULAR}"
    exit 1
}

# Function to generate PDF filename from a markdown file path
function generate_pdf_filename_from_path 
{
    echo $(basename "$1" .md)".pdf"  # Replace .md with .pdf
}

# Function to calculate and print the current percentage
function current_percentage {
    local up="$1"
    local dr="$2"
    # Use shell arithmetic to avoid `bc`
    local pct=$(( (up * 100) / dr ))
    echo "$pct%"
}

# Find the root directory
SOURCE_ROOT_DIR="$(search_root)"

# Find all markdown files under the source root directory
ALL_MARKDOWN_FILES=($(find "$SOURCE_ROOT_DIR" -type f -name "*.md"))
FILE_COUNT=${#ALL_MARKDOWN_FILES[@]}
CURRENT_FILE=1

# Create output PDF directory
mkdir -p pdf

# Process each markdown file
for FILE in "${ALL_MARKDOWN_FILES[@]}"; do
    echo -ne "${GREEN}[$(current_percentage $CURRENT_FILE $FILE_COUNT)]:\t${BOLD}Converting file: $FILE <"
    "$SOURCE_ROOT_DIR/scripts/convert.py" "$FILE" "$PWD/pdf/$(generate_pdf_filename_from_path "$FILE")"
    echo -e ">${REGULAR}"
    ((CURRENT_FILE++))  # Increment the file counter
done
