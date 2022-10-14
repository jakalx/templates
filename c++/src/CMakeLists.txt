add_library(greet example/greet.cpp)
target_include_directories(greet PUBLIC .)
set_target_properties(greet PROPERTIES PUBLIC_HEADER example/greet.hpp)
