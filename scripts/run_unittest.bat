rem Copyright (c) 2024 Fries_I23
rem
rem This software is released under the MIT License.
rem https://opensource.org/licenses/MIT

set genhtml=C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml

cd /d "%~dp0\.."
dart run coverage:test_with_coverage --branch-coverage --function-coverage
mkdir coverage/html
perl %genhtml% coverage/lcov.info -o coverage/html
@IF "%SKIP_OPENURL%"=="" start coverage/html/index.html
