# Here's where we're going to provide CMake helper functions for when you're using shared libraries


# The best use case is going to be copying the shared libraries into the same directory as the 
# executable. However, I think an important thing for users to note here, is that this build
# rule will only run when the TARGET_NAME target builds. So if you make a change to the shared
# library and don't change the executable, then the library won't get copied over.
#
# This is the main reason behind mesopotamic offering the Build static version. Because if 
# you're doing library development, then it's a pain in the ass.
# btw adding a dependency doesn't work either
function(meso_shared_libary_copy TARGET_NAME SHARED_LIB_TARGET_NAME)

	# First check that if either of these targets actually exist
	if(NOT TARGET ${TARGET_NAME})
		message(FATAL_ERROR "Mesopotamic : Executable target ${TARGET_NAME} doesn't exist yet.")
	endif()
	if(NOT TARGET ${SHARED_LIB_TARGET_NAME})
		message(FATAL_ERROR "Mesopotamic : Shared library target ${SHARED_LIB_TARGET_NAME} " 
			"either doesn't exist or isn't defined as a CMake target")
	endif()

	# Now check that the target name is actually a shared library
	get_target_property(target_type ${SHARED_LIB_TARGET_NAME} TYPE)
	if(NOT ${target_type} STREQUAL "SHARED_LIBRARY")
		message(WARNING "Mesopotamic : CMake target ${SHARED_LIB_TARGET_NAME} is not a shared library.")
	endif()

	# Now we add in a post build step which will copy the shared library to the directory containing
	# The executable 
	add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:${SHARED_LIB_TARGET_NAME}> $<TARGET_FILE_DIR:${TARGET_NAME}>
		COMMENT "Copying shared library ${SHARED_LIB_TARGET_NAME} to project ${TARGET_NAME}")

endfunction()