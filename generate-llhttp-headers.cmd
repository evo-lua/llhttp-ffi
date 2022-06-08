@echo off
REM Generating the llhttp C output requires:
REM	git for Windows (obviously)
REM	clang (install llvm)
REM	npx (install node/npm)
REM	make for Windows (install from GNU)

cd llhttp

REM We don't care about audits as we don't use node itself
REM and its many (broken) errors will fail the script needlessly
CALL npm install --save-dev --no-audit --no-fund @types/node
make release

cd ..