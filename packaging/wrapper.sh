#!/bin/bash

set -e

TARGET_FILE=$0

cd `dirname $TARGET_FILE`
TARGET_FILE=`basename $TARGET_FILE`

# Iterate down a (possible) chain of symlinks
while [ -L "$TARGET_FILE" ]
do
    TARGET_FILE=`readlink $TARGET_FILE`
    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`
done

# Compute the canonicalized name by finding the physical path
# for the directory we're in and appending the target file.
PHYS_DIR=`pwd -P`
RESULT=$PHYS_DIR/$TARGET_FILE

# Figure out where this script is located.
SELFDIR=$(dirname "$RESULT")


# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/lib/app/Gemfile"
unset BUNDLE_IGNORE_CONFIG

# Run the actual app using the bundled Ruby interpreter.
exec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/app/bin/octodown" "$@"
