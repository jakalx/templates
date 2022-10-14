#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest/doctest.h>

#include <example/greet.hpp>

TEST_CASE("greet") {
        CHECK(example::greet("World") == "Hello World!");
}
