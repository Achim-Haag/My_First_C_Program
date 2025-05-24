# https://learn.microsoft.com/en-us/shows/visual-studio-code/cpp-in-vs-code-building-your-code-with-cmake

message(STATUS ">>> Start CMake preparation")

# Select main program
set(MyMainPgm  "Achims_C-Test_241115.c")

# Enable function cmake_print_variables (but printed only on save to CMakeLists.txt !)
include(CMakePrintHelpers)
cmake_print_variables(CMAKE_CURRENT_BINARY_DIR CMAKE_BUILD_TYPE CMAKE_CONFIGURATION_TYPES)

# minimum CMake version
CMAKE_MINIMUM_REQUIRED(VERSION 3.31)

# set the project name, version and languag C
PROJECT(My_First_C_Program VERSION 1.0 LANGUAGES C)

# allow CMake's own testing environment
include(CTest)
enable_testing()

# compile submodule words.c to .obj if changed
add_library(words OBJECT words.c)
target_compile_definitions(words PUBLIC WORDS)

#
# Further Build depending on environmend (Linux, Windows-MVSC, unknown)
#
if(LINUX) 
# linux stuff here
    message(STATUS ">>> Prepare for Linux")

# set variables for RHEL environment
# gcc creates executable in folder ${CMAKE_CURRENT_BINARY_DIR}
	set(MyExeOutpath "${CMAKE_CURRENT_BINARY_DIR}")
	set(MyExeSuffix  "")
	set(MyPdbSuffix  ".filenotexisting")
	set(MySubmodules "$<TARGET_OBJECTS:words>")
	cmake_print_variables(MyExeOutpath MyExeSuffix MySubmodules)

elseif(MSVC)
# stuff that should happen not on Linux 
    message(STATUS ">>> Prepare for Windows Microsoft Visual C/C++")

# set variables for Windows Microsoft Visual C/C++ environment
# MSVC creates .exe in subfolders "release" or "debug" and .pdb only in subfolder "debug"
	set(MyExeOutpath "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CONFIGURATION_TYPES}")
	set(MyExeSuffix  ".exe")
	set(MyPdbSuffix  ".pdb")
	set(MySubmodules "$<TARGET_OBJECTS:getopt>" "$<TARGET_OBJECTS:words>")
	cmake_print_variables(MyExeOutpath MyExeSuffix MySubmodules)

# MSVC-only: compile submodule getopts.c to .obj if changed
	add_library(getopt OBJECT getopt.c)
	target_compile_definitions(getopt PUBLIC GETOPT)
else()
# Don't know what's to do 
	message(SEND_ERROR ">>> Unknown environment, exit CMake preparation")
#
endif()

# compile main program if main program or submodule word.c (Linux) or words.c/getopts.c (MSVC) have been changed
# important: although my source name contains a date, the name of the resulting .exe (=target) is without this date
message(STATUS ">>> Prepare executable generation")
add_executable(Achims_C-Test ${MyMainPgm})
target_link_libraries(Achims_C-Test ${MySubmodules})

# Processing executable after build
message(STATUS ">>> Prepare copy of executable to source folder")
add_custom_command(TARGET Achims_C-Test POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan
	"Folder ${MyExeOutpath} postprocessing")

# copy executable to source folder if not different to existing
add_custom_command(	TARGET Achims_C-Test POST_BUILD
	COMMENT "- Achims_C-Test${MyExeSuffix} : copy executable to source folder if newer"
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		${MyExeOutpath}/Achims_C-Test${MyExeSuffix}
		${CMAKE_SOURCE_DIR}
	)

# only Windows Debug build will create .pdb (debugger symbol file) : 
# if one exists in build folder (Windows Debug Build only):
# 	copy if newer to source folder
# else = if none exists in build folder (Windows Release & Linux Release + Debug Builds)
#   delete old one in source folder
message(STATUS ">>> Prepare processing of Windows debug file if necessary")
#	
if (EXISTS ${MyExeOutpath}/Achims_C-Test${MyPdbSuffix})
# if Windows Debug Build, copy .pdb file to source folder if different
		add_custom_command(	TARGET Achims_C-Test POST_BUILD
		COMMENT "- Achims_C-Test${MyPdbSuffix} : copy pdb to source folder if newer"
		COMMAND ${CMAKE_COMMAND} -E copy_if_different
			${MyExeOutpath}/Achims_C-Test${MyPdbSuffix}
			${CMAKE_SOURCE_DIR}
	)
else()
# if not Windows Debug build, remove existing .pdb file from source folder
	add_custom_command(	TARGET Achims_C-Test POST_BUILD
	COMMENT	"- Achims_C-Test${MyPdbSuffix} : remove if existing (dbg symbol file)"
	COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/Achims_C-Test${MyPdbSuffix}
	)
# show a message
endif()


message(STATUS ">>> CMake preparation finished")
# end
						