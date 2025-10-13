set PENDULUM_EXTENSIONS=1

maturin build -vv -j %CPU_COUNT% --release --strip --manylinux off --interpreter=%PYTHON%
if errorlevel 1 exit 1

REM Bundle licenses
pushd %SRC_DIR%\rust
    call cargo-bundle-licenses --format yaml --output ../THIRDPARTY.yml
    if errorlevel 1 exit 1
popd

FOR /F "delims=" %%i IN ('dir /s /b rust\target\wheels\*.whl') DO set dlt_pendulum_wheel=%%i
if errorlevel 1 exit 1

%PYTHON% -m pip install %dlt_pendulum_wheel% -vv --no-deps --no-build-isolation --ignore-installed
if errorlevel 1 exit 1