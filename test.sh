#!/bin/bash
set -eou pipefail

function test_fixture() {
	local FIXTURE_FILE="${1-}"
	echo "➡️ Running checks on ${FIXTURE_FILE}..."
	local TEST_FILE="${FIXTURE_FILE#fixtures/}"

	if [[ ${TEST_FILE} != *.md ]]; then
		echo "➖ ${FIXTURE_FILE} skipped, not a markdown file"
		return
	fi
	if [[ ${TEST_FILE} == good* ]]; then
		test_acceptable "${FIXTURE_FILE}"
		return
	fi
	if [[ ${TEST_FILE} == bad* ]]; then
		test_unacceptable "${FIXTURE_FILE}"
		return
	fi
	echo "➖ Fixture ${FIXTURE_FILE} skipped, must start with 'good' or 'bad'"
}

function test_acceptable() {
	local FIXTURE_FILE="${1-}"
	if bash check-readme-newlines.sh ${FIXTURE_FILE}; then
		echo "✅ Validated good README successfully!"
	else
		echo "🚫 Invalidated good README unsuccessfully. Did ${FIXTURE_FILE#fixtures/} file change? 😉"
		return 1
	fi
}

function test_unacceptable() {
	local fixture_file="${1-}"
	if ! bash check-readme-newlines.sh ${fixture_file}; then
		echo "✅ Invalidated bad README successfully!"
	else
		echo "🚫 Validated bad README unsuccessfully. Did ${fixture_file#fixtures/} file change? 😉"
		return 1
	fi
}

for file in fixtures/*; do
	if [[ -f "$file" ]]; then
		TEST_CASE=$(basename "$file")
		test_fixture "fixtures/$TEST_CASE"
		echo
	fi
done

