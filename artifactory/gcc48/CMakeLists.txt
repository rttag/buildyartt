#
# Find the Collage library.
#
# Input:
#
# Output:  COLLAGE_LIBRARY
#          COLLAGE_INCLUDE_DIR
#
 
file(TO_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" EQUALIZER_ROOT)
 
SET(LUNCHBOX_REQUIRED ON)
mark_as_advanced(LUNCHBOX_REQUIRED)
 
#if(NOT COLLAGE_LIBRARY)
    set(COLLAGE_INCLUDE_DIR ${EQUALIZER_ROOT}/include CACHE STRING "Collage library - include directory")
    set(COLLAGE_LIBRARY_BASE "${EQUALIZER_ROOT}/lib")

    find_library(COLLAGE_LIBRARY_RELEASE Collage
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

    find_library(LUNCHBOX_LIBRARY_RELEASE Lunchbox
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)
 
    find_library(EQUALIZER_LIBRARY_RELEASE Equalizer
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

    find_library(EQUALIZERADMIN_LIBRARY_RELEASE EqualizerAdmin
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

    find_library(EQUALIZERSERVER_LIBRARY_RELEASE EqualizerServer
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

    find_library(EQUALIZERFABRIC_LIBRARY_RELEASE EqualizerFabric
	PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

    # prepare the settings
    set(COLLAGE_LIBRARY
        ${COLLAGE_LIBRARY_RELEASE}
        CACHE STRING "Collage library"
    )
 
    if (LUNCHBOX_REQUIRED)
        set(LUNCHBOX_LIBRARY
            ${LUNCHBOX_LIBRARY_RELEASE}
            CACHE STRING "Lunchbox library"
        )
    endif()
 
    set(EQUALIZER_LIBRARY
        ${EQUALIZER_LIBRARY_RELEASE}
	${EQUALIZERADMIN_LIBRARY_RELEASE}
	${EQUALIZERSERVER_LIBRARY_RELEASE}
	${EQUALIZERFABRIC_LIBRARY_RELEASE}
        CACHE STRING "Equalizer library"
    )

    # check if we found the library
    if(NOT COLLAGE_LIBRARY)
        message(FATAL_ERROR " no appropriate Collage library found in ${COLLAGE_LIBRARY_BASE}")
    endif()
 
    if((NOT LUNCHBOX_LIBRARY) AND (LUNCHBOX_REQUIRED))
        message(FATAL_ERROR " no appropriate Lunchbox library found in ${COLLAGE_LIBRARY_BASE}")
    endif()

    if(NOT EQUALIZER_LIBRARY)
        message(FATAL_ERROR " no appropriate Equalizer library found in ${COLLAGE_LIBRARY_BASE}")
    endif()
 
    mark_as_advanced(
                     COLLAGE_LIBRARY_RELEASE
                     LUNCHBOX_LIBRARY_RELEASE
		     EQUALIZER_LIBRARY_RELEASE
        )
#endif()
 
    __rtt_system_library(collage
        IMPLIB
            ${COLLAGE_LIBRARY}
            ${LUNCHBOX_LIBRARY}
 
        LOCATION
            ${COLLAGE_LIBRARY}
	    ${LUNCHBOX_LIBRARY}
 
        INCLUDES
            ${COLLAGE_INCLUDE_DIR}

      DEPENDS
        boost-system
        boost-date_time
        boost-serialization
        boost-regex
        boost-program_options
    )

    __rtt_system_library(equalizer
        IMPLIB
            ${EQUALIZER_LIBRARY}
 
        LOCATION
            ${EQUALIZER_LIBRARY}
 
        INCLUDES
            ${COLLAGE_INCLUDE_DIR}

      DEPENDS
      collage
      boost-system
      boost-date_time
      boost-serialization
      boost-regex
      boost-program_options
    )

