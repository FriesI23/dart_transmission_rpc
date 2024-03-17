# Copyright (c) 2024 Fries_I23
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

cd "$(dirname "$0")"/..
dart run coverage:test_with_coverage --branch-coverage --function-coverage
mkdir coverage/html
genhtml coverage/lcov.info -o coverage/html
[ -z "$SKIP_OPENURL" ] && command -v xdg-open &> /dev/null && \
    xdg-open "$1" || command -v open &> /dev/null && open "$1"