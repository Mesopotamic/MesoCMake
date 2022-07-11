cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

if(TARGET meso_compile_commands)
	return()
endif()

# Ensure that the compile commands data base is exported for users 
# This is used by a lot of text editors to manage the commands needed for linting
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "" FORCE)

# However this compile commands database is placed into the folder in which the 
# cmake places it's build files, which is usually inside the ROOT/build, but this
# isn't where the text editors read the compile commands 
#
# So we'll make a command that copies compile_commands.json from ROOT/build to the
# ROOT as a post build command. 
#
# To force this target to run we rely on the always running dummy target
include(meso_always_run_target)
include(meso_cmake_common)
	
# In order to make a target always run we need to make it depend on the target which 
# will always run
add_custom_command(
	OUTPUT ${CMAKE_SOURCE_DIR}/compile_commands.json
	COMMAND cmake -E copy ${CMAKE_BINARY_DIR}/compile_commands.json ${CMAKE_SOURCE_DIR}
	COMMENT "Copying compile commands to the source directory"
	COMMENT "Disable by defining \"MESO_NO_CCDB\""
	DEPENDS meso_always_rebuild
	POST_BUILD)

# Finally a command needs to be part of a target to run, although for some 
# incomprehensible reason, you can't have just one custom target which is the 
# dummy target, because then add_depenencies doesn't work. Instead each time
# you have to use a new target and make the target depend on your custom command
if(NOT (DEFINED MESO_NO_CCDB OR "${CMAKE_GENERATOR}" MATCHES "Visual Studio(.*)") )
	add_custom_target(meso_compile_commands ALL 
		DEPENDS ${CMAKE_SOURCE_DIR}/compile_commands.json)

	meso_apply_target_settings(meso_compile_commands)
endif()