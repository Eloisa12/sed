#! /usr/bin/env dash

# ==============================================================================
# test05.sh
# test multiple command
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

# Test multiple commands by semiclons - 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '4q;/2/d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '4q;/2/d' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 2
cd "$expected_dir" || exit 1
seq 2 6 | 2041 eddy '/2/d;4q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 2 6 | eddy.py '/2/d;4q' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 3
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/8$/d;4,6p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/8$/d;4,6p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 4: many commands
cd "$expected_dir" || exit 1
seq 10 40 | 2041 eddy '/2$/,/8$/d;4,10p;s/1/a/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 40 | eddy.py '/2$/,/8$/d;4,10p;s/1/a/' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 1
cd "$expected_dir" || exit 1
seq 10 20 | 2041 eddy '4q;/2/d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 20 | eddy.py '4q;/2/d' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 2
cd "$expected_dir" || exit 1
seq 10 20 | 2041 eddy '/2/d;4q' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 20 | eddy.py '/2/d;4q' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 3
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/8$/d;4,6p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/8$/d;4,6p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 4
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '2,4p;1,3p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '2,4p;1,3p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 5
cd "$expected_dir" || exit 1
seq 1 10 | 2041 eddy '2,4p;1,3p;2,4d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 10 | eddy.py '2,4p;1,3p;2,4d' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 6
cd "$expected_dir" || exit 1
seq 1 10 | 2041 eddy '2,4p;1,3p;2,4d;1,3d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 10 | eddy.py '2,4p;1,3p;2,4d;1,3d' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 4: start range from middle print
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/8$/d;4,10p' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/8$/d;4,10p' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 5: start range from middle delete
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/8$/p;4,10d' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/8$/p;4,10d' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by semiclons - 6: start range from middle substitute
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/8$/p;4,10s/[2468]/even/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/8$/p;4,10s/[2468]/even/' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test multiple commands by new line - 1
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '4q
/2/d' > "$expected_output" 2>&1

cd "$test_dir" || exit 1
seq 1 5 | 2041 eddy '4q
/2/d' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0