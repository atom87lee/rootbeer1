@echo off
rem vcvarsall can't be found easily using environment variables, it's is tucked away in the registry somewhere but 
rem probably overkill here, update this if you have a different install directory
set "vcvarsall=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

if NOT EXIST "%vcvarsall%" (
	echo Could not find vcvarsall.bat, open compileCudaRuntime2.bat and edit location of vcvarsall
	EXIT
)

if NOT EXIST "%CUDA_PATH%"(
	echo Could not find Cuda Toolkit installed, as CUDA_PATH environment variable was not set
	EXIT
)

if NOT EXIST "%JAVA_HOME%"(
	echo Could not find JDK installed, as JAVA_HOME environment variable was not set
	EXIT
)

if [%1] == [32] (
	@call "%vcvarsall%" x86
	cl /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" /I"%CUDA_INC_PATH%" CudaRuntime2.c FastMemory.c Handles.c Cuda2DeviceMemory.c /link "%CUDA_PATH%\lib\Win32\cuda.lib" /DLL /OUT:cudaruntime.dll /MACHINE:X86
) else (
	if [%1] == [64] (
		@call "%vcvarsall%" amd64
		cl /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" /I"%CUDA_INC_PATH%" CudaRuntime2.c FastMemory.c Handles.c Cuda2DeviceMemory.c /link "%CUDA_PATH%\lib\x64\cuda.lib" /DLL /OUT:cudaruntime.dll /MACHINE:X64
		) else (
		echo Must specify which 32 or 64 bit build, e.g.compileCudaRuntime2.bat 32
		EXIT 0
	)
)

echo Copying dll to src\edu\syr\pcpratts\rootbeer\runtime2\native\
move /-y .\cudaruntime.* ..\src\edu\syr\pcpratts\rootbeer\runtime2\native\