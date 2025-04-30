# https://learn.microsoft.com/en-us/shows/visual-studio-code/cpp-in-vs-code-building-your-code-with-cmake

message(STATUS ">>> Start")

# Enable function cmake_print_variables (but printed only on save to CMakeLists.txt !)
include(CMakePrintHelpers)
cmake_print_variables(CMAKE_CURRENT_BINARY_DIR CMAKE_BUILD_TYPE)

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
    message(STATUS ">>> Linux")

# set variables for RHEL environment
	set(MyExeOutpath "${CMAKE_CURRENT_BINARY_DIR}")
	set(MyExeSuffix  "")
	set(MySubmodules "$<TARGET_OBJECTS:words>")
	cmake_print_variables(MyExeOutpath MyExeSuffix MySubmodules)

elseif(MSVC)
# stuff that should happen not on Linux 
    message(STATUS ">>> Windows Microsoft Visual C/C++")

# set variables for Windows Microsoft Visual C/C++ environment
# external pgm getopt.c has to be added as no intrinsic in MSVC
	set(MyExeOutpath "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}")
	set(MyExeSuffix  ".exe")
	set(MySubmodules "$<TARGET_OBJECTS:getopt>" "$<TARGET_OBJECTS:words>")
	cmake_print_variables(MyExeOutpath MyExeSuffix MySubmodules)

# MSVC-only: compile submodule getopts.c to .obj if changed
	add_library(getopt OBJECT getopt.c)
	target_compile_definitions(getopt PUBLIC GETOPT)
else()
# Don't know what's to do 
	message(SEND_ERROR ">>> Unknown environment, exit CMake")
#
endif()

# compile main program if main program or submodule word.c (Linux) or words.c/getopts.c (MSVC) have been changed
# important: although my source name contains a date, the name of the resulting .exe (=target) is without this date
message(STATUS ">>> Generating executable")
add_executable(Achims_C-Test Achims_C-Test_241115.c)
target_link_libraries(Achims_C-Test ${MySubmodules})

# copy executable to source folder
message(STATUS ">>> Copy executable to source folder")
add_custom_command(	TARGET Achims_C-Test POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		${MyExeOutpath}/Achims_C-Test${MyExeSuffix}
		${CMAKE_SOURCE_DIR}
	)
add_custom_command(TARGET Achims_C-Test POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan
	"${MyExeOutpath}/Achims_C-Test${MyExeSuffix} copied to ${CMAKE_SOURCE_DIR}")

message(STATUS ">>> CMake finished")
# end
						