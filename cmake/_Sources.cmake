#
# cmake/_Sources.cmake is generated by `mulle-sde`. Edits will be lost.
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

set( SOURCES
src/MulleObjCInetFoundation.m
src/NSHost.m
src/NSString+HTML.m
src/NSURL+File.m
src/NSURL+HTTP.m
src/NSURL.m
src/http_parser.c
)

set( STAGE2_SOURCES
src/MulleObjCLoader+MulleObjCInetFoundation.m
)
