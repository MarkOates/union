# see this SO for techniques in using a separate file to define variables
# https://unix.stackexchange.com/questions/235223/makefile-include-env-file

FOCUSED_PROJECT_FOLDER_FILENAME=/Users/markoates/Repos/hexagon/bin/programs/data/tmp/current_project_directory.txt
# PROJECT_BASE_DIRECTORY := $$PWD
PROJECT_BASE_DIRECTORY=`cat ${FOCUSED_PROJECT_FOLDER_FILENAME}`
FOCUSED_COMPONENT_FILENAME=/Users/markoates/Repos/hexagon/bin/programs/data/tmp/focused_component.txt
BUILD_STATUS_SIGNALING_FILENAME=/Users/markoates/Repos/hexagon/bin/programs/data/tmp/build_signal.txt
FOCUSED_COMPONENT_NAME=`cat ${FOCUSED_COMPONENT_FILENAME}`
FOCUSED_TEST_FILTER=${FILTER}


ifeq ($(OS),Windows_NT)
else
	ERROR_IF_INCORRECT_RETURN_TYPE=-Werror=return-type
	ERROR_IF_UNINITIALIZED=-Werror=uninitialized
	UNUSED_ARGUMENTS_FLAG=-Qunused-arguments
	DISABLE_UNUSED_VARIABLE_WARNING_FLAG=-Wno-unused-variable
	ERROR_LIMIT_FLAG=-ferror-limit=1
endif


mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))


PROJECT_LIB_NAME=mylibrary
VERSION_NUMBER=0.0.1
## This is a temporary hack to have union/Makefile build with allegro_flare
ifeq ($(OS),Windows_NT)
	LIBS_ROOT=/home/Mark/Repos
	ASIO_LIBS_ROOT=$(LIBS_ROOT)
else
	LIBS_ROOT=/Users/markoates/Repos
	ASIO_LIBS_ROOT=$(LIBS_ROOT)
endif
ALLEGRO_INCLUDE_DIR=$(LIBS_ROOT)/allegro5/include
ALLEGRO_FLARE_INCLUDE_DIR=$(LIBS_ROOT)/allegro_flare/include
ALLEGRO_PLATFORM_INCLUDE_DIR=$(LIBS_ROOT)/allegro5/build/include
ALLEGRO_LIB_DIR=$(LIBS_ROOT)/allegro5/build/lib
ALLEGRO_FLARE_LIB_DIR=$(LIBS_ROOT)/allegro_flare/lib
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



# ProjectMakefile can be included in each project repo, and includes values like
# PROJECT_LIB_NAME and VERSION_NUMBER
-include ProjectMakefile



QUINTESSENCE_BUILDER_EXECUTABLE=~/Repos/blast/bin/programs/quintessence_from_yaml
OUTPUT_BANNER_EXECUTABLE=~/Repos/blast/bin/programs/build_celebrator
SOURCE_RELEASER_EXECUTABLE=~/Repos/blast/bin/programs/create_source_release
WIN64_RELEASER_EXECUTABLE=~/Repos/union/scripts/build_win64_release.sh
MACOS_RELEASER_EXECUTABLE=~/Repos/hexagon/bin/programs/macos_release_builder



ALLEGRO_LIBS=allegro_color allegro_font allegro_ttf allegro_dialog allegro_audio allegro_acodec allegro_primitives allegro_image allegro
ALLEGRO_LIBS_MAIN=$(ALLEGRO_LIBS) allegro_main
ALLEGRO_FLARE_LIB=allegro_flare-0.8.11wip
ALLEGRO_FLARE_LIB_FOR_TESTS=allegro_flare-0.8.11wip-for_tests
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
DEMO_SOURCES := $(shell find demos -name '*.cpp')
TEST_SOURCES := $(shell find tests -name '*Test.cpp')
OBJECTS := $(SOURCES:src/%.cpp=obj/%.o)
DEPS := $(SOURCES:src/%.cpp=.deps/%.d)
PROGRAMS := $(PROGRAM_SOURCES:programs/%.cpp=bin/programs/%)
EXAMPLES := $(EXAMPLE_SOURCES:examples/%.cpp=bin/examples/%)
DEMOS := $(DEMO_SOURCES:demos/%.cpp=bin/demos/%)
TEST_OBJECTS := $(TEST_SOURCES:tests/%.cpp=obj/tests/%.o)
LIBRARY_FOR_TESTS_FOR_LINKING_NAME := $(PROJECT_LIB_NAME)-$(VERSION_NUMBER)-for_tests
LIBRARY_FOR_TESTS_NAME := lib/lib$(PROJECT_LIB_NAME)-$(VERSION_NUMBER)-for_tests.a
LIBRARY_NAME := lib/lib$(PROJECT_LIB_NAME)-$(VERSION_NUMBER).a
INDIVIDUAL_TEST_EXECUTABLES := $(TEST_SOURCES:tests/%.cpp=bin/tests/%)
ifeq ($(OS),Windows_NT)
	ALL_COMPILED_EXECUTABLES_IN_BIN := $(shell find bin/**/* -perm /111 -type f)
else
	ALL_COMPILED_EXECUTABLES_IN_BIN := $(shell find bin/**/* -perm +111 -type f)
endif



## Counts
NUMBER_OF_QUINTESSENCE_SOURCES := $(words $(QUINTESSENCE_SOURCES))
NUMBER_OF_SOURCES := $(words $(SOURCES))
NUMBER_OF_PROGRAM_SOURCES := $(words $(PROGRAM_SOURCES))





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


BUILD_FILE_PATH_ROOT=/Users/markoates/Repos/hexagon/bin/programs/data/builds/dumps
BUILD_FILE_QUINTESSENCE_EXTRAPOLATION=$(BUILD_FILE_PATH_ROOT)/quintessence_build.txt
BUILD_FILE_DEPS_BUILD=$(BUILD_FILE_PATH_ROOT)/deps_build.txt
BUILD_FILE_COMPONENT_OBJECT_BUILD=$(BUILD_FILE_PATH_ROOT)/component_object_build.txt
# NOTE: this PROGRAMS_BUILD is currently not captured in daemus
# TODO: include BUILD_FILE_PROGRAMS_BUILD file in deamus
BUILD_FILE_PROGRAMS_BUILD=$(BUILD_FILE_PATH_ROOT)/programs_build.txt
BUILD_FILE_COMPONENT_TEST_OBJECT_BUILD=$(BUILD_FILE_PATH_ROOT)/component_test_object_build.txt
BUILD_FILE_COMPONENT_TEST_EXECUTABLE_BUILD=$(BUILD_FILE_PATH_ROOT)/component_test_executable.txt
BUILD_FILE_COMPONENT_TESTS_RUN=$(BUILD_FILE_PATH_ROOT)/component_test_run.txt


define output_terminal_message
	$(eval compteur=$(shell echo $$(($(compteur)+1))))
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c yellow -l $(columns) -m Stage ${compteur}: ${1}
	@echo
endef



.PHONY: main quintessence programs objects examples demos library tests docs run_tests deps



main:
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@make quintessences -j8
	$(call output_terminal_message,"Make all the component object files")
	@make deps -j8
	$(call output_terminal_message,"Make all the dependency files")
	@make objects -j8
	$(call output_terminal_message,"Make all the test object files")
	@make test_objects -j8
	$(call output_terminal_message,"Build the library-for-tests")
	@make library_for_tests -j8
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
	$(call output_terminal_message,"Make all the demo programs")
	@make demos -j8
	$(call output_terminal_message,"Update the documentation")
	@make docs
	$(call output_terminal_message,"Celebrate successful build")
	@make celebrate_everything_built



## note: For this process, there are several build stages.  Some stages have their outputs dumpted to a
## file located under $(BUILD_FILE_PATH_ROOT).  Both the stdout and stderr are captured using "some_command_here 2>&1 | tee file_to_dump"
## For how output piping is used, see reference https://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file
## Also, to capture the exit status of the build stage (and not the "tee" process), "pipefail" is used, see this stack overflow:
## https://stackoverflow.com/questions/6871859/piping-command-output-to-tee-but-also-save-exit-code-of-command
## Also, see also "$pipestatus" for a more ellaborate way to capture the exit status of each step in the pipe

focus:
	$(call output_terminal_message,"Announce focus build info")
	@echo "                    Project: $(PROJECT_BASE_DIRECTORY)"
	@echo "Focusing build on component: \033[48;5;27m$(FOCUSED_COMPONENT_NAME)$(TERMINAL_COLOR_RESET)"
	@echo "          testing filter in: \033[48;5;27m$(FOCUSED_TEST_FILTER)$(TERMINAL_COLOR_RESET)"
	$(call output_terminal_message,"Signal to Hexagon build has started and clear builds/dumps/ files")
	@echo "started" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@-rm $(BUILD_FILE_QUINTESSENCE_EXTRAPOLATION)
	@-rm $(BUILD_FILE_COMPONENT_OBJECT_BUILD)
	@-rm $(BUILD_FILE_PROGRAMS_BUILD)
	@-rm $(BUILD_FILE_COMPONENT_TEST_OBJECT_BUILD)
	@-rm $(BUILD_FILE_COMPONENT_TEST_EXECUTABLE_BUILD)
	@-rm $(BUILD_FILE_COMPONENT_TESTS_RUN)
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@echo "generating_sources_files_from_quintessence" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make quintessences -j8 2>&1 | tee $(BUILD_FILE_QUINTESSENCE_EXTRAPOLATION))
	$(call output_terminal_message,"Build dependency file for component")
	@echo "building_dependency_file_for_component" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make deps -j8 2>&1 | tee $(BUILD_FILE_DEPS_BUILD))
	$(call output_terminal_message,"Make all the component object files")
	@echo "building_component_object_files" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make objects 2>&1 | tee $(BUILD_FILE_COMPONENT_OBJECT_BUILD))
	$(call output_terminal_message,"Make the library-for-tests")
	@echo "make_library_for_tests" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@make library_for_tests -j8
	$(call output_terminal_message, "Delete the existing focused component test object and test binary")
	@echo "delete_focused_component_test_object_file_and_test_executable" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@-rm obj/tests/$(FOCUSED_COMPONENT_NAME)Test.o
	@-rm bin/tests/$(FOCUSED_COMPONENT_NAME)Test
	$(call output_terminal_message,"Make the focused component test")
	@echo "build_focused_component_test_object_file" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make obj/tests/$(FOCUSED_COMPONENT_NAME)Test.o 2>&1 | tee $(BUILD_FILE_COMPONENT_TEST_OBJECT_BUILD))
	@echo "build_focused_component_test_executable" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make bin/tests/$(FOCUSED_COMPONENT_NAME)Test 2>&1 | tee $(BUILD_FILE_COMPONENT_TEST_EXECUTABLE_BUILD))
	$(call output_terminal_message,"Run the focused component test")
	@echo "run_test_for_focused_component" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@((set -o pipefail && (./bin/tests/$(FOCUSED_COMPONENT_NAME)Test --gtest_filter=*$(FOCUSED_TEST_FILTER)* 2>&1 | tee $(BUILD_FILE_COMPONENT_TESTS_RUN))) && (make celebrate_passing_tests) || (make signal_failing_tests && exit 1) )
	$(call output_terminal_message,"Make the library")
	@echo "make_library" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@make library -j8
	$(call output_terminal_message,"Make all the programs")
	@echo "make_all_programs" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@set -o pipefail && (make programs 2>&1 | tee $(BUILD_FILE_PROGRAMS_BUILD))
	$(call output_terminal_message,"Update the documentation")
	@echo "make_documentation" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@make docs
	$(call output_terminal_message,"Celebrate integrated component tests")
	@echo "signal_component_built_and_integrated" > $(BUILD_STATUS_SIGNALING_FILENAME)
	@make celebrate_built_component
	$(call output_terminal_message,"Signal to Hexagon that build has completed")
	@echo "completed" > $(BUILD_STATUS_SIGNALING_FILENAME)



fast:
	make clean
	make quintessences -j8
	make objects -j8
	make library



quintessences: $(QUINTESSENCE_SOURCES)
	@[ -f $(QUINTESSENCE_BUILDER_EXECUTABLE) ] || echo "The needed executable $(QUINTESSENCE_BUILDER_EXECUTABLE) was not found"
	@find quintessence -name '*.q.yml' | xargs $(QUINTESSENCE_BUILDER_EXECUTABLE) --less_verbose -f
	@echo "(finished)"



programs: $(PROGRAMS)



objects: $(OBJECTS)



examples: $(EXAMPLES)



demos: $(DEMOS)



library_for_tests: $(LIBRARY_FOR_TESTS_NAME)



library: $(LIBRARY_NAME)



test_objects: $(TEST_OBJECTS)



tests: $(INDIVIDUAL_TEST_EXECUTABLES)



all_tests: $(TEST_OBJECTS) bin/run_all_tests



deps: $(DEPS)



docs:
	@mkdir -p ./docs
	ruby /Users/markoates/Repos/blast/scripts/build_documentation.rb



source_release:
	$(SOURCE_RELEASER_EXECUTABLE) $(current_dir)



win64_release:
	$(WIN64_RELEASER_EXECUTABLE) $(GOOGLE_DRIVE_FILE_ID) $(EXPECTED_RELEASE_FOLDER_NAME)



macos_release:
	$(MACOS_RELEASER_EXECUTABLE) $(RELEASE_PROJECT_NAME) $(RELEASE_FOLDER_NAME)



define output_pass_banner
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c green -l $(columns) --pass
	@echo
endef

define output_fail_banner
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c green -l $(columns) --fail
	@echo
endef

define output_component_built_banner
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c green -l $(columns) --component_built
	@echo
endef



define output_built_banner
	$(eval columns=$(shell tput cols))
	@echo
	@${OUTPUT_BANNER_EXECUTABLE} -c green -l $(columns) --built
	@echo
endef




celebrate_passing_tests:
	$(call output_pass_banner)


celebrate_passing_tests_legacy:
	$(eval columns=$(shell tput cols))
	$(eval banner_width=103)
	$(eval hcolumns=$(shell expr $(columns) / 2 - $(banner_width) / 2))
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒     █▀▀▀▀▄  █▀▀▀▀█  █▀▀▀▀▀  █▀▀▀▀▀    ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒     █▄▄▄▄▀  █▄▄▄▄█  ▀▀▀▀▀█  ▀▀▀▀▀█    ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒     ▀       ▀    ▀  ▀▀▀▀▀▀  ▀▀▀▀▀▀    ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒$(TERMINAL_COLOR_RESET)"
	@printf ' %.0s' {1..$(hcolumns)}
	@echo "$(TERMINAL_COLOR_GREEN)▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒ ▒$(TERMINAL_COLOR_RESET)"



signal_failing_tests:
	$(call output_fail_banner)



signal_failing_tests_legacy:
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
	$(call output_component_built_banner)



celebrate_built_component_legacy:
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
	$(call output_built_banner)



celebrate_everything_built_legacy:
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



.deps/%.d: src/%.cpp
	@mkdir -p $(@D)
	@printf "Compiling dependency \e[1m\e[36m$@\033[0m\n"
	@g++ -std=c++17 -MM $< > $@ -I./include -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -I$(ALLEGRO_INCLUDE_DIR) -I$(ALLEGRO_PLATFORM_INCLUDE_DIR) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -I$(YAML_CPP_INCLUDE_DIR)
	@printf "Dependency at \033[1m\033[32m$@\033[0m created successfully.\n"


bin/programs/%: programs/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "Compiling program executable \e[1m\e[36m$@\033[0m\n"
	@g++ -g -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(DISABLE_UNUSED_VARIABLE_WARNING_FLAG) $(OBJECTS) $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -l$(GOOGLE_TEST_LIBS) -l$(ALLEGRO_FLARE_LIB) -I$(NCURSES_INCLUDE_DIR) -I$(ALLEGRO_INCLUDE_DIR) -I$(ALLEGRO_PLATFORM_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -L$(ALLEGRO_LIB_DIR)
	@printf "Program executable at \033[1m\033[32m$@\033[0m compiled successfully.\n"



bin/examples/%: examples/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "Compiling example executable \e[1m\e[36m$@\033[0m\n"
	@g++ -g -std=c++17 $(ERROR_LIMIT_FLAG) $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(DISABLE_UNUSED_VARIABLE_WARNING_FLAG) $(OBJECTS) $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -l$(GOOGLE_TEST_LIBS) -L$(ALLEGRO_LIB_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -l$(ALLEGRO_FLARE_LIB)
	@printf "Example executable at \033[1m\033[32m$@\033[0m compiled successfully.\n"



bin/demos/%: demos/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "Compiling demo executable at \e[1m\e[36m$@\033[0m\n"
	@g++ -g -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -l$(GOOGLE_TEST_LIBS) -L$(ALLEGRO_LIB_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -l$(ALLEGRO_FLARE_LIB)
	@printf "Demo executable at \033[1m\033[32m$@\033[0m compiled successfully.\n"




obj/%.o: src/%.cpp
	@mkdir -p $(@D)
	@printf "Compiling object file \e[1m\e[34m$@\033[0m\n"
	@g++ -g -c $(ERROR_LIMIT_FLAG) -std=c++17 $(UNUSED_ARGUMENTS_FLAG) $(ERROR_IF_INCORRECT_RETURN_TYPE) $(ERROR_IF_UNINITIALIZED) -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -I$(ALLEGRO_INCLUDE_DIR) -I$(ALLEGRO_PLATFORM_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -D_XOPEN_SOURCE_EXTENDED -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -l$(ALLEGRO_FLARE_LIB)
	@printf "Object file at \033[1m\033[32m$@\033[0m compiled successfully.\n"



$(LIBRARY_FOR_TESTS_NAME): $(OBJECTS)
	@printf "Compiling library-for-tests \e[1m\e[36m$@\033[0m\n"
ifeq ($(OBJECTS),)
	@printf "\033[1m\033[32mnothing to be done, there are no objects to build into a library-for-tests\033[0m."
else
	@ar rs $(LIBRARY_FOR_TESTS_NAME) $^
	@printf "done. Library-for-tests file at \033[1m\033[32m$@\033[0m\n"
endif



$(LIBRARY_NAME): $(OBJECTS)
	@printf "Compiling library \e[1m\e[36m$@\033[0m\n"
ifeq ($(OBJECTS),)
	@printf "\033[1m\033[32mnothing to be done, there are no objects to build into a library\033[0m."
else
	@ar rs $(LIBRARY_NAME) $^
	@printf "done. Library file at \033[1m\033[32m$@\033[0m\n"
endif



obj/tests/%.o: tests/%.cpp
	@mkdir -p $(@D)
	@printf "Compiling test object file \e[1m\e[36m$@\033[0m\n"
	@g++ -g -c -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(ALLEGRO_INCLUDE_DIR) -I$(ALLEGRO_PLATFORM_INCLUDE_DIR) -I$(ASIO_INCLUDE_DIR) -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR) -I$(YAML_CPP_INCLUDE_DIR) -I$(ALLEGRO_FLARE_INCLUDE_DIR)
	@printf "Test object file at \033[1m\033[32m$@\033[0m compiled successfully.\n"



obj/tests/TestRunner.o: tests/TestRunner.cpp
	@mkdir -p $(@D)
	@printf "Compiling test object for TestRunner \e[1m\e[36m$@\033[0m\n"
	@g++ -g -c -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< -o $@ -I$(ALLEGRO_INCLUDE_DIR) -I$(ALLEGRO_PLATFORM_INCLUDE_DIR) -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(GOOGLE_MOCK_INCLUDE_DIR) -I$(ALLEGRO_FLARE_INCLUDE_DIR)
	@printf "Object for TestRunner at \033[1m\033[32m$@\033[0m compiled successfully.\n"



bin/tests/%: obj/tests/%.o obj/tests/TestRunner.o
	@mkdir -p $(@D)
	@printf "Compiling standalone test executable at \e[1m\e[36m$@\033[0m\n"
	@g++ -g -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $< obj/tests/TestRunner.o -o $@ -l$(GOOGLE_MOCK_LIBS) -l$(GOOGLE_TEST_LIBS) -I./include $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -I$(ALLEGRO_INCLUDE_DIR) -I$(ASIO_INCLUDE_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(ALLEGRO_LIB_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -l$(ALLEGRO_FLARE_LIB_FOR_TESTS) -L./lib -l$(LIBRARY_FOR_TESTS_FOR_LINKING_NAME)
	@printf "Standalone executable at \033[1m\033[32m$@\033[0m compiled successfully.\n"



bin/run_all_tests: $(TEST_OBJECTS) obj/tests/TestRunner.o
	@mkdir -p $(@D)
	@printf "Compiling run_all_tests executable \e[1m\e[36m$@\033[0m\n"
	@g++ -g -std=c++17 $(UNUSED_ARGUMENTS_FLAG) -Wall -Wuninitialized -Weffc++ $(TEST_OBJECTS) obj/tests/TestRunner.o -o $@ -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) -l$(ALLEGRO_FLARE_LIB_FOR_TESTS) -I./include -l$(GOOGLE_MOCK_LIBS) -l$(GOOGLE_TEST_LIBS) -I$(ASIO_INCLUDE_DIR) -L$(ALLEGRO_LIB_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED $(OPENGL_LIB) $(REQUIRED_WINDOWS_NETWORK_FLAGS) -L./lib -l$(LIBRARY_FOR_TESTS_FOR_LINKING_NAME)
	@printf "run_all_tests executable at \e[1m\e[36m$@\033[0m compiled successfully.\n"



list_quintessence_sources:
	@for item in $(QUINTESSENCE_SOURCES) ; do \
	   printf $$item ; \
  done



list_sources:
	@for item in $(SOURCES) ; do \
	   echo $$item ; \
  done


list_objects:
	@for item in $(OBJECTS) ; do \
	   echo $$item ; \
  done


list_test_objects:
	@for item in $(TEST_OBJECTS) ; do \
	   echo $$item ; \
  done


list_program_sources:
	@for item in $(PROGRAM_SOURCES) ; do \
	   echo $$item ; \
  done


list_test_executables:
	@for item in $(INDIVIDUAL_TEST_EXECUTABLES) ; do \
	   echo $$item ; \
	done




clean:
	-rm -rdf obj/
	-rm $(PROGRAMS)
	-rm $(EXAMPLES)
	-rm $(TEST_OBJECTS)
	-rm $(INDIVIDUAL_TEST_EXECUTABLES)
	-rm bin/run_all_tests
	-rm $(DEMOS)
	-rm $(ALL_COMPILED_EXECUTABLES_IN_BIN)
	-rm $(DEPS)


newlib:
	-rm lib/liballegro_flare-0.8.11wip.a
	make library


fresh:
	make clean
	make -j8
	make bin/run_all_tests
