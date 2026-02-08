#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="mod4assgoutput.txt"

# Check input argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

frame_time=""
fc_type=""
fc_subtype=""

# Read file line by line
while IFS= read -r line; do

    if echo "$line" | grep -q '"frame.time"'; then
        frame_time=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    if echo "$line" | grep -q '"wlan.fc.type"'; then
        fc_type=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    if echo "$line" | grep -q '"wlan.fc.subtype"'; then
        fc_subtype=$(echo "$line" | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    fi

    # If all parameters collected → write output
    if [ -n "$frame_time" ] && [ -n "$fc_type" ] && [ -n "$fc_subtype" ]; then
        {
            echo "\"frame.time\": $frame_time,"
            echo "\"wlan.fc.type\": $fc_type,"
            echo "\"wlan.fc.subtype\": $fc_subtype"
            echo
        } >> "$OUTPUT_FILE"

       
        frame_time=""
        fc_type=""
        fc_subtype=""
    fi

done < "$INPUT_FILE"

echo "Extraction completed. Output saved to mod4assgoutput.txt"

