cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

# This is a bit of an interesting one. The point of this target is to produce cmake code 
# which will always run every time without fail. Because sometimes you do need cmake code
# to always execute.
#
# How do we handle this?
# We produce a custom command which has an output, but that output is never actually produced
# That means the command will always run, and will make anything else dependant on it run as 
# well.
#
# However those custom commands aren't going to run if a target doesn't trigger them. However,
# we can't provide just a single dummy target. Instead the user is responsible for making the 
# target and making the command depend on the custom command, see meso_compile_commands

if(COMMAND meso_always_rebuild)
	# Stop this command from getting added multiple times
	return()
endif()

add_custom_command(
		OUTPUT meso_always_rebuild
		COMMAND cmake -E true
		COMMENT "Mesopotamic dummy command - triggers rebuilds")

