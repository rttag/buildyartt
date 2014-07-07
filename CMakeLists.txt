project(buildyartt)
cmake_minimum_required(VERSION 2.8)

find_package(PythonInterp 2.6 REQUIRED)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
set(ARTIFACTORY_REPOSITORY "https://artifactory.rtt.local/artifactory")
 
include("rtt")
include(ExternalProject)

__RTT_ARTIFACTORY_GET(boost) 

if (MSVC)
set(OFED_SDK_DIR "D:/_SDK/OFED_SDK" CACHE PATH "Location of OFED_SDK for RDMA - optional")
set(CMAKE_CONFIGURATION_TYPES "Debug;RelWithDebInfo" CACHE PATH "configuration types for vs" FORCE)
endif()
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/__install" CACHE PATH "install dir" FORCE)

if (MSVC)
add_custom_target(CLEAN_VMMLIB rd /S /Q ${CMAKE_SOURCE_DIR}/vmmlib/__build )
add_custom_target(CLEAN_LUNCHBOX rd /S /Q ${CMAKE_SOURCE_DIR}/Lunchbox/__build DEPENDS CLEAN_VMMLIB )
add_custom_target(CLEAN_GLSTATS rd /S /Q ${CMAKE_SOURCE_DIR}/GLStats/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_COLLAGE rd /S /Q ${CMAKE_SOURCE_DIR}/Collage/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_EQUALIZER ALL rd /S /Q ${CMAKE_SOURCE_DIR}/Equalizer/__build DEPENDS CLEAN_COLLAGE CLEAN_GLSTATS )
add_custom_target(CLEAN_TEMP_INSTALL ALL rd /S /Q ${CMAKE_CURRENT_BINARY_DIR}/__install DEPENDS CLEAN_EQUALIZER )
else()
add_custom_target(CLEAN_VMMLIB rm -rf ${CMAKE_SOURCE_DIR}/vmmlib/__build )
add_custom_target(CLEAN_LUNCHBOX rm -rf ${CMAKE_SOURCE_DIR}/Lunchbox/__build DEPENDS CLEAN_VMMLIB )
add_custom_target(CLEAN_GLSTATS rm -rf ${CMAKE_SOURCE_DIR}/GLStats/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_COLLAGE rm -rf ${CMAKE_SOURCE_DIR}/Collage/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_EQUALIZER ALL rm -rf ${CMAKE_SOURCE_DIR}/Equalizer/__build DEPENDS CLEAN_COLLAGE CLEAN_GLSTATS )
add_custom_target(CLEAN_TEMP_INSTALL ALL rm -rf ${CMAKE_CURRENT_BINARY_DIR}/__install DEPENDS CLEAN_EQUALIZER )
endif()

ExternalProject_Add(vmmlib
SOURCE_DIR ${CMAKE_SOURCE_DIR}/vmmlib
BINARY_DIR ${CMAKE_SOURCE_DIR}/vmmlib/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
#-DCMAKE_CONFIGURATION_TYPES:string=${CMAKE_CONFIGURATION_TYPES}
-DVMMLIB_USE_BLAS=OFF
)
if (MSVC)
	ExternalProject_Add(Lunchbox
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Lunchbox
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Lunchbox/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	-DLUNCHBOX_USE_OPENMP=OFF 
	)
else()
	ExternalProject_Add(Lunchbox
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Lunchbox
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Lunchbox/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	)
endif()

if(IS_DIRECTORY ${OFED_SDK_DIR})
	ExternalProject_Add(Collage
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Collage
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Collage/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	-DCOLLAGE_AGGRESSIVE_CACHING=OFF
	-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
	-D_ibverbs_LIBRARY=${OFED_SDK_DIR}/lib/libibverbs.lib 
	-D_rdma_LIBRARY=${OFED_SDK_DIR}/lib/librdmacm.lib 
	-D_ofed_INCLUDE_DIR=${OFED_SDK_DIR}/Inc
	)
else()
	ExternalProject_Add(Collage
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Collage
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Collage/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	-DCOLLAGE_AGGRESSIVE_CACHING=OFF
	-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
	)
endif()

ExternalProject_Add(GLStats
SOURCE_DIR ${CMAKE_SOURCE_DIR}/GLStats
BINARY_DIR ${CMAKE_SOURCE_DIR}/GLStats/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS 
-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
)

ExternalProject_Add(Equalizer
SOURCE_DIR ${CMAKE_SOURCE_DIR}/Equalizer
BINARY_DIR ${CMAKE_SOURCE_DIR}/Equalizer/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS 
-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
-DEQUALIZER_BUILD_EXAMPLES=OFF
-DEQUALIZER_INSTALL_SERVER_HEADERS=ON
-DEQUALIZER_USE_CUDA=OFF
-DEQUALIZER_USE_MAGELLAN=OFF
-DEQUALIZER_USE_OSG=OFF
-DEQUALIZER_USE_SAGE=OFF
)
	
add_dependencies(vmmlib CLEAN_TEMP_INSTALL)
add_dependencies(Lunchbox vmmlib)
add_dependencies(Collage Lunchbox)
add_dependencies(GLStats Lunchbox)
add_dependencies(Equalizer GLStats)
add_dependencies(Equalizer Collage)

file(GLOB binfiles RELATIVE ${CMAKE_CURRENT_BINARY_DIR}/ ${CMAKE_CURRENT_BINARY_DIR}/__install/bin/*)
file(GLOB libfiles RELATIVE ${CMAKE_CURRENT_BINARY_DIR}/ ${CMAKE_CURRENT_BINARY_DIR}/__install/lib/*)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/__install/include/co DESTINATION include COMPONENT dev)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/__install/include/eq DESTINATION include COMPONENT dev)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/__install/include/lunchbox DESTINATION include COMPONENT dev)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/__install/include/vmmlib DESTINATION include COMPONENT dev)
install(FILES ${binfiles} DESTINATION bin/RelWithDebInfo/ CONFIGURATIONS RelWithDebInfo COMPONENT bin)
install(FILES ${binfiles} DESTINATION bin/Debug/ CONFIGURATIONS Debug COMPONENT bin)
install(FILES ${libfiles} DESTINATION lib/RelWithDebInfo/ CONFIGURATIONS RelWithDebInfo COMPONENT lib)
install(FILES ${libfiles} DESTINATION lib/Debug/ CONFIGURATIONS Debug COMPONENT lib)
