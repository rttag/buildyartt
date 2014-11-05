file(TO_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" EQUALIZER_ROOT)
#######################################################################################################################
# collage
#######################################################################################################################
set(COLLAGE_LIBRARY_BASE "${EQUALIZER_ROOT}/lib")
set(COLLAGE_BINARY_BASE "${EQUALIZER_ROOT}/bin")
set(COLLAGE_INCLUDE_DIR ${EQUALIZER_ROOT}/include CACHE STRING "Collage library - include directory")

find_library(COLLAGE_LIBRARY_DEBUG Collage PATHS "${COLLAGE_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(COLLAGE_LIBRARY_RELEASE Collage PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)
find_library(LUNCHBOX_LIBRARY_DEBUG Lunchbox PATHS "${COLLAGE_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(LUNCHBOX_LIBRARY_RELEASE Lunchbox PATHS "${COLLAGE_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)


# prepare the settings
set(COLLAGE_LIBRARY	debug ${COLLAGE_LIBRARY_DEBUG}	optimized ${COLLAGE_LIBRARY_RELEASE} CACHE STRING "Collage library" )

set(LUNCHBOX_LIBRARY debug ${LUNCHBOX_LIBRARY_DEBUG} optimized ${LUNCHBOX_LIBRARY_RELEASE} CACHE STRING "Lunchbox library" )

# check if we found the library
if(NOT COLLAGE_LIBRARY)
	message(FATAL " no appropriate Collage library found in ${COLLAGE_LIBRARY_BASE}")
endif()

if(NOT LUNCHBOX_LIBRARY)
	message(FATAL " no appropriate Lunchbox library found in ${COLLAGE_LIBRARY_BASE}")
endif()

# prepare the settings
set(COLLAGE_LIBRARY debug ${COLLAGE_LIBRARY_DEBUG} optimized ${COLLAGE_LIBRARY_RELEASE} CACHE STRING "Collage library")

mark_as_advanced(COLLAGE_LIBRARY_DEBUG COLLAGE_LIBRARY_RELEASE LUNCHBOX_LIBRARY_DEBUG LUNCHBOX_LIBRARY_RELEASE )

set(COLLAGE_LOCATION
	debug ${COLLAGE_BINARY_BASE}/Debug/Collage.dll
	debug ${COLLAGE_BINARY_BASE}/Debug/Collage.pdb
	debug ${COLLAGE_BINARY_BASE}/Debug/Lunchbox.dll
	debug ${COLLAGE_BINARY_BASE}/Debug/Lunchbox.pdb
	debug ${COLLAGE_BINARY_BASE}/Debug/pthread.dll
	debug ${COLLAGE_BINARY_BASE}/Debug/coNetperf.exe
	debug ${COLLAGE_BINARY_BASE}/Debug/coNetperf.pdb
	debug ${COLLAGE_BINARY_BASE}/Debug/affinityCheck.exe
	debug ${COLLAGE_BINARY_BASE}/Debug/affinityCheck.pdb
	optimized ${COLLAGE_BINARY_BASE}/Release/Collage.dll
	optimized ${COLLAGE_BINARY_BASE}/Release/Collage.pdb
	optimized ${COLLAGE_BINARY_BASE}/Release/Lunchbox.dll
	optimized ${COLLAGE_BINARY_BASE}/Release/Lunchbox.pdb
	optimized ${COLLAGE_BINARY_BASE}/Release/pthread.dll
	optimized ${COLLAGE_BINARY_BASE}/Release/coNetperf.exe
	optimized ${COLLAGE_BINARY_BASE}/Release/coNetperf.pdb
	optimized ${COLLAGE_BINARY_BASE}/Release/affinityCheck.exe
	optimized ${COLLAGE_BINARY_BASE}/Release/affinityCheck.pdb
)

__rtt_system_library(collage
	IMPLIB
		${COLLAGE_LIBRARY}
		${LUNCHBOX_LIBRARY}

	LOCATION
		${COLLAGE_LOCATION}

	INCLUDES
		${COLLAGE_INCLUDE_DIR}
  
	DEPENDS
		boost
		boost-system
		boost-date_time
		boost-serialization
		boost-regex
		boost-program_options
		boost-math
		boost-filesystem
		boost-signals
		boost-thread
		boost-iostreams
)

#######################################################################################################################
# equalizer
#######################################################################################################################
set(EQUALIZER_LIBRARY_BASE "${EQUALIZER_ROOT}/lib")
set(EQUALIZER_BINARY_BASE "${EQUALIZER_ROOT}/bin")

find_library(EQUALIZER_LIBRARY_DEBUG Equalizer PATHS "${EQUALIZER_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZER_LIBRARY_RELEASE Equalizer PATHS "${EQUALIZER_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERADMIN_LIBRARY_DEBUG EqualizerAdmin PATHS "${EQUALIZER_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERADMIN_LIBRARY_RELEASE EqualizerAdmin PATHS "${EQUALIZER_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERSERVER_LIBRARY_DEBUG EqualizerServer PATHS "${EQUALIZER_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERSERVER_LIBRARY_RELEASE EqualizerServer PATHS "${EQUALIZER_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERFABRIC_LIBRARY_DEBUG EqualizerFabric PATHS "${EQUALIZER_LIBRARY_BASE}/Debug" NO_CMAKE_SYSTEM_PATH)
find_library(EQUALIZERFABRIC_LIBRARY_RELEASE EqualizerFabric PATHS "${EQUALIZER_LIBRARY_BASE}/Release" NO_CMAKE_SYSTEM_PATH)

# prepare the settings
set(EQUALIZER_LIBRARY
	debug ${EQUALIZER_LIBRARY_DEBUG}
	optimized ${EQUALIZER_LIBRARY_RELEASE}
	debug ${EQUALIZERSERVER_LIBRARY_DEBUG}
	optimized ${EQUALIZERSERVER_LIBRARY_RELEASE}
	debug ${EQUALIZERADMIN_LIBRARY_DEBUG}
	optimized ${EQUALIZERADMIN_LIBRARY_RELEASE}
	debug ${EQUALIZERFABRIC_LIBRARY_DEBUG}
	optimized ${EQUALIZERFABRIC_LIBRARY_RELEASE}
	CACHE STRING "Equalizer library"
)

# prepare the settings
set(EQUALIZER_LIBRARY debug ${EQUALIZER_LIBRARY_DEBUG} optimized ${EQUALIZER_LIBRARY_RELEASE} CACHE STRING "Equalizer library")
		

# check if we found the library
if(NOT EQUALIZER_LIBRARY)
	message(FATAL " no appropriate Equalizer library found in ${EQUALIZER_LIBRARY_BASE}")
endif()

# prepare the settings
set(EQUALIZER_INCLUDE_DIR ${EQUALIZER_ROOT}/include CACHE STRING "Equalizer library - include directory")

mark_as_advanced(EQUALIZER_LIBRARY_DEBUG 
	EQUALIZER_LIBRARY_RELEASE
	EQUALIZERADMIN_LIBRARY_DEBUG 
	EQUALIZERADMIN_LIBRARY_RELEASE
	EQUALIZERSERVER_LIBRARY_DEBUG 
	EQUALIZERSERVER_LIBRARY_RELEASE
	EQUALIZERFABRIC_LIBRARY_DEBUG
	EQUALIZERFABRIC_LIBRARY_RELEASE
)
#######################################################################################################################
# equalizer
#######################################################################################################################
set(EQUALIZER_LOCATION
	debug ${EQUALIZER_BINARY_BASE}/Debug/EqualizerServer.dll
	optimized ${EQUALIZER_BINARY_BASE}/Release/EqualizerServer.dll
	debug ${EQUALIZER_BINARY_BASE}/Debug/EqualizerAdmin.dll
	optimized ${EQUALIZER_BINARY_BASE}/Release/EqualizerAdmin.dll
	debug ${EQUALIZER_BINARY_BASE}/Debug/Equalizer.dll
	optimized ${EQUALIZER_BINARY_BASE}/Release/Equalizer.dll
	debug ${EQUALIZER_BINARY_BASE}/Debug/EqualizerFabric.dll
	optimized ${EQUALIZER_BINARY_BASE}/Release/EqualizerFabric.dll
	debug ${EQUALIZER_BINARY_BASE}/Debug/pthread.dll
	optimized ${EQUALIZER_BINARY_BASE}/Release/pthread.dll
)

__rtt_system_library(equalizer
	IMPLIB
		${EQUALIZER_LIBRARY}

	LOCATION
		${EQUALIZER_LOCATION}

	INCLUDES
		${EQUALIZER_INCLUDE_DIR}
        
	DEPENDS
		collage
)

