#!/bin/bash
set -eou pipefail

echo "Validate all fields are bad"
echo "Running checks on fixtures/bad-all.md..."
if ! bash check-readme-newlines.sh fixtures/bad-all.md; then
    echo "✅ Validated bad README successfully!"
else
    echo "🚫 Invalidated bad README unsuccessfully. Did the bad-all.md file change? 😉"
    exit 1
fi

echo "Validate single line is bad"        
echo "Running checks on fixtures/bad-single.md..."
if ! bash check-readme-newlines.sh fixtures/bad-single.md; then
    echo "✅ Validated bad README successfully!"
else
    echo "🚫 Invalidated bad README unsuccessfully. Did the bad-single.md file change? 😉"
    exit 1
fi