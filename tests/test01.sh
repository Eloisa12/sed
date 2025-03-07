#! /usr/bin/env dash

# ==============================================================================
# test00.sh
# test print command
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

# Test basic print with line number 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '3p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with line number 2
cd "$expected_dir" || exit 1
seq 9 20 | 2041 eddy '5p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 9 20 | eddy.py '5p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with regex
cd "$expected_dir" || exit 1
seq 65 85 | 2041 eddy '/^7/p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 65 85 | eddy.py '/^7/p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with address range(line number) seperated by comma
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '5,12p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '5,12p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with address range (regex) seperated by comma
cd "$expected_dir" || exit 1
seq 2 20 | 2041 eddy '/2$/,/12$/p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 2 20 | eddy.py '/2$/,/12$/p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with address range (regex and line number combined)
cd "$expected_dir" || exit 1
seq 2 20 | 2041 eddy '2,/12$/p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 2 20 | eddy.py '2,/12$/p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with address range (regex and line number combined)
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,8p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,8p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test basic print with range (combined)
cd "$expected_dir" || exit 1
seq 10 40 | 2041 eddy.py '/2/,4p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 40 | eddy.py '/2/,4p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test prevent default print with range (combined)
cd "$expected_dir" || exit 1
seq 10 40 | 2041 eddy.py -n '/2/,4p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 40 | eddy.py -n '/2/,4p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test prevent default print with combined argument
cd "$expected_dir" || exit 1
seq 10 40 | 2041 eddy.py -n '/2/,4p;/2,3d/5p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 40 | eddy.py -n '/2/,4p;/2,3d/5p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0