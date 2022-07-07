# Detect which backend should be used from the current build params
# from there we can automatically select the right file path
# After the backend is selected return out, that way after 
# reaching the end we can error out for unsupported backends

# Defines
# meso_gfx_backend - glsl, Wiigx etc
# meso_window_backend - win32, wiigx etc


if(WIN32)
	set(meso_gfx_backend "glsl")
	set(meso_window_backend "win32")
	return()
endif()

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
	set(meso_gfx_backend "glsl")
	set(meso_window_backend "linux")
	return()
endif()

if(${CMAKE_SYSTEM_NAME} STREQUAL "NintendoWii")
	set(meso_gfx_backend "wii")
	set(meso_window_backend "wii")
	return()
endif()

message(FATAL_ERROR "Unknown or unsupported backend requested")