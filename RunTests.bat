@echo off
setlocal

if "%1"=="" (
    echo.
    echo Workspace path not given!!!
	echo Usage : RunTest.bat "Workspace Full path" "Build Configutation [Debug/Release/RelWithDebInfo]"
    pause
    goto END
)

if "%2"=="" (
    echo.
    echo Configuration not given!!!
	echo Usage : RunTest.bat "Workspace Full path" "Build Configutation [Debug/Release/RelWithDebInfo]"
    pause
    goto END
)

set PATH=%PATH%;%1\vmmlib\__build\bin\%2;%1\GLStats\__build\bin\%2;%1\Collage\__build\bin\%2;%1\Equalizer\__build\bin\%2;%1\Lunchbox\__build\bin\%2;%ARTIFACTORY_DIR%\boost-win64-vc140-1.68\bin


cd "%1\vmmlib\__build"
"C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process -C %2

cd "%1\GLStats\__build"
"C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process -C %2

cd "%1\Lunchbox\__build"
"C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process -C %2

cd "%1\Collage\__build"
"C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process -C %2

cd "%1\Equalizer\__build"
"C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process -C %2

:END
pause




