add_executable(test_greet test_greet.cpp)
target_link_libraries(test_greet PRIVATE greet doctest::doctest)
add_test(NAME greet COMMAND test_greet)
