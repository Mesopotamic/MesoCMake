cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

# CMake Helper File
# It takes a CMake Target and then sorts all of the files
# This basically makes it so that a visual studio project
# will then have the same folder structure as the actual
# files themselves 
#
# For example you won't have HeaderFiles SourceFiles that 
# visual studio usually segements sources into for some 
# reason

function(meso_sort_target TARGET_NAME)
	# Ensure the target actually exists
	if(NOT TARGET ${TARGET_NAME})
		message(FATAL_ERROR "Meso_sort_target : No target called ${TARGET_NAME}")
	endif()

	# Get a list of all of the source files in the target
	# Store the value in the TARGET SOURCES variable
	get_target_property(TARGET_SOURCES ${TARGET_NAME} SOURCES)

	# The following is then based on a stackoverflow answer https://stackoverflow.com/a/31423421
	# Basically we're taking all of the sources from the project and making them relative to 
	# their project root
	foreach(source ${TARGET_SOURCES})

		# Get relative path from the source variable
        if (IS_ABSOLUTE "${source}")
            file(RELATIVE_PATH relativeSource "${CMAKE_CURRENT_SOURCE_DIR}" "${source}")
        else()
            set(relativeSource "${source}")
        endif()

        # Ensure we have the directory containing the file
        # in a way visual studio understands 
        get_filename_component(sourcePath "${relativeSource}" PATH)
        string(REPLACE "/" "\\" formatedSourcePath "${sourcePath}")

        # Set the file to be grouped by it's relative location
        source_group("${formatedSourcePath}" FILES "${source}")
    endforeach()

endfunction()
