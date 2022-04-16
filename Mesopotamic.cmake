cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

# Cache the location of the helper directory
set(MESO_CMAKE ${CMAKE_CURRENT_LIST_DIR} CACHE PATH "")

# Use an interface library to ensure that this cmake helper gets added once
if(TARGET MesoCMake)
	return()
endif() 
add_library(MesoCMake INTERFACE)

# Ensure that this directory is in the module path so that our 
# includes work
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Functions)

# Now we're going to add in all of the functions one by one 
include(MesoSortProject)