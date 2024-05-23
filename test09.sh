#! /usr/bin/env dash

# ==============================================================================
# test09.sh
# test address
#
#
# Written by: Eloisa Hong
# Date: 2024-04-19
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

# Test handle address in print command
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '$p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '$p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle address in quit command
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '$q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '$q' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle address in delete command
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '$d'> "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '$d' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle address in substitute command
cd "$expected_dir" || exit 1
seq 100 110 | 2041 eddy '$s/11/a/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 110 | eddy.py '$s/11/a/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle address combined 1
cd "$expected_dir" || exit 1
seq 100 110 | 2041 eddy '$s/11/a/;$q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 110 | eddy.py ' $s/11/a/;$q' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle address combined 2
cd "$expected_dir" || exit 1
seq 100 110 | 2041 eddy '$p;$d;$s/11/b/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 110 | eddy.py ' $p;$d;$s/11/b/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0