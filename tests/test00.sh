#! /usr/bin/env dash

# ==============================================================================
# test00.sh
# test quit command
#
#
# Written by: Eloisa Hong
# Date: 2024-04-08
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

visualise_output() {
    echo "${NC}Your program produce${RED}"
    cat "$1"
    echo "${NC}The correct output is${GREEN}"
    cat "$2"
}

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"

cd "$test_dir" || exit 1
expected_dir="$(mktemp -d)"

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir" "expected_dir"' INT HUP QUIT TERM EXIT

##################################### TEST #####################################
# Test basic quit with line number 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '3q' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic quit with line number 2
cd "$expected_dir" || exit 1
seq 9 20 | 2041 eddy '5q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 9 20 | eddy.py '5q' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic quit with regex
cd "$expected_dir" || exit 1
seq 9 20 | 2041 eddy '/1{3}/q' > "$expected_output" 2>&1

cd "$test_dir" || exit 1
seq 9 20 | eddy.py '/1{3}/q' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test quit will prints an "infinite" number of lines containing "yes".
cd "$expected_dir" || exit 1
yes | 2041 eddy '3q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
yes | eddy.py '3q' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0