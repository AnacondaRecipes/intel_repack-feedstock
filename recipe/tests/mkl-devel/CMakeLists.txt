cmake_minimum_required(VERSION 3.13)

project(mkl_example LANGUAGES C)

set(MKL_THREADING "intel_thread")

# If any MKL component (even libiomp) is missing
# cmake will error out. So REQUIRED is important for the test.
find_package(MKL CONFIG REQUIRED)
message(STATUS "${MKL_IMPORTED_TARGETS}") #Provides available list of targets based on input

add_executable(myapp app.c)

target_compile_options(myapp PUBLIC $<TARGET_PROPERTY:MKL::MKL,INTERFACE_COMPILE_OPTIONS>)
if (WIN32)
    # https://www.intel.com/content/www/us/en/docs/cpp-compiler/developer-guide-reference/2021-8/use-the-openmp-libraries.html#id-d42745e610
    target_compile_options(myapp PUBLIC "/openmp")
    target_link_options(myapp PUBLIC "/nodefaultlib:vcomp")
else()
    target_compile_options(myapp PUBLIC "-fopenmp")
endif()
target_include_directories(myapp PUBLIC $<TARGET_PROPERTY:MKL::MKL,INTERFACE_INCLUDE_DIRECTORIES>)
target_link_libraries(myapp PUBLIC $<LINK_ONLY:MKL::MKL>)
