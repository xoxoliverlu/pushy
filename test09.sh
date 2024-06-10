#!/bin/dash


# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Create pushy repository

cat > "$expected_output" <<EOF
Initialized empty pushy repository in .pushy
EOF

pushy-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# create multiple files
touch a b c d e 
pushy-add a b c d e
pushy-commit -m "first commit" > /dev/null
echo "1" >> a
echo "2" >> b
echo "3" >> c
echo "4" >> d
echo "5" >> e

pushy-add a b c

echo "6" >> c



# file changed, changes staged for commit
cat > "$expected_output" <<EOF
c - file changed, different changes staged for commit
EOF

pushy-status | grep -E "^c" > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


echo "Passed test"
exit 0