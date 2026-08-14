#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 filename.md|filename.pdf"
    exit 1
fi

INPUT="$1"

# Extract extension and basename
EXT="${INPUT##*.}"
BASE="${INPUT%.*}"

if [ "$EXT" = "md" ]; then
    # Case 1: Input is a markdown file
    OUTPUT="${BASE}.pdf"
    pandoc -f markdown+yaml_metadata_block -t beamer "$INPUT" -o "$OUTPUT"

elif [ "$EXT" = "pdf" ]; then
    # Case 2: Input is a pdf file - convert from corresponding markdown
    MD_INPUT="${BASE}.md"

    if [ ! -f "$MD_INPUT" ]; then
        echo "Error: Markdown file '$MD_INPUT' does not exist."
        exit 1
    fi

    pandoc -f markdown+yaml_metadata_block -t beamer "$MD_INPUT" -o "$INPUT"

else
    echo "Error: Unsupported file type '$EXT'. Only .md or .pdf allowed."
    exit 1
fi
