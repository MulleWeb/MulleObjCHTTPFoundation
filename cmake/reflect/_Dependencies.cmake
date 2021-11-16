# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: BB851E0A-3CD2-4E83-B76D-87124F74F3E4;mulle-http;no-all-load,no-cmake-inherit,no-cmake-searchpath,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-http no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-http no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_HTTP_LIBRARY)
   find_library( MULLE_HTTP_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-http${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-http NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_HTTP_LIBRARY is ${MULLE_HTTP_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_HTTP_LIBRARY)
      #
      # Add MULLE_HTTP_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-http no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_HTTP_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # intentionally left blank
   else()
      # Disable with: `mulle-sourcetree mark mulle-http no-require-link`
      message( FATAL_ERROR "MULLE_HTTP_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: E98016C0-6BAC-41FC-A2B9-7376631179F8;MulleObjCInetFoundation;no-singlephase;
# Disable with : `mulle-sourcetree mark MulleObjCInetFoundation no-link`
# Disable for this platform: `mulle-sourcetree mark MulleObjCInetFoundation no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_OBJC_INET_FOUNDATION_LIBRARY)
   find_library( MULLE_OBJC_INET_FOUNDATION_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjCInetFoundation${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjCInetFoundation NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_INET_FOUNDATION_LIBRARY is ${MULLE_OBJC_INET_FOUNDATION_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_INET_FOUNDATION_LIBRARY)
      #
      # Add MULLE_OBJC_INET_FOUNDATION_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark MulleObjCInetFoundation no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_INET_FOUNDATION_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark MulleObjCInetFoundation no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_INET_FOUNDATION_ROOT "${MULLE_OBJC_INET_FOUNDATION_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_INET_FOUNDATION_ROOT "${_TMP_MULLE_OBJC_INET_FOUNDATION_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark MulleObjCInetFoundation no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_INET_FOUNDATION_NAME "MulleObjCInetFoundation")
         set( _TMP_MULLE_OBJC_INET_FOUNDATION_DIR "${_TMP_MULLE_OBJC_INET_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_INET_FOUNDATION_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_INET_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_INET_FOUNDATION_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_INET_FOUNDATION_DIR}")
            #
            include( "${_TMP_MULLE_OBJC_INET_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_INET_FOUNDATION_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_INET_FOUNDATION_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_INET_FOUNDATION_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark MulleObjCInetFoundation no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_INET_FOUNDATION_NAME "MulleObjCInetFoundation")
            set( _TMP_MULLE_OBJC_INET_FOUNDATION_FILE "${_TMP_MULLE_OBJC_INET_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_INET_FOUNDATION_NAME}/MulleObjCLoader+${_TMP_MULLE_OBJC_INET_FOUNDATION_NAME}.h")
            if( EXISTS "${_TMP_MULLE_OBJC_INET_FOUNDATION_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_INET_FOUNDATION_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark MulleObjCInetFoundation no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_INET_FOUNDATION_LIBRARY was not found")
   endif()
endif()
