#! /usr/bin/env dash

# ==============================================================================
# test04.sh
# test -f command
#
#
# Written by: Eloisa Hong
# Date: 2024-04-22
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

# Test -f command - 1
cd "$expected_dir" || exit 1
echo 4q   >  commands.eddy
echo /3/d >> commands.eddy
seq 1 10 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo 4q   >  commands.eddy
echo /3/d >> commands.eddy
seq 1 10 | eddy.py -f commands.eddy > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test -f command - 2
cd "$expected_dir" || exit 1
echo /3/d > commands.eddy
echo 4q   >>  commands.eddy
seq 1 10 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo /3/d > commands.eddy
echo 4q   >>  commands.eddy
seq 1 10 | eddy.py -f commands.eddy > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test -f command - 3
cd "$expected_dir" || exit 1
echo /4/d > commands.eddy
echo 2,5p   >>  commands.eddy
echo 4q   >>  commands.eddy
seq 10 20 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo /4/d > commands.eddy
echo 2,5p   >>  commands.eddy
echo 4q   >>  commands.eddy
seq 10 20 | eddy.py -f commands.eddy > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test -f command - invalid usage 1
cd "$expected_dir" || exit 1
seq 10 20 | 2041 eddy -f not_exist.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 20 | eddy.py -f not_exist.eddy > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test -f command - invalid usage 2
cd "$expected_dir" || exit 1
echo 'bruh' >  commands.eddy
seq 1 20 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo 'bruh' >  commands.eddy
seq 1 20 | eddy.py -f commands.eddy > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0