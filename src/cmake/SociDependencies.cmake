# Copyright (C) Troy Straszheim
#
# Distributed under the Boost Software License, Version 1.0. 
# See accompanying file LICENSE_1_0.txt or copy at 
#   http://www.boost.org/LICENSE_1_0.txt 
#
# List of SOCI dependncies
set(SOCI_BACKENDS_ALL_DEPENDENCIES
  Boost
  Oracle
  PostgreSQL
  SQLite3)

#
# Perform checks
# 
message(STATUS "")
colormsg(_HIBLUE_ "Looking for SOCI dependencies:")

macro(boost_external_report NAME)

  set(VARNAME ${NAME})
  set(SUCCESS ${${VARNAME}_FOUND})

  set(VARNAMES ${ARGV})
  list(REMOVE_AT VARNAMES 0)

  if(NOT SUCCESS) 
    string(TOUPPER ${NAME} VARNAME)
    set(SUCCESS ${${VARNAME}_FOUND})
    if(NOT SUCCESS)
      message(STATUS "${NAME} not found, some libraries or features will be disabled.")
      message(STATUS "See the documentation for ${NAME} or manually set these variables:")
    endif()
  endif()

  foreach(variable ${VARNAMES})
    boost_report_value(${VARNAME}_${variable})
  endforeach()
endmacro()

#
#  Some externals default to OFF
#
option(WITH_VALGRIND "Run tests under valgrind" OFF)

#
# Detect available dependencies
#
foreach(external ${SOCI_BACKENDS_ALL_DEPENDENCIES})

  message(STATUS "")
  string(TOUPPER "${external}" EXTERNAL)
  option(WITH_${EXTERNAL} "Attempt to find and configure ${external}" ON)
  if(WITH_${EXTERNAL})
    colormsg(HICYAN "${external}:")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/dependencies/${external}.cmake)
  else()
    set(${EXTERNAL}_FOUND FALSE CACHE BOOL "${external} found" FORCE)
    colormsg(HIRED "${external}:" RED "disabled, since WITH_${EXTERNAL}=OFF")
  endif()
endforeach()
message(STATUS "")