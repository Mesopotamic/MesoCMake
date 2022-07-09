include("${CMAKE_CURRENT_LIST_DIR}/meso_toolchain_helpers.cmake")

meso_toolchain_message("Mesopotamic - Android Toolchain")
meso_toolchain_message("You can control the ndk and android api version by setting MESO_ANDROID_API_VER and MESO_NDK_VER")

# Find the cmake folder inside the android sdk with multiple
# possible cmake versions
set(ANDROID_ROOT $ENV{ANDROID_SDK_ROOT})
if("${ANDROID_ROOT}" STREQUAL "")
	message(FATAL_ERROR "ANDROID_SDK_ROOT environment variable not set")
endif()

# Replace the windows directory seperators as \ gets interpretated as an escape sequence
string(REPLACE "\\" "/" ANDROID_ROOT "${ANDROID_ROOT}")

if(NOT EXISTS ${ANDROID_ROOT})
	message(FATAL_ERROR "ANDROID_SDK_ROOT environment variable points to not existing directory")
endif()

#
# NDK Version
#

# Android stores the ndk version in either ndk-bundle or ndk/versions
# ndk-bundle is I think outdated, so we look for ndk first and then select the version we want
# That will be the highest version or the version selected by the user
file(GLOB sdk_files RELATIVE ${ANDROID_ROOT} ${ANDROID_ROOT}/*)
foreach(files ${sdk_files})
	if(${files} STREQUAL "ndk-bundle")
		set(ndk_bundle_found TRUE)
	endif()
	if(${files} STREQUAL "ndk")
		set(ndk_versions_found TRUE)
	endif()
endforeach()

if(ndk_versions_found)
	# We've found all the different versions of the ndk
	set(ndk_path ${ANDROID_ROOT}/ndk)

	# Get each of the versions found
	file(GLOB ndk_versions RELATIVE ${ndk_path} ${ndk_path}/*)
	list(SORT toolchains)

	if(MESO_NDK_VER)
		# If the user has selected a ndk version try to find it
		if(${MESO_NDK_VER} IN_LIST ndk_versions)
			set(ndk_ver ${MESO_NDK_VER})
		else()
			message(FATAL_ERROR "Requested ndk ${MESO_NDK_VER} not found")
		endif()
	else()
		# Select the highest version of the ndk found
		list(GET ndk_versions -1 ndk_ver)
	endif()

	# Combine the ndk_ver with the ndk path
	set(ndk_path ${ndk_path}/${ndk_ver})

elseif(ndk_bundle_found)
	# Only found ndk-bundle
	ser(ndk_ver "nkd-bundle")
	set(ndk_path ${ANDROID_ROOT}/ndk-bundle)
else()
	message(FATAL_ERROR "No ndk found inside the android sdk")
endif()

meso_toolchain_message("ndk version : ${ndk_ver}")
list(APPEND CMAKE_MODULE_PATH "${ndk_path}/build/cmake")

#
# Now select the the Minimum android sdk version - We do that reading what's in the platform
#
set(platform_path "${ANDROID_ROOT}/platforms")
file(GLOB platform_files RELATIVE ${platform_path} ${platform_path}/*)
list(SORT platform_files)


if(MESO_ANDROID_API_VER)
	# Check if the requested api version is in the android platforms folder
	if(NOT "android-${MESO_ANDROID_API_VER}" IN_LIST platform_files)
		message(FATAL_ERROR "Requested android api version not found ${MESO_ANDROID_API_VER}")
	else()
		set(android_api_ver ${MESO_ANDROID_API_VER})
	endif()
else()
	# Select the highest version inside the android platform
	list(GET platform_files -1 android_api_ver)
	string(REPLACE "android-" "" android_api_ver "${android_api_ver}")
endif()

meso_toolchain_message("Android API version : ${android_api_ver}")

# Ensure that the api version is higher than the minum supported which is 16
if(NOT ${android_api_ver} GREATER 16)
	message(FATAL_ERROR "Android api version must be atleast 16")
endif()

set(ANDROID_PLATFORM ${android_api_ver} CACHE INTERNAL "" FORCE)
include(android.toolchain)

# Cache the toolchain variable so that messages aren't repeated
set(MESO_TOOLCHAIN_RUN_ONCE TRUE CACHE BOOL "Stop toolchain messages repeating" FORCE)