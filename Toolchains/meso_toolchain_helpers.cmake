# Helpers that are used during the running of toolchains

# A function for printing messages during the running of toolchains
function(meso_toolchain_message message)

    # For some reason toolchains seem to run multiple time at configuration time
    # I think this is due to the toolchain running for both C and C++
    # So only do a message when we haven't defined MESO_TOOLCHAIN_RUN_ONCE

    if(NOT MESO_TOOLCHAIN_RUN_ONCE)
    	message(STATUS ${message})
    endif()

endfunction()