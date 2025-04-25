# https://learn.microsoft.com/en-us/shows/visual-studio-code/cpp-in-vs-code-building-your-code-with-cmake

# minimum CMake version
CMAKE_MINIMUM_REQUIRED(VERSION 3.31)

# set the project name, version and languag C
PROJECT(My_First_C_Program VERSION 1.0 LANGUAGES C)

# allow CMake's own testing environment
include(CTest)
enable_testing()

# compile submodules to .obj
add_library(words OBJECT words.c)
target_compile_definitions(words PUBLIC WORDS)
add_library(getopt OBJECT getopt.c)
target_compile_definitions(getopt PUBLIC GETOPT)

# compile main program if submodules have been changed
# important: although my source name contains a date, the name of the resulting .exe (=target) is without this date
add_executable(Achims_C-Test Achims_C-Test_241115.c)
target_link_libraries(Achims_C-Test $<TARGET_OBJECTS:getopt> $<TARGET_OBJECTS:words>)

# copy executable to source folder
add_custom_command(	TARGET Achims_C-Test POST_BUILD
					COMMAND ${CMAKE_COMMAND} -E copy_if_different
						${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}/Achims_C-Test.exe
						${CMAKE_SOURCE_DIR}
						)
						
# end
						