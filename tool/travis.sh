#!/usr/bin/env bash

# Runs all of the presubmit checks on every pub package in this repository.
#
# For a faster dev-cycle, use `pub run presubmit` yourself in a package.

function run_coveralls {
  if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "dev" ]; then
    dart tool/create_test_all.dart
    pub global activate dart_coveralls
    pub global run dart_coveralls report \
      --retry 2 \
      --exclude-test-files \
      tool/test_all.dart
    rm tool/test_all.dart
  fi
}

# Fast fail the script on failures.
set -e

# Download the presubmit runner.
pub run presubmit
