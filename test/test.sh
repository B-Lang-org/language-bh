#!/bin/bash

baseDir=$(dirname "$PWD")
echo "Running tests from base directory $baseDir"

# Arrays containing full test filepaths.
named=("$PWD"/tests/*)
#tickets=("$PWD"/tickets/*)

# Arrays containing filenames of broken tests.
namedBroken=()
#ticketsBroken=(
#  "T0001.hs"
#  "T0002.hs"
#)

# Colours used to display test outputs.
RED='\033[0;31m'
MAGENTA='\033[0;35m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Test if 'vscode-tmgrammar-test' is installed in npx
# and error early if not, with a message to use the "package*.json" files
npx --no -- vscode-tmgrammar-test -h > /dev/null 2>&1
status=$?
if [ $status -ne 0 ]
then
    echo -e "ERROR: Package 'vscode-tmgrammar-test' not installed, run \"npm ci\" or \"npm install\""
    exit 1
fi

# 'runTests' runs the 'vscode-tmgrammar-test' command on all test files in a directory,
# reporting which tests had unexpected outcomes.
#
# runTests
#   :: [ FilePath ]      -- ^ $1: array of tests to be run.
#   -> [ TestName ]      -- ^ $2: array of filenames in this directory for tests that are expected to fail.
#   -> MArray s TestName -- ^ $3: array of tests that unexpectedly failed (this function appends these to the array)
#   -> MArray s TestName -- ^ $4: array of tests that unexpectedly passed (this function appends these to the array).
#   -> ST s ExitCode     -- ^ Exit code: 0 if no unexpected outcomes, 1 otherwise.
runTests () {

  local dir=$1
  local expectedFails=$2
  # This function also expects the following to be globally available
  #   unexpectedFails
  #   unexpectedPasses
  # They could be defined with "local -n" but older bash does not support it

  syntaxes=()
  source=""

  for filepath in "${dir[@]}"
  do
    file=$(basename -- "$filepath")
    ext="${file##*.}"
    name="${file%.*}"

    # Check whether the test is expected to fail.
    expectBroken=0
    for broken in "${expectedFails[@]}"
    do
      if [ "$broken" == "$file" ]
      then
        expectBroken=1
      fi
    done

    # Set the appropriate syntax file for the test.
    case $ext in

      "bs" | "bh" )
        syntaxes=( "$baseDir/syntaxes/bh.json" )
        ;;

      * )
        syntaxes=()
        ;;

    esac

    if [ ${#syntaxes[@]} -eq 0 ]
    then
      echo "runTests: $file has unsupported file extension '$ext', ignoring"
    else
      specifySyntaxes=""
      for i in ${syntaxes[*]}; do
        specifySyntaxes="$specifySyntaxes -g $i"
      done
      # Run the test.
      #  The --no option avoids hanging at an invisible prompt if the package
      #  has not been installed, in case the install above failed
      result=$(npx --no -- vscode-tmgrammar-test $specifySyntaxes "$filepath")
      # Check test result by inspecting the exit code of the previous command.
      status=$?
      if [ $status -eq 0 ]
      then
        if [ $expectBroken -eq 0 ]
        then
          echo -e "${GREEN}Pass   (expected)${NC} $file"
        else
          unexpectedPasses+=("$name")
          echo -e "${MAGENTA}Pass (unexpected)${NC} $file"
        fi
      else
        if [ $expectBroken -eq 0 ]
        then
          unexpectedFails+=("$name")
          echo -e "${RED}Fail (unexpected)${NC} $file"
          echo -e "$result"
        else
          echo -e "${YELLOW}Fail   (expected)${NC} $file"
        fi
      fi
    fi
  done
}

# Initialise arrays of tests with unexpected results.
unexpectedFails=()
unexpectedPasses=()

# Run the named tests (in the 'tests' folder).
runTests ${named} ${namedBroken}
# Run the ticket tests (in the 'tickets' folder).
#runTests ${tickets} ${ticketsBroken}

# Return the appropriate exit code.
if [ ${#unexpectedFails[@]} -eq 0 ] && [ ${#unexpectedPasses[@]} -eq 0 ]
then
  # No unexpected test outcomes.
  exit 0
else
  # Unexpected test outcomes.
  exit 1
fi
