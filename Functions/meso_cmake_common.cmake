# Sets up all of the common properties that every single Mesopotamic CMake project uses 
# For example, we set the C standard to C89.
# There are other properties such as setting the output directory
# and managing the cross build platform settings, such as making visual studio 
# to use the correct runtime directory, because it doesn't use the same runtime directory
# as the directory the exe is placed into, but the dlls have to be in the same directory 
# as the executable...

function(meso_apply_target_settings TARGET_NAME) 

	# First check that the target exists 
	if(NOT TARGET ${TARGET_NAME})
		message(FATAL_ERROR "Mesopotamic : Trying to apply settings to a target which doesn't exist")
	endif()

	# Turn folders on 
	set_property(GLOBAL PROPERTY USE_FOLDERS ON)

	# Set all of the target properties in one go
	# We do this so that we don't change any cmake values which might effect user builds
	set_target_properties(${TARGET_NAME} PROPERTIES
		# Place this project in a Mesopotamic Folder
		FOLDER "Mesopotamic"

		# Set the C standard to ANSI C 89/90
		# 90 is the international version of 89
		C_STANDARD "90"

		# Tell Visual studio where it should be reading file paths from
		# i.e setting the working directory to be the exe output directory
		# we can do this with a generator expression
		VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:${TARGET_NAME}>")
	# End of target properties

endfunction()

# Add a convenient little function that adds a Mesopotamic example
# It just places the example into another source group
function(meso_apply_example_target_settings TARGET_NAME)
	meso_apply_target_settings(${TARGET_NAME})

	# Apply other target settings used just for examples
	set_target_properties(${TARGET_NAME} PROPERTIES
		FOLDER "Mesopotamic/examples")

endfunction()