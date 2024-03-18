# Copyright (c) 2024 Fries_I23
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

browser="Google Chrome"

cd "$(dirname "$0")"/..
dart run coverage:test_with_coverage --branch-coverage --function-coverage
mkdir coverage/html
genhtml coverage/lcov.info -o coverage/html
[ -z "$SKIP_OPENURL" ] && (
    command -v xdg-open &>/dev/null &&
        xdg-open coverage/html/index.html ||
        command -v open &>/dev/null &&
        open -a "$browser" coverage/html/index.html
)
