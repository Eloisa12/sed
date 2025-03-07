#! /usr/bin/env dash

# ==============================================================================
# test07.sh
# test white space
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

# Test handle white space in print command 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 3p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in print command 2
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3 p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3 p' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in print command 3
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3p ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3p ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in print command: ULTIMATE WHITESPACE RAID
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 2, 4p  ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 2, 4p  ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in quit command 1:
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 4q  ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 4q  ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in quit command 2:
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 4 q  ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 4 q  ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in delete command 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 3d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3d' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in delete command 2
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3 d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3 d' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in delete command 3
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3d ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 3d ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in delete command: ULTIMATE WHITESPACE RAID
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy ' 2, 4d  ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py ' 2, 4d  ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test handle white space in substitute command 1
cd "$expected_dir" || exit 1
seq 100 110 | 2041 eddy ' s/11/chopstick/ ' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 110 | eddy.py ' s/11/chopstick/ ' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# # Test handle white space in substitute command 2: whitespace in replacing string
# cd "$expected_dir" || exit 1
# seq 100 110 | 2041 eddy ' s/11/chop stick/ ' > "$expected_output" 2>&1


# cd "$test_dir" || exit 1
# seq 100 110 | eddy.py ' s/11/chop stick/ ' > "$actual_output" 2>&1

# if ! diff "$expected_output" "$actual_output"; then
#     visualise_output "$actual_output" "$expected_output"
#     echo "${RED}Failed test${NC}"
#     exit 1
# fi

# Test handle white space in command file
cd "$expected_dir" || exit 1
echo ' /11/p  ' >  commands.eddy
echo ' ' >>  commands.eddy
echo ' 4q' >>  commands.eddy
seq 100 110 | 2041 eddy -f commands.eddy > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo ' /11/p  ' >  commands.eddy
echo ' ' >>  commands.eddy
echo ' 4q' >>  commands.eddy
seq 100 110 | eddy.py -f commands.eddy > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0