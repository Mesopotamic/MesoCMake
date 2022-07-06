include("${CMAKE_CURRENT_LIST_DIR}/meso_toolchain_helpers.cmake")

# Loads up the cmake toolchain that comes with devkitppc
meso_toolchain_message("Mesopotamic - Wii Toolchain")

# Look for the toolchain in the devkit poc environment variable
if("$ENV{DEVKITPRO}" STREQUAL "")
	message(FATAL_ERROR "No DevkitPro environment variable set")
endif()

# Add DevkitPro CMake to the module search path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} $ENV{DEVKITPRO}/cmake)

# Now add in the wii cmake toolchain
include(Wii)

meso_toolchain_message("Build machine  : ${CMAKE_HOST_SYSTEM_NAME} (${CMAKE_HOST_SYSTEM_PROCESSOR})")
meso_toolchain_message("Target machine : ${CMAKE_SYSTEM_NAME} (${CMAKE_SYSTEM_PROCESSOR})")

# Cache the toolchain variable so that messages aren't repeated
set(MESO_TOOLCHAIN_RUN_ONCE TRUE CACHE BOOL "Stop toolchain messages repeating" FORCE)