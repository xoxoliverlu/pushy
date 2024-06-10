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

# Attempt to add a file before init

cat > "$expected_output" <<EOF
pushy-add: error: pushy repository directory .pushy not found
EOF

touch a
pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create pushy repository

cat > "$expected_output" <<EOF
Initialized empty pushy repository in .pushy
EOF

pushy-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Add one file inside a pushy repository

cat > "$expected_output" <<EOF
EOF


pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF


pushy-commit -m 'first commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
0 first commit
EOF


pushy-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# edit file, commit, and try logging out from commit 0

echo "line1" >> a
pushy-add a
pushy-commit -m "second commit" > /dev/null
cat > "$expected_output" <<EOF
line1
EOF

pushy-show 1:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

echo "Passed test"
exit 0