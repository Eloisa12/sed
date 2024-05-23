#! /usr/bin/env dash

# ==============================================================================
# test08.sh
# test comments
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

# Test handle comments
cd "$expected_dir" || exit 1
seq 24 42 | 2041 eddy ' 3, 17  d  # comment' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 24 42 | eddy.py ' 3, 17  d  # comment' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle comments seperated by semicolon
cd "$expected_dir" || exit 1
seq 31 56 | 2041 eddy '/2/d # delete  ;  4  q # quit' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 31 56 | eddy.py '/2/d # delete  ;  4  q # quit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle comments seperated by new line
cd "$expected_dir" || exit 1
echo '/2/d # delete' >  commands.eddy
echo ' # bruh' >>  commands.eddy
echo '20q' >>  commands.eddy
seq 31 56 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo '/2/d # delete' >  commands.eddy
echo ' # bruh' >>  commands.eddy
echo '20q' >>  commands.eddy
seq 31 56 | eddy.py -f commands.eddy > "$actual_output" 2>&1

if !diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi


echo "${GREEN}Passed test${NC}"
exit 0