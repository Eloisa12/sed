#! /usr/bin/env dash

# ==============================================================================
# test03.sh
# test substitute command
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

##################################### Subset0 #####################################

# normal substition - regex1
cd "$expected_dir" || exit 1
seq 10 20 | 2041 eddy 's/[15]/aa/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 10 20 | eddy.py 's/[15]/aa/' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# normal substition - regex2
cd "$expected_dir" || exit 1
seq 100 111 | 2041 eddy 's/11/bb/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 111 | eddy.py 's/11/bb/' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test substitution with optional modifier g
cd "$expected_dir" || exit 1
echo hehehehehehehehe | 2041 eddy 's/e/h/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo hehehehehehehehe | eddy.py 's/e/h/' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test substitution with optional modifier g
cd "$expected_dir" || exit 1
echo hehehehehehehehe | 2041 eddy 's/e/h/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
echo hehehehehehehehe | eddy.py 's/e/h/g' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test substitution with address - line number
cd "$expected_dir" || exit 1
seq 51 60 | 2041 eddy '5s/5/c/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 51 60 | eddy.py '5s/5/c/g' > "$actual_output" 2>&1


if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test substitution with address - regex
cd "$expected_dir" || exit 1
seq 100 111 | 2041 eddy '/1.1/s/1/d/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 111 | eddy.py '/1.1/s/1/d/g' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

##################################### Subset1 #####################################
# Test normal substitution with delimiter - Upper case letter
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 'sX[15]XzzzX' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 'sX[15]XzzzX' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test normal substitution with delimiter - Lower case letter
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 'sx[15]xzzzx' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 'sx[15]xzzzx' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test normal substitution with delimiter - Symbol _
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 's-[15]-zzz-' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 's-[15]-zzz-' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test normal substitution with delimiter 
# - delimiter same as the command
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 'ss[15]szzzs' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 'ss[15]szzzs' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test normal substitution with delimiter 
# - delimiter same as the command
# - with line number address
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '5ss[15]szzzs' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '5ss[15]szzzs' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter 
# - with line number address
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3s-[15]-zzz-' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '3s-[15]-zzz-' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter -
# - with regex address
cd "$expected_dir" || exit 1
seq 100 111 | 2041 eddy '/1.1/s-[15]-zzz-' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 100 111 | eddy.py '/1.1/s-[15]-zzz-' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter - complex combination
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 'sX[15]Xz/z/zX' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 'sX[15]Xz/z/zX' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter - complex combination: / in regex
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy 's/[15]/z/z/z/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py 's/[15]/z/z/z/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter - complex combination: / in regex
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '3s/[15]/z/z/z/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '3s/[15]/z/z/z/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with delimiter - complex combination: / in regex
cd "$expected_dir" || exit 1
seq 1 5 | 2041 eddy '/1/s/[15]/z/z/z/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 5 | eddy.py '/1/s/[15]/z/z/z/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# # Test address substitution with delimiter - complex combination: escape
# cd "$expected_dir" || exit 1
# seq 1 5 | 2041 eddy 's/[15]/z\/z\/z/' > "$expected_output" 2>&1


# cd "$test_dir" || exit 1
# seq 1 5 | eddy.py 's/[15]/z\/z\/z/' > "$actual_output" 2>&1

# if ! diff "$expected_output" "$actual_output"; then
#     visualise_output "$actual_output" "$expected_output"
#     echo "${RED}Failed test${NC}"
#     exit 1
# fi

# # Test address substitution with delimiter - complex combination: escape
# cd "$expected_dir" || exit 1
# seq 1 5 | 2041 eddy '5s/[15]/z\/z\/z/' > "$expected_output" 2>&1


# cd "$test_dir" || exit 1
# seq 1 5 | eddy.py '5s/[15]/z\/z\/z/' > "$actual_output" 2>&1

# if ! diff "$expected_output" "$actual_output"; then
#     visualise_output "$actual_output" "$expected_output"
#     echo "${RED}Failed test${NC}"
#     exit 1
# fi

# # Test address substitution with delimiter - complex combination: escape
# cd "$expected_dir" || exit 1
# seq 100 111 | 2041 eddy '/1.1/s/[15]/z\/z\/z/' > "$expected_output" 2>&1


# cd "$test_dir" || exit 1
# seq 100 111 | eddy.py '/1.1/s/[15]/z\/z\/z/' > "$actual_output" 2>&1

# if ! diff "$expected_output" "$actual_output"; then
#     visualise_output "$actual_output" "$expected_output"
#     echo "${RED}Failed test${NC}"
#     exit 1
# fi

# Test address substitution with range address(line number)
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '2,15s/[1234]/e/' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '2,15s/[1234]/e/' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with range address(regex)
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,/9$/s/[0-9]/f/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,/9$/s/[0-9]/f/g' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with range address(combined)
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '/2$/,7s/[0-9]/g/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '/2$/,7s/[0-9]/g/g' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

# Test address substitution with range address(combined)
cd "$expected_dir" || exit 1
seq 1 20 | 2041 eddy '3,/7$/s/[0-9]/h/g' > "$expected_output" 2>&1


cd "$test_dir" || exit 1
seq 1 20 | eddy.py '3,/7$/s/[0-9]/h/g' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    visualise_output "$actual_output" "$expected_output"
    echo "${RED}Failed test${NC}"
    exit 1
fi

echo "${GREEN}Passed test${NC}"
exit 0