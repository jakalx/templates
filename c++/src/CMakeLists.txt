add_library(greet example/greet.cpp)
target_include_directories(greet PUBLIC .)
target_link_libraries(greet PUBLIC project_settings)
set_target_properties(greet PROPERTIES PUBLIC_HEADER example/greet.hpp)
