#!/bin/bash
set -eou pipefail

file="${1-:}"

if [[ ! -f "${file}" ]]; then
    echo "File ${file} not found"
    exit 1
fi

# https://developer.wordpress.org/plugins/wordpress-org/how-your-readme-txt-works/#readme-header-information
README_HEADER_SECTIONS=("Contributors" "Donate link" "Tags" "Requires at least" \
"Tested up to" "Stable tag" "Requires PHP" "License" "License URI")

HEADER_ALRADY_READ=0
INVALID_LINE_FOUND=0

# Read the README line by line
while IFS= read -r line; do
    # The very first header is skipped, any future headers (#) inform us we are past
    # the header section and should continue.
    if [[ "${line}" == "#"* ]]; then
        if [[ "${HEADER_ALRADY_READ}" -eq 1 ]]; then
            break
        fi
        HEADER_ALRADY_READ=1
        continue
    fi
    
    # Check if the line is empty
    if [[ "${line}" == "" ]]; then
        continue
    fi
    
    # Skip if the line does not contain a colon
    if [[ "${line}" != *":"* ]]; then
        continue
    fi
    
    # Check if the line matches any of the strings (case-insensitive)
    IS_README_HEADER_LINE=0
    for section in "${README_HEADER_SECTIONS[@]}"; do
        if [[ "${line}" =~ $section ]]; then
            IS_README_HEADER_LINE=1
            break
        fi
    done
    if [[ "${IS_README_HEADER_LINE}" -ne 1 ]];then
        continue
    fi
    
    # Check if the line ends with two spaces
    if [[ "${line}" =~ .*[[:space:]]{2}$ ]]; then
        continue
    fi

    # It's OK if the line does not end in two spaces, if there is a second line break.
    # Use awk to search for the pattern and check for multiple newlines
    if awk -v pattern="${line}" '
      BEGIN {
        found = 0
        count = 0
      }
      $0 ~ pattern {
        found = 1
        next
      }
      found && NF == 0 {
        count++
        next
      }
      found && NF > 0 {
        if (count > 1) {
          exit 1
        }
        count = 0
      }
      END {
        if (count > 1 || (count == 1 && NF > 0)) {
          exit 1
        }
        exit !found
      }' "$file"; then
      echo "Multiple newlines found after '${line}'."
      continue
    else
      echo "No multiple newlines found after '${line}'."
    fi


    INVALID_LINE_FOUND=1
done < "$file"

if [[ ${INVALID_LINE_FOUND} -eq 1 ]];then
    echo "⛔️ Invalid"
    exit 1
fi

echo "🎊 Valid"