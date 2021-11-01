
REM running this script successfully requires:
REM	git for Windows (obviously)
REM	clang (install llvm)
REM	npx (install node/npm)
REM	make for Windows (install from GNU)

git clone https://github.com/nodejs/llhttp
cd llhttp
REM We don't care about audits as we don't use node itself
REM and its many (broken) errors will fail the script needlessly
CALL npm install --save-dev --no-audit --no-fund @types/node
make release

REM If there were no errors, the header should be in
REM	<llhttp_ffi root>/llhttp/release/include/llhttp.h

REM For ease of use, let's move it to the root
copy release\include\llhttp.h ..

REM And restore the cwd so we can run it repeatedly
cd ..