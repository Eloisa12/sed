#! /usr/bin/env dash

# ==============================================================================
# test06.sh
# test input file
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

# Test input file - print
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy '1,4p' a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py '1,4p' a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - quit
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy '3q' a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py '3q' a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - delete
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy '2,3d' a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py '2,3d' a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - substitute
cd "$expected_dir" || exit 1
seq 100 110 > a.txt
seq 115 120 > b.txt
2041 eddy 's/^11/wa/' a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 110 > a.txt
seq 115 120 > b.txt
eddy.py 's/^11/wa/' a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - combined 1
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy '4q;/2/d' a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py '4q;/2/d' a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - combined 2 (reverse file order)
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy '4q;/2/d' b.txt a.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py '4q;/2/d' b.txt a.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - more files 1
cd "$expected_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
seq 2 4 > c.txt
seq 3 9 > d.txt
2041 eddy '4q;/2/d' a.txt b.txt c.txt d.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 2 > a.txt
seq 1 5 > b.txt
seq 2 4 > c.txt
seq 3 9 > d.txt
eddy.py '4q;/2/d' a.txt b.txt c.txt d.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - input file + command file
cd "$expected_dir" || exit 1
echo 4q   >  commands.eddy
echo /2/d >> commands.eddy
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy -f commands.eddy a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo 4q   >  commands.eddy
echo /2/d >> commands.eddy
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py -f commands.eddy a.txt b.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - -n + input file + command file 
cd "$expected_dir" || exit 1
echo /2/d > commands.eddy
echo 1,3p > commands.eddy
seq 1 2 > a.txt
seq 1 5 > b.txt
2041 eddy -n -f commands.eddy a.txt b.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo /2/d > commands.eddy
echo 1,3p > commands.eddy
seq 1 2 > a.txt
seq 1 5 > b.txt
eddy.py -n -f commands.eddy a.txt b.txt > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - empty
cd "$expected_dir" || exit 1
seq 1 10 > a.txt
2041 eddy '4q;/2/d' a.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 10 > a.txt
eddy.py '4q;/2/d' a.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test input file - doesn't exist
cd "$expected_dir" || exit 1
2041 eddy '4q;/2/d' not_exist.txt > "$expected_output" 2>&1


cd "$test_dir" || exit 1
eddy.py '4q;/2/d' not_exist.txt > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi


echo "${GREEN}Passed test${NC}"
exit 0