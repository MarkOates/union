# see this SO for techniques in using a separate file to define variables
# https://unix.stackexchange.com/questions/235223/makefile-include-env-file


PROJECT_BASE_DIRECTORY := $$PWD
FOCUSED_COMPONENT_FILENAME=/Users/markoates/Repos/hexagon/bin/programs/data/tmp/focused_component.txt
FOCUSED_COMPONENT_NAME=`cat ${FOCUSED_COMPONENT_FILENAME}`
FOCUSED_TEST_FILTER=${FILTER}


ifeq ($(OS),Windows_NT)
else
	UNUSED_ARGUMENTS_FLAG=-Qunused-arguments
endif



PROJECT_NAME=mylibrary
VERSION_NUMBER=0.0.1
LIBS_ROOT=/Users/markoates/Repos
## This is a temporary hack to have union/Makefile build with allegro_flare
ifeq ($(OS),Windows_NT)
	ASIO_LIBS_ROOT=/home/Mark/Repos
else
	ASIO_LIBS_ROOT=$(LIBS_ROOT)
endif
#ALLEGRO_INCLUDE_DIR=$(LIBS_ROOT)/allegro5/build/include
#ALLEGRO_LIB_DIR=$(LIBS_ROOT)/allegro5/build/lib
ALLEGRO_INCLUDE_DIR=.
ALLEGRO_LIB_DIR=.
ASIO_INCLUDE_DIR=$(ASIO_LIBS_ROOT)/asio/asio/include
GOOGLE_TEST_DIR=$(LIBS_ROOT)/googletest
GOOGLE_TEST_LIB_DIR=$(GOOGLE_TEST_DIR)/build/googlemock/gtest
GOOGLE_TEST_INCLUDE_DIR=$(GOOGLE_TEST_DIR)/googletest/include
GOOGLE_MOCK_INCLUDE_DIR=$(GOOGLE_TEST_DIR)/googlemock/include
ifeq ($(OS),Windows_NT)
	NCURSES_INCLUDE_DIR=/usr/include
	NCURSES_LIB_DIR=.
else
	NCURSES_INCLUDE_DIR=/usr/local/opt/ncurses/include
	NCURSES_LIB_DIR=/usr/local/opt/ncurses/lib
endif
YAML_CPP_DIR=$(LIBS_ROOT)/yaml-cpp
YAML_CPP_LIB_DIR=$(YAML_CPP_DIR)/build
YAML_CPP_INCLUDE_DIR=$(YAML_CPP_DIR)/include



QUINTESSENCE_BUILDER_EXECUTABLE=~/Repos/blast/bin/programs/quintessence_from_yaml
OUTPUT_BANNER_EXECUTABLE=~/Repos/blast/bin/programs/build_celebrator


ALLEGRO_LIBS=allegro_color allegro_font allegro_ttf allegro_dialog allegro_audio allegro_acodec allegro_primitives allegro_image allegro
ALLEGRO_LIBS_MAIN=$(ALLEGRO_LIBS) allegro_main
GOOGLE_TEST_LIBS=gtest
GOOGLE_MOCK_LIBS=gmock
NCURSES_LIB=ncurses
YAML_CPP_LIBS=yaml-cpp
ifeq ($(OS), Windows_NT)
	OPENGL_LIB=-lopengl32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OPENGL_LIB=[ERROR:OPENGL_LIBS_NOT_DEFINED_FOR_LINUX]
	endif
	ifeq ($(UNAME_S),Darwin)
		OPENGL_LIB=-framework OpenGL
	endif
endif



SOURCES := $(shell find src -name '*.cpp')
QUINTESSENCE_SOURCES := $(shell find quintessence -name '*.q.yml')
PROGRAM_SOURCES := $(shell find programs -name '*.cpp')
EXAMPLE_SOURCES := $(shell find examples -name '*.cpp')
TEST_SOURCES := $(shell find tests -name '*Test.cpp')
OBJECTS := $(SOURCES:src/%.cpp=obj/%.o)
PROGRAMS := $(PROGRAM_SOURCES:programs/%.cpp=bin/programs/%)
EXAMPLES := $(EXAMPLE_SOURCES:examples/%.cpp=bin/examples/%)
TEST_OBJECTS := $(TEST_SOURCES:tests/%.cpp=obj/tests/%.o)
LIBRARY_NAME := lib/lib$(PROJECT_NAME)-$(VERSION_NUMBER).a
INDIVIDUAL_TEST_EXECUTABLES := $(TEST_SOURCES:tests/%.cpp=bin/tests/%)
ifeq ($(OS),Windows_NT)
	ALL_COMPILED_EXECUTABLES_IN_BIN := $(shell find bin/**/* -perm /111 -type f)
else
	ALL_COMPILED_EXECUTABLES_IN_BIN := $(shell find bin/**/* -perm +111 -type f)
endif



ALLEGRO_LIBS_LINK_ARGS := $(ALLEGRO_LIBS:%=-l%)
ALLEGRO_LIBS_LINK_MAIN_ARGS := $(ALLEGRO_LIBS_MAIN:%=-l%)
ifeq ($(OS),Windows_NT)
	REQUIRED_WINDOWS_NETWORK_FLAGS=-lwsock32 -lws2_32
endif



TERMINAL_COLOR_YELLOW=\033[1;33m
TERMINAL_COLOR_RED=\033[1;31m
TERMINAL_COLOR_GREEN=\033[1;32m
TERMINAL_COLOR_BLUE=\033[1;34m
TERMINAL_COLOR_LIGHT_BLUE=\033[1;94m
TERMINAL_COLOR_RESET=\033[0m



define output_terminal_message
	$(eval compteur=$(shell echo $$(($(compteur)+1))))
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c yellow -l $(columns) -m Stage ${compteur}: ${1}
	@echo
endef



.PHONY: main quintessence programs objects examples library tests run_tests



main:
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@make quintessences -j8
	$(call output_terminal_message,"Make all the component object files")
	@make objects -j8
	$(call output_terminal_message,"Make all the test object files")
	@make test_objects -j8
	$(call output_terminal_message,"Make all the individual test executables")
	@make tests -j8
	$(call output_terminal_message,"Make single test executable containing all tests")
	@make all_tests -j8
	$(call output_terminal_message,"Run the tests for all the components")
	@(bin/run_all_tests && (make celebrate_passing_tests) || (make signal_failing_tests && exit 1) )
	$(call output_terminal_message,"Build the library")
	@make library -j8
	$(call output_terminal_message,"Make all the programs")
	@make programs -j8
	$(call output_terminal_message,"Make all the example programs")
	@make examples -j8
	$(call output_terminal_message,"Celebrate successful build")
	@make celebrate_everything_built



focus:
	$(call output_terminal_message,"Announce focus build info")
	@echo "                    Project: $(PROJECT_BASE_DIRECTORY)"
	@echo "Focusing build on component: \033[48;5;27m$(FOCUSED_COMPONENT_NAME)$(TERMINAL_COLOR_RESET)"
	@echo "          testing filter in: \033[48;5;27m$(FOCUSED_TEST_FILTER)$(TERMINAL_COLOR_RESET)"
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@make quintessences -j8
	$(call output_terminal_message,"Make all the component object files")
	@make objects
	$(call output_terminal_message, "Delete the existing focused component test object and test binary")
	@-rm obj/tests/$(FOCUSED_COMPONENT_NAME)Test.o
	@-rm bin/tests/$(FOCUSED_COMPONENT_NAME)Test
	$(call output_terminal_message,"Make the focused component test")
	@make obj/tests/$(FOCUSED_COMPONENT_NAME)Test.o
	@make bin/tests/$(FOCUSED_COMPONENT_NAME)Test
	$(call output_terminal_message,"Run the focused component test")
	@(./bin/tests/$(FOCUSED_COMPONENT_NAME)Test --gtest_filter=*$(FOCUSED_TEST_NAME)* && (make celebrate_passing_tests) || (make signal_failing_tests && exit 1) )
	$(call output_terminal_message,"Make all the programs")
	@make programs -j8
	$(call output_terminal_message,"Celebrate integrated component tests")
	@make celebrate_built_component



quintessences: $(QUINTESSENCE_SOURCES)
	@[ -f $(QUINTESSENCE_BUILDER_EXECUTABLE) ] || echo "The needed executable $(QUINTESSENCE_BUILDER_EXECUTABLE) was not found"
	@find quintessence -name '*.q.yml' | xargs $(QUINTESSENCE_BUILDER_EXECUTABLE) --less_verbose -f
	@echo "(finished)"



programs: $(PROGRAMS)



objects: $(OBJECTS)



examples: $(EXAMPLES)



library: $(LIBRARY_NAME)



test_objects: $(TEST_OBJECTS)



tests: $(INDIVIDUAL_TEST_EXECUTABLES)



all_tests: bin/run_all_tests



celebrate_passing_tests:
	$(eval columns=$(shell tput cols))
	$(eval banner_width=103)
	$(eval hcolumns=$(shell expr $(columns) / 2 - $(banner_width) / 2))
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫   █▀▀▄  █▀▀█  █▀▀  █▀▀  🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫   █▄▄▀  █▄▄█  ▀▀█  ▀▀█  🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫   ▀     ▀  ▀  ▀▀▀  ▀▀▀  🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫$(TERMINAL_COLOR_RESET)"



signal_failing_tests:
	$(eval columns=$(shell tput cols))
	$(eval banner_width=103)
	$(eval hcolumns=$(shell expr $(columns) / 2 - $(banner_width) / 2))
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[31m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[31m🀫 🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫 🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[31m🀫 🀫 🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫    FAIL   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫 🀫 🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[31m🀫 🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫   🀫 🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[31m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"



celebrate_built_component:
	$(eval columns=$(shell tput cols))
	$(eval banner_width=105)
	$(eval hcolumns=$(shell expr $(columns) / 2 - $(banner_width) / 2))
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫  $(TERMINAL_COLOR_BLUE)   COMPONENT BUILT     $(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"



celebrate_everything_built:
	$(eval columns=$(shell tput cols))
	$(eval banner_width=105)
	$(eval hcolumns=$(shell expr $(columns) / 2 - $(banner_width) / 2))
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_YELLOW)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_RESET)\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_RESET)\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_YELLOW)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫        BUILT      🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_YELLOW)🀫$(TERMINAL_COLOR_RESET)\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_RESET)\033[0m"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_YELLOW)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_RESET)\033[0m"



bin/programs/%: programs/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling program \e[1m\e[36m$<\033[0m..."
	@g++ -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -l$(GOOGLE_TEST_LIBS) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS)
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



bin/examples/%: examples/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling example \e[1m\e[36m$<\033[0m..."
	@g++ -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -l$(GOOGLE_TEST_LIBS) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS)
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



obj/%.o: src/%.cpp
	@mkdir -p $(@D)
	@printf "compiling object file \e[1m\e[34m$<\033[0m..."
	@g++ -c -ferror-limit=1 -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -D_XOPEN_SOURCE_EXTENDED
	@echo "done. object at \033[1m\033[32m$@\033[0m"



$(LIBRARY_NAME): $(OBJECTS)
	@printf "compiling library \e[1m\e[36m$@\033[0m..."
ifeq ($(OBJECTS),)
	@echo "\033[1m\033[32mnothing to be done, there are no objects to build into a library\033[0m."
else
	@ar rs $(LIBRARY_NAME) $^
	@echo "done. Library file at \033[1m\033[32m$@\033[0m"
endif



obj/tests/%.o: tests/%.cpp
	@mkdir -p $(@D)
	@printf "compiling test object file \e[1m\e[36m$<\033[0m..."
	@g++ -c -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR) -I$(YAML_CPP_INCLUDE_DIR)
	@echo "done. Object at \033[1m\033[32m$@\033[0m"



obj/tests/TestRunner.o: tests/TestRunner.cpp
	@mkdir -p $(@D)
	@printf "compiling test object for TestRunner \e[1m\e[36m$<\033[0m..."
	@g++ -c -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< -o $@ -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR)
	@echo "done. Object at \033[1m\033[32m$@\033[0m"



bin/tests/%: obj/tests/%.o obj/tests/TestRunner.o
	@mkdir -p $(@D)
	@printf "compiling standalone test \e[1m\e[36m$<\033[0m..."
	@g++ -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< obj/tests/TestRunner.o -o $@ -l$(GOOGLE_MOCK_LIBS) -l$(GOOGLE_TEST_LIBS) -I./include -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR) -L$(GOOGLE_TEST_LIB_DIR) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) $(ALLEGRO_FLARE_LINK_ARGS) -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS)
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



bin/run_all_tests: $(TEST_OBJECTS) obj/tests/TestRunner.o
	@mkdir -p $(@D)
	@printf "compiling run_all_tests executable \e[1m\e[36m$@\033[0m..."
	@g++ -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(OBJECTS) $(TEST_OBJECTS) obj/tests/TestRunner.o -o $@ -I./include -l$(GOOGLE_MOCK_LIBS) -l$(GOOGLE_TEST_LIBS) -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR) -L$(GOOGLE_TEST_LIB_DIR) -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS)



clean:
	-rm -rdf obj/
	-rm $(PROGRAMS)
	-rm $(EXAMPLES)
	-rm $(ALL_COMPILED_EXECUTABLES_IN_BIN)



fresh:
	make clean
	make -j8
	make bin/run_all_tests
