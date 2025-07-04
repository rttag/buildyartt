project(buildyartt)
cmake_minimum_required(VERSION 3.21)

#allow reading the LOCATION properties from build-targets
CMAKE_POLICY (SET CMP0026 OLD)

find_package(PythonInterp 2.6 REQUIRED)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
SET(ARTIFACTORY_REPOSITORY "https://eu-muc-art01.ux.dsone.3ds.com/artifactory")
 
include("rtt")
include(ExternalProject)

__RTT_ARTIFACTORY_GET(boost) 

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG")

if (MSVC)
set(OFED_SDK_DIR "D:/_SDK/OFED_SDK" CACHE PATH "Location of OFED_SDK for RDMA - optional")
set(CMAKE_CONFIGURATION_TYPES "Debug;RelWithDebInfo;Release" CACHE PATH "configuration types for vs" FORCE)
add_definitions(-D_SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS -D_TIMESPEC_DEFINED -wd4091)
	
endif()
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/__install" CACHE PATH "install dir" FORCE)

add_custom_target(CLEAN_VMMLIB COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/vmmlib/__build 
								COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/vmmlib/__build )
add_custom_target(CLEAN_LUNCHBOX COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/Lunchbox/__build 
								COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/Lunchbox/__build DEPENDS CLEAN_VMMLIB )
add_custom_target(CLEAN_GLSTATS COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/GLStats/__build 
								COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/GLStats/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_COLLAGE COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/Collage/__build 
								COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/Collage/__build DEPENDS CLEAN_LUNCHBOX )
add_custom_target(CLEAN_EQUALIZER ALL COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/Equalizer/__build 
									COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/Equalizer/__build DEPENDS CLEAN_COLLAGE CLEAN_GLSTATS )
add_custom_target(CLEAN_TEMP_INSTALL ALL COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/__install DEPENDS CLEAN_EQUALIZER )

ExternalProject_Add(vmmlib
SOURCE_DIR ${CMAKE_SOURCE_DIR}/vmmlib
BINARY_DIR ${CMAKE_SOURCE_DIR}/vmmlib/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
-DVMMLIB_USE_BLAS=OFF
)

ExternalProject_Add_Step(vmmlib forceconfigure
COMMAND ${CMAKE_COMMAND} -E echo "Force configure of vmmlib"
DEPENDEES update
DEPENDERS configure
ALWAYS 1)

if (MSVC)
	ExternalProject_Add(Lunchbox
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Lunchbox
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Lunchbox/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
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
	-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	)
endif()

ExternalProject_Add_Step(Lunchbox forceconfigure
COMMAND ${CMAKE_COMMAND} -E echo "Force configure of Lunchbox"
DEPENDEES update
DEPENDERS configure
ALWAYS 1)

if(IS_DIRECTORY ${OFED_SDK_DIR})
	ExternalProject_Add(Collage
	SOURCE_DIR ${CMAKE_SOURCE_DIR}/Collage
	BINARY_DIR ${CMAKE_SOURCE_DIR}/Collage/__build
	INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
	CMAKE_ARGS 
	-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
	-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
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
	-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
	-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
	-DCOLLAGE_AGGRESSIVE_CACHING=OFF
	-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
	)
endif()


ExternalProject_Add_Step(Collage forceconfigure
COMMAND ${CMAKE_COMMAND} -E echo "Force configure of Collage"
DEPENDEES update
DEPENDERS configure
ALWAYS 1)

ExternalProject_Add(GLStats
SOURCE_DIR ${CMAKE_SOURCE_DIR}/GLStats
BINARY_DIR ${CMAKE_SOURCE_DIR}/GLStats/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS 
-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
)

ExternalProject_Add_Step(GLStats forceconfigure
COMMAND ${CMAKE_COMMAND} -E echo "Force configure of GLStats"
DEPENDEES update
DEPENDERS configure
ALWAYS 1)

ExternalProject_Add(Equalizer
SOURCE_DIR ${CMAKE_SOURCE_DIR}/Equalizer
BINARY_DIR ${CMAKE_SOURCE_DIR}/Equalizer/__build
INSTALL_DIR ${CMAKE_SOURCE_DIR}/__install
CMAKE_ARGS 
-DLunchbox_DIR=${CMAKE_SOURCE_DIR}/__install/Lunchbox/CMake
-DCMAKE_INSTALL_PREFIX:string=${CMAKE_CURRENT_BINARY_DIR}/__install
-DCMAKE_BUILD_TYPE:string=${CMAKE_BUILD_TYPE}
-DBOOST_ROOT:string=${ARTIFACT_boost_ROOT}
-DPYTHON_EXECUTABLE:string=${PYTHON_EXECUTABLE}
-DEQUALIZER_BUILD_EXAMPLES=OFF
-DEQUALIZER_INSTALL_SERVER_HEADERS=ON
-DEQUALIZER_USE_CUDA=OFF
-DEQUALIZER_USE_MAGELLAN=OFF
-DEQUALIZER_USE_OSG=OFF
-DEQUALIZER_USE_SAGE=OFF
)

ExternalProject_Add_Step(Equalizer forceconfigure
COMMAND ${CMAKE_COMMAND} -E echo "Force configure of Equalizer"
DEPENDEES update
DEPENDERS configure
ALWAYS 1)
	
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
#install(FILES ${binfiles} DESTINATION bin/RelWithDebInfo/ CONFIGURATIONS RelWithDebInfo COMPONENT bin)
#install(FILES ${binfiles} DESTINATION bin/Debug/ CONFIGURATIONS Debug COMPONENT bin)
#install(FILES ${libfiles} DESTINATION lib/RelWithDebInfo/ CONFIGURATIONS RelWithDebInfo COMPONENT lib)
#install(FILES ${libfiles} DESTINATION lib/Debug/ CONFIGURATIONS Debug COMPONENT lib)
