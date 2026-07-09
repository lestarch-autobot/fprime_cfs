#
# Compatibility shims for building against older cFE versions (e.g. draco-rc5)
#
# Modules calling the shimmed functions should `include(cfs_compat)` before the
# first call. The mission must have this directory on CMAKE_MODULE_PATH, e.g.:
#   list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../libs/fprime_cfs/cmake")
#

# generate_configfile_set() was introduced after draco. Provide an equivalent
# implementation on top of generate_config_includefile() when it is missing.
if (NOT COMMAND generate_configfile_set)
  function(generate_configfile_set)
    set(CFGFILE_PREFIX)

    if (CFE_EDS_ENABLED)
      list(APPEND CFGFILE_PREFIX "eds")
    endif(CFE_EDS_ENABLED)

    list(APPEND CFGFILE_PREFIX "default")

    foreach(CFGFILE ${ARGN})
      # Locate the correct fallback file
      set(DEFAULT_SOURCE)
      foreach (FBPREFIX ${CFGFILE_PREFIX})
        set(CHECK_FILE "${CMAKE_CURRENT_LIST_DIR}/config/${FBPREFIX}_${CFGFILE}")
        if (EXISTS ${CHECK_FILE})
          set(DEFAULT_SOURCE FALLBACK_FILE "${CHECK_FILE}")
          break()
        endif()
      endforeach()

      generate_config_includefile(
        FILE_NAME           "${CFGFILE}"
        ${DEFAULT_SOURCE}
      )
    endforeach()
  endfunction(generate_configfile_set)
endif()
