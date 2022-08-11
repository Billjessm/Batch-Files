@echo off
title Compile release apk of godot

echo.
echo ###################################
echo ### This file was written by    ###
echo ### Jessie Ashley Aka Billjessm ###
echo ### on 08/09/2022               ###
echo ###################################
echo.

echo.
echo ############################################
echo ### This file has a free fair use policy ###
echo ############################################
echo.

echo.
echo #################################################
echo ### Feel free to use and share with everyone! ###
echo #################################################
echo.

echo.
echo ##################################
echo ### Just remember to credit me ###
echo ##################################
echo.

echo.
echo ########################################
echo ### if you have any questions please ###
echo ### don't hesitate to contact me at: ###
echo ###   ""   billjessm@gmail.com  ""   ###
echo ########################################
echo.

echo.
echo ##########################################
echo ### Compiling godotengine for android! ###
echo ##########################################
echo.

echo.
echo ################################################
echo ### Checking If PATH is configured correctly ###
echo ################################################
echo.

where /q git.exe
if ERRORLEVEL 1 (
	goto GITNOTINSTALLED
)else (
	goto GITINSTALLED
)

:GITINSTALLED

where /q python3.exe
if ERRORLEVEL 1 (

	goto PYTHON3NOTINSTALLED

)else (

	goto PYTHONINSTALLED

)

:PYTHONINSTALLED

where /q cmake.exe

if ERRORLEVEL 1 (

	goto CMAKENOTINSTALLED

)else (

	goto CMAKEINSTALLED

)

:CMAKEINSTALLED

where /q ndk-build
if ERRORLEVEL 1 (

	goto NDKNOTINSTALLED

)else (

	goto NDKINSTALLED

)

:NDKINSTALLED

where /q scons.exe
if ERRORLEVEL 1 (

	goto SCONSNOTINSTALLED

)else (

	goto NOERRORS

)

:NOERRORS

echo.
echo #############################################
echo ### PATH Configured Let's Start Compiling ###
echo #############################################
echo.

echo.
echo ############################
echo ### Cloning godot source ###
echo ############################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/godotengine/godot.git

cd godot

echo.
echo #######################################
echo ### Source code cloned successfully ###
echo #######################################
echo.

echo.
echo ###########################################
echo ###  Gathering Vulkan-ValidationLayers  ###
echo ###########################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/Vulkan-ValidationLayers.git

echo.
echo #######################################
echo ### Source code cloned successfully ###
echo #######################################
echo.

cd Vulkan-ValidationLayers

echo.
echo ##########################################
echo ### Building Vulkan-Headers dependency ###
echo ##########################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/Vulkan-Headers.git "%CD%\external\Vulkan-Headers"

cd "%CD%\external\Vulkan-Headers"

mkdir build

cd build

start /b /w "cmake" CMD /C cmake -DCMAKE_INSTALL_PREFIX=..\..\build\install ..

start /b /w "cmake" CMD /C cmake --build . --target install

echo ############################################
echo ### Vulkan-Headers Successfully Compiled ###
echo ############################################

cd ..\..\..\

echo.
echo ##########################################
echo ### Gathering SPIRV-Headers Dependency ###
echo ###    for Vulkan-ValidationLayers     ###
echo ##########################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/SPIRV-Headers.git "%CD%\external\SPIRV-Headers"

echo.
echo #####################################################
echo ### SPIRV-Headers source code cloned successfully ###
echo #####################################################
echo.

cd "%CD%\external\SPIRV-Headers"

echo.
echo ###############################
echo ### Compiling SPIRV-Headers ###
echo ###############################
echo.

mkdir build

cd build

start /b /w "cmake" CMD /C cmake ..

start /b /w "cmake" CMD /C cmake --build . --target install

echo.
echo ###########################################
echo ### SPIRV-Headers Compiled Successfully ###
echo ###########################################
echo.

cd ..\..\..\

echo.
echo ########################################
echo ### Gathering SPIRV-Tools Dependency ###
echo ########################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/SPIRV-Tools.git "%CD%\external\SPIRV-Tools"

echo.
echo #######################################
echo ### SPIRV-Tools cloned successfully ###
echo #######################################
echo.

cd "%CD%\external\SPIRV-Tools"

echo.
echo #########################################
echo ### Checking Sources For Dependencies ###
echo #########################################
echo.
where /q python3.exe
if ERRORLEVEL 1 (

	start /b /w "python" CMD /C python "%CD%\utils\git-sync-deps"

)else (

	start /b /w "python3" CMD /C python3 "%CD%\utils\git-sync-deps"

)


echo.
echo ##########################################
echo ### Gathering SPIRV-Headers Dependency ###
echo ###          For SPIRV-Tools           ###
echo ##########################################
echo.

start /b /w "git" CMD /C git clone https://github.com/KhronosGroup/SPIRV-Headers.git "%CD%\external\spirv-headers"
	
cd "%CD%\external\spirv-headers"

mkdir build

cd build

start /b /w "cmake" CMD /C cmake ..

start /b /w "cmake" CMD /C cmake --build . --target install

echo.
echo ###########################################
echo ### SPIRV-Headers Compiled Successfully ###
echo ###########################################
echo.	
	
cd ..\..\..\

echo.
echo #######################################
echo ### Gathering googletest dependency ###
echo ###        for SPIRV-Tools          ###
echo #######################################
echo.

echo echo y|rmdir /s /q %CD%\external\googletest

start /b /w "git" CMD /C git clone https://github.com/google/googletest.git "%CD%\external\googletest"
	
echo.
echo ######################################
echo ### googletest cloned successfully ###
echo ######################################
echo.		
	
echo.
echo ###################################
echo ### Gathering effcee dependency ###
echo ###################################
echo.

echo echo y|rmdir /s /q "%CD%\external\effcee"

start /b /w "git" CMD /C git clone https://github.com/google/effcee.git "%CD%\external\effcee"

echo.
echo ##################################
echo ### effcee cloned successfully ###
echo ##################################
echo.
	
cd "%CD%\external\effcee\third_party"

echo.
echo #######################################
echo ### Gathering googletest dependency ###
echo ###           for effcee            ###
echo #######################################
echo.

start /b /w "git" CMD /C git clone https://github.com/google/googletest.git

echo.
echo ######################################
echo ### googletest cloned successfully ###
echo ######################################
echo.

echo.
echo ################################
echo ### Gathering re2 dependency ###
echo ###        for effcee        ###
echo ################################
echo.
	
start /b /w "git" CMD /C git clone https://github.com/google/re2.git

echo.
echo ###############################
echo ### re2 cloned successfully ###
echo ###############################
echo.

cd ..

mkdir build

cd build

echo.
echo ########################
echo ### Compiling effcee ###
echo ########################
echo.

start /b /w "cmake" CMD /C cmake ..

start /b /w "cmake" CMD /C cmake --build . --config Release

start /b /w "ctest" CMD /C ctest -C Release

echo.
echo ####################################
echo ### effcee compiled successfully ###
echo ####################################
echo.

cd ..\..\..\

echo.
echo ################################
echo ### Gathering re2 dependency ###
echo ###     for SPIRV-Tools      ###
echo ################################
echo.

start /b /w "git" CMD /C git clone https://github.com/google/re2.git .\external\re2

echo.
echo ###############################
echo ### re2 cloned successfully ###
echo ###############################
echo.

echo.
echo #############################
echo ### Compiling SPIRV-Tools ###
echo #############################
echo.
	
mkdir build

cd build

start /b /w "cmake" CMD /C cmake -G "Visual Studio 17 2022" .. -DSPIRV_ENABLE_LONG_FUZZER_TESTS=ON -DSPIRV_BUILD_FUZZER=ON -DSPIRV_COLOR_TERMINAL=ON

start /b /w "cmake" CMD /C cmake --build . --config Release

cd ..

mkdir android-build

cd android-build

mkdir libs

mkdir app

echo.
echo #####################################
echo ### Building Android Dependencies ###
echo #####################################
echo.

start /b /w "ndk-build" CMD /C ndk-build -C ..\android_test NDK_PROJECT_PATH=%CD% NDK_LIBS_OUT="%CD%\libs" NDK_APP_OUT="%CD%\app" APP_PLATFORM=android-31
		
cd ..

mkdir build

cd build

start /b /w "cmake" CMD /C cmake ..

start /b /w "cmake" CMD /C cmake --build . --config Release

start /b /w "ctest" CMD /C ctest -C Release

cd ..\..\..\

echo.
echo #########################################
echo ### SPIRV-Tools Compiled Successfully ###
echo #########################################
echo.

echo.
echo ####################################
echo ### Gathering glslang dependency ### 
echo ### for Vulkan-ValidationLayers  ###
echo ####################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/glslang.git "%CD%\external\glslang"

echo.
echo ###################################
echo ### glslang cloned successfully ###
echo ###################################
echo.

cd "%CD%\external\glslang"

echo.
echo #######################################
echo ### Gathering googletest dependency ###
echo ###          for glslang            ###
echo #######################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/google/googletest.git External/googletest

echo.
echo ######################################
echo ### googletest cloned successfully ###
echo ######################################
echo.

echo.
echo ##############################
echo ### Configuring googletest ###
echo ##############################
echo.

cd External\googletest
	
start /b /w "git" CMD /C git checkout 0c400f67fcf305869c5fb113dd296eca266c9725
	
cd ..\..\

echo.
echo #############################
echo ### googletest configured ###
echo #############################
echo.

echo.
echo #################################
echo ### Compiling glslang windows ###
echo #################################
echo.

where /q python3.exe
if ERRORLEVEL 1 (

	start /b /w "python" CMD /C python "%CD%\update_glslang_sources.py"

)else (

	start /b /w "python3" CMD /C python3 "%CD%\update_glslang_sources.py"

)



mkdir build

cd build

start /b /w "cmake" CMD /C cmake .. -DCMAKE_INSTALL_PREFIX="$(pwd)/install"

start /b /w "cmake" CMD /C cmake --build . --config Release --target install

start /b /w "ctest" CMD /C ctest -C Release

echo.
echo #############################################
echo ### glslang windows compiled successfully ###
echo #############################################
echo.

cd ..

echo.
echo #################################
echo ### Compiling glslang android ###
echo #################################
echo.

mkdir android-build

cd android-build

start /b /w "git" CMD /C git config --global core.fileMode false

start /b /w "cmake" CMD /C cmake -G "Unix Makefiles" .. -DCMAKE_INSTALL_PREFIX="$(pwd)/install" -DANDROID_ABI=arm64-v8a -DCMAKE_BUILD_TYPE=Release -DANDROID_STL=c++_static -DANDROID_PLATFORM=android-24 -DCMAKE_SYSTEM_NAME=Android -DANDROID_TOOLCHAIN=clang -DANDROID_ARM_MODE=arm -DCMAKE_MAKE_PROGRAM="%ANDROID_NDK_HOME%\prebuilt\windows-x86_64\bin\make.exe" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake

cd ..\..\..\

echo.
echo #############################################
echo ### glslang android successfully compiled ###
echo #############################################
echo.

echo.
echo ##########################################
echo ### Gathering Vulkan-Loader Dependency ###
echo ##########################################
echo.

echo.
echo ####################################
echo ### Cloning Vulkan-Loader Source ###
echo ####################################
echo.

start /b /w "git" CMD /C git clone --recursive https://github.com/KhronosGroup/Vulkan-Loader.git "%CD%\external\Vulkan-Loader"

echo.
echo #########################################
echo ### Vulkan-Loader cloned successfully ###
echo #########################################
echo.

cd "%CD%\external\Vulkan-Loader"

echo.
echo ###############################
echo ### Compiling Vulkan-Loader ###
echo ###############################
echo.

mkdir VulkanLoader_generated_source

cd VulkanLoader_generated_source

mkdir install

where /q python3.exe
if ERRORLEVEL 1 (

	start /b /w "python" CMD /C python ..\scripts\update_deps.py

)else (

	start /b /w "python3" CMD /C python3 ..\scripts\update_deps.py

)

start /b /w "cmake" CMD /C cmake -C helper.cmake -DUPDATE_DEPS=ON -DBUILD_TESTS=ON -DENABLE_WIN10_ONECORE=ON -DUSE_MASM=ON 

start /b /w "cmake" CMD /C cmake --build . --config Release --target VulkanLoader_generated_source

cd ..

mkdir windows_build

cd windows_build

mkdir install

start /b /w "cmake" CMD /C cmake -A x64 .. -DVULKAN_HEADERS_INSTALL_DIR=..\..\build\install -DUPDATE_DEPS=ON -DBUILD_TESTS=ON -DENABLE_WIN10_ONECORE=ON -DUSE_MASM=ON

start /b /w "cmake" CMD /C cmake --build . --config Release --target install

echo.
echo ###########################################
echo ### Vulkan-Loader Successfully Compiled ###
echo ###########################################
echo.

cd ..\..\..\

mkdir windows-build 

cd windows-build

if EXIST "%PROGRAMFILES(X86)%" (set bit=x64)else (set bit=x86)

if "%bit%"=="x64" (

	echo.
	echo ########################################
	echo ### This is a 64bit operating system ###
	echo ########################################
	echo.

	echo.
	echo #################################################
	echo ### Compiling Vulkan-ValidationLayers windows ###
	echo #################################################
	echo.

where /q python3.exe
	if ERRORLEVEL 1 (

		start /b /w "update_deps.py" CMD /C python3 ..\scripts\update_deps.py --arch x64 --config Release --dir ..\external

	)else (

		start /b /w "update_deps.py" CMD /C python3 ..\scripts\update_deps.py --arch x64 --config Release --dir ..\external

	)

	start /b /w "cmake" CMD /C cmake -A x64 -C helper.cmake .. -DCMAKE_BUILD_TYPE=Release -DUPDATE_DEPS=ON -DBUILD_TESTS=ON -DUSE_ROBIN_HOOD_HASHING=ON

	start /b /w "cmake" CMD /C cmake --build . --config Release --target install
			
)else (
	
	echo.
	echo ########################################
	echo ### This is a 32bit operating system ###
	echo ########################################
	echo.

	echo.
	echo #################################################
	echo ### Compiling Vulkan-ValidationLayers windows ###
	echo #################################################
	echo.

where /q python3.exe
if ERRORLEVEL 1 (

		start /b /w "update_deps.py" CMD /C python ..\scripts\update_deps.py --arch Win32 --config Release --dir ..\external

)else (

		start /b /w "update_deps.py" CMD /C python3 ..\scripts\update_deps.py --arch Win32 --config Release --dir ..\external

	)

	start /b /w "cmake" CMD /C cmake -A Win32 -C helper.cmake .. -DCMAKE_BUILD_TYPE=Release -DUPDATE_DEPS=ON -DBUILD_TESTS=ON
		
	start /b /w "cmake" CMD /C cmake --build . --config Release --target install
	
)

echo.
echo #############################################################
echo ### Vulkan-ValidationLayers windows compiled successfully ###
echo #############################################################
echo.

echo.
echo #################################################
echo ### Compiling Vulkan-ValidationLayers android ###
echo #################################################
echo.

cd ..

cd build-android

start /b /w "bat" CMD /C "%CD%\update_external_sources_android.bat"

start /b /w "ndk-build" CMD /C ndk-build

cd ..

mkdir deps

cd deps

if "%bit%"=="x64" (

	start /b /w "cmake" CMD /C cmake -A x64 .. -DVULKAN_HEADERS_INSTALL_DIR=.\build\install -DVULKAN_LOADER_INSTALL_DIR=.\Vulkan-Loader\windows_build\install\ -DGLSLANG_INSTALL_DIR=.\glslang\ -DSPIRV_HEADERS_INSTALL_DIR="%PROGRAMFILES(x86)%\SPIRV-Headers" -DSPIRV_TOOLS_INSTALL_DIR="%PROGRAMFILES(x86)%\SPIRV-Tools"

	start /b /w "cmake" CMD /C cmake --build . --config Release --target install


)else (

	start /b /w "cmake" CMD /C cmake -A x64 .. -DVULKAN_HEADERS_INSTALL_DIR=.\build\install -DVULKAN_LOADER_INSTALL_DIR=.\Vulkan-Loader\windows_build\install\ -DGLSLANG_INSTALL_DIR=.\glslang\ -DSPIRV_HEADERS_INSTALL_DIR="%PROGRAMFILES%\SPIRV-Headers" -DSPIRV_TOOLS_INSTALL_DIR="%PROGRAMFILES(x86)%\SPIRV-Tools"

	start /b /w "cmake" CMD /C cmake --build . --config Release --target install

)


cd ..

xcopy /e /k /h /i /q /o Vulkan-ValidationLayers\build-android\libs\arm64-v8a ..\platform\android\java\app\libs\release\vulkan_validation_layers\arm64-v8a

xcopy /e /k /h /i /q /o Vulkan-ValidationLayers\build-android\libs\armeabi-v7a ..\platform\android\java\app\libs\release\vulkan_validation_layers\armeabi-v7a

xcopy /e /k /h /i /q /o Vulkan-ValidationLayers\build-android\libs\x86 ..\platform\android\java\app\libs\release\vulkan_validation_layers\x86

xcopy /e /k /h /i /q /o Vulkan-ValidationLayers\build-android\libs\x86_64 ..\platform\android\java\app\libs\release\vulkan_validation_layers\x86_64

cd ..

echo.
echo #############################################################
echo ### Vulkan-ValidationLayers android successfully compiled ###
echo #############################################################
echo.

echo.
echo ##########################################################
echo ### Vulkan-ValidationLayers Has Successfully Installed ###
echo ##########################################################
echo.
	
echo.
echo ####################################
echo ### Building android_release.apk ###
echo ####################################
echo.
	
echo.
echo #########################################
echo ### Creating Windows export templates ###
echo #########################################
echo.

mkdir build-windows-templates

cd build-windows-templates

if "%bit%"=="x86" (
	
	start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=windows tools=no target=release_debug bits=32
	
	start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=windows tools=no target=release bits=32

)else (	
	
	start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=windows tools=no target=release_debug bits=64
	
	start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=windows tools=no target=release bits=64

)



echo.
echo ##########################
echo ### Finished Compiling ###
echo ##########################
echo.
echo.
echo ##################################################
echo Build files have been written to:              ###
echo %USERPROFILE%\AppData\Roaming\Godot\templates\ ###  
echo ##################################################
echo.
	
cd ..

start /b /w "keytool" CMD /C keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12

start /b /w "keytool" CMD /C keytool -v -genkey -keystore godot.keystore -alias godot -keyalg RSA -validity 10000

mkdir build-android-templates

cd build-android-templates

echo.
echo ####################################
echo ### Starting Scons Android Build ###
echo ####################################
echo.

echo.
echo ####################################
echo ### Building android_release.apk ###
echo ####################################
echo.

start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release android_arch=armv7
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release android_arch=arm64v8
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release android_arch=x86
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release android_arch=x86_64

echo.
echo.
echo ############################################
echo ### The resulting APK will be located at ###
echo ###      bin\android_release.apk         ###
echo ############################################
echo.

echo.
echo ##################################
echo ### Building android_debug.apk ###
echo ##################################
echo.


start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release_debug android_arch=armv7
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release_debug android_arch=arm64v8
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release_debug android_arch=x86
		
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% platform=android target=release_debug android_arch=x86_64

echo.
echo.
echo ############################################
echo ### The resulting APK will be located at ###
echo ###        bin\android_debug.apk         ###
echo ############################################
echo.
		
cd ..

mkdir build-windows

cd build-windows

echo.
echo ####################################
echo ### Starting Scons Windows Build ###
echo ####################################
	
start /b /w "scons" CMD /C scons .. -j%NUMBER_OF_PROCESSORS% p=windows vsproj=yes

start /b /w "cmake" CMD /C cmake --build . --config  release
	
echo.
echo.
echo ##############################
echo ### Scons Windows Complete ###
echo ##############################
echo.
echo.
echo.

echo.
echo ###############################
echo ### Starting android gradle ###
echo ###############################
echo.
	
cd ..\platform\android\java
	
start /b /w "gradle" CMD /C .\gradlew generateGodotTemplates

echo.
echo ############################################
echo ### android gradle finished successfully ###
echo ############################################
echo.

cd ..\..\..\

xcopy /e /k /h /i /q /o "%CD%\bin\android_debug.apk" "%APPDATA%\Godot\export_templates\arm64-v8a"

xcopy /e /k /h /i /q /o "%CD%\bin\android_debug.apk" "%APPDATA%\Godot\export_templates\armeabi-v7a"

xcopy /e /k /h /i /q /o "%CD%\bin\android_debug.apk" "%APPDATA%\Godot\export_templates\x86_64"

xcopy /e /k /h /i /q /o "%CD%\bin\android_debug.apk" "%APPDATA%\Godot\export_templates\x86"

xcopy /e /k /h /i /q /o "%CD%\bin\android_release.apk" "%APPDATA%\Godot\export_templates\arm64-v8a"

xcopy /e /k /h /i /q /o "%CD%\bin\android_release.apk" "%APPDATA%\Godot\export_templates\armeabi-v7a"

xcopy /e /k /h /i /q /o "%CD%\bin\android_release.apk" "%APPDATA%\Godot\export_templates\x86_64"

xcopy /e /k /h /i /q /o "%CD%\bin\android_release.apk" "%APPDATA%\Godot\export_templates\x86"

exit /b

:GITNOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo ##################################
echo ### git is not present in PATH ###
echo ##################################
echo.
echo.
exit /b 1    
rem exiting the call and setting the %errorlevel% to 1 

:SCONSNOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo ####################################
echo ### scons is not present in PATH ###
echo ####################################
echo.
echo.
exit /b 1    
rem exiting the call and setting the %errorlevel% to 1 

:PYTHON3NOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo ######################################
echo ### python3 is not present in PATH ###
echo ######################################
echo.
echo.
goto PYTHONMAYBE     

:PYTHONMAYBE

where /q python3.exe
if ERRORLEVEL 1 (

	goto PYTHONNOTINSTALLED

)else (

	goto PYTHONINSTALLED

)

:PYTHONNOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo #####################################
echo ### python is not present in PATH ###
echo #####################################
echo.
echo.
exit /b 1    
rem exiting the call and setting the %errorlevel% to 1 


:CMAKENOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo ####################################
echo ### cmake is not present in PATH ###
echo ####################################
echo.
echo.
exit /b 1    
rem exiting the call and setting the %errorlevel% to 1 

:NDKNOTINSTALLED

call :getError     
rem Calling the :getError label
echo Errorlevel: %ERRORLEVEL%     
rem Echoing the errorlevel returned by :getError
pause
:getError
echo.
echo.
echo ########################################
echo ### ndk-build is not present in PATH ###
echo ########################################
echo.
echo.
exit /b 1    
rem exiting the call and setting the %errorlevel% to 1 

exit