
FOCUSED_COMPONENT_NAME=Blast/Project/SymlinkChecker
FOCUSED_TEST_FILTER=



PROJECT_NAME=mylibrary
VERSION_NUMBER=0.0.1
LIBS_ROOT=/Users/markoates/Repos
ALLEGRO_INCLUDE_DIR=$(LIBS_ROOT)/allegro5/build/include
ALLEGRO_LIB_DIR=$(LIBS_ROOT)/allegro5/build/lib
GOOGLE_TEST_DIR=$(LIBS_ROOT)/googletest
GOOGLE_TEST_LIB_DIR=$(GOOGLE_TEST_DIR)/build/googlemock/gtest
GOOGLE_TEST_INCLUDE_DIR=$(GOOGLE_TEST_DIR)/googletest/include
NCURSES_INCLUDE_DIR=/usr/local/opt/ncurses/include
NCURSES_LIB_DIR=/usr/local/opt/ncurses/lib
YAML_CPP_DIR=$(LIBS_ROOT)/yaml-cpp
YAML_CPP_LIB_DIR=$(YAML_CPP_DIR)/build
YAML_CPP_INCLUDE_DIR=$(YAML_CPP_DIR)/include



QUINTESSENCE_BUILDER_EXECUTABLE=~/Repos/blast/bin/programs/quintessence_from_yaml



ALLEGRO_LIBS=allegro_color allegro_font allegro_ttf allegro_dialog allegro_audio allegro_acodec allegro_primitives allegro_image allegro
ALLEGRO_LIBS_MAIN=$(ALLEGRO_LIBS) allegro_main
GOOGLE_TEST_LIBS=gtest
NCURSES_LIB=ncurses
YAML_CPP_LIBS=yaml-cpp



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
ALL_COMPILED_EXECUTABLES_IN_BIN := $(shell find bin/**/* -perm +111 -type f)



ALLEGRO_LIBS_LINK_ARGS := $(ALLEGRO_LIBS:%=-l%)
ALLEGRO_LIBS_LINK_MAIN_ARGS := $(ALLEGRO_LIBS_MAIN:%=-l%)



TERMINAL_COLOR_YELLOW=\033[1;33m
TERMINAL_COLOR_GREEN=\033[1;32m
TERMINAL_COLOR_BLUE=\033[1;34m
TERMINAL_COLOR_LIGHT_BLUE=\033[1;94m
TERMINAL_COLOR_RESET=\033[0m



define output_terminal_message
	$(eval compteur=$(shell echo $$(($(compteur)+1))))
	@echo "\n$(TERMINAL_COLOR_YELLOW)===== Stage $(compteur): $(1) =====$(TERMINAL_COLOR_RESET)\n"
endef



.PHONY: main quintessence programs objects examples library tests run_tests



main:
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@make quintessences
	$(call output_terminal_message,"Make all the component object files")
	@make objects
	$(call output_terminal_message,"Make all the test objects")
	@make test_objects
	$(call output_terminal_message,"Make all the test executables")
	@make tests
	$(call output_terminal_message,"Run the tests for all the components")
	@make run_tests
	$(call output_terminal_message,"Celebrate passing all tests")
	@make celebrate_passing_tests
	$(call output_terminal_message,"Build the library")
	@make library
	$(call output_terminal_message,"Make all the programs")
	@make programs
	$(call output_terminal_message,"Make all the example programs")
	@make examples
	$(call output_terminal_message,"🀫 🀫 🀫 🀫 🀫 🀫 🀫 FINISHED! 🀫 🀫 🀫 🀫 🀫 🀫 🀫")



focus:
	$(call output_terminal_message,"Announce built type")
	@echo "Focusing build on \033[48;5;27m$(FOCUSED_COMPONENT_NAME)$(TERMINAL_COLOR_RESET)"
	@echo "testing filter in $(FOCUSED_TEST_FILTER)"
	$(call output_terminal_message,"Compose componets from all quintessence files")
	@make quintessences
	$(call output_terminal_message,"Make all the component object files")
	@make objects
	$(call output_terminal_message,"Make the focused component test")
	@make obj/tests/$(FOCUSED_COMPONENT_NAME)Test.o
	$(call output_terminal_message,"Make the focused component test")
	@make bin/tests/$(FOCUSED_COMPONENT_NAME)Test
	$(call output_terminal_message,"Run the focused component test")
	@./bin/tests/$(FOCUSED_COMPONENT_NAME)Test --gtest_filter=*$(FOCUSED_TEST_NAME)*
	$(call output_terminal_message,"Make all the programs")
	@make programs
	$(call output_terminal_message,"Celebrate passing focused component tests")
	@make celebrate_built_component



quintessences: $(QUINTESSENCE_SOURCES)
	[ -f $(QUINTESSENCE_BUILDER_EXECUTABLE) ] || echo "The needed executable $(QUINTESSENCE_BUILDER_EXECUTABLE) was not found"
	find quintessence -name '*.q.yml' | xargs $(QUINTESSENCE_BUILDER_EXECUTABLE)



programs: $(PROGRAMS)



objects: $(OBJECTS)



examples: $(EXAMPLES)



library: $(LIBRARY_NAME)



test_objects: $(TEST_OBJECTS)



tests: $(INDIVIDUAL_TEST_EXECUTABLES) bin/run_all_tests



run_tests: tests
	bin/run_all_tests



celebrate_passing_tests:
	@echo "\033[1m\033[32m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@echo "\033[1m\033[32m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@echo "\033[1m\033[32m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫    PASS   🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@echo "\033[1m\033[32m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@echo "\033[1m\033[32m🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"



celebrate_built_component:
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫  $(TERMINAL_COLOR_BLUE)   COMPONENT BUILT     $(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_BLUE)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_BLUE)🀫\033[0m"
	@echo "\033[1m$(TERMINAL_COLOR_BLUE)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫\033[0m"



celebrate_everything_built:
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_YELLOW)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_RESET)\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_RESET)\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_YELLOW)🀫$(TERMINAL_COLOR_GREEN) 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫        BUILT      🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_YELLOW)🀫$(TERMINAL_COLOR_RESET)\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_GREEN)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)██$(TERMINAL_COLOR_RESET)\033[0m"
	@echo "\033[1m\033[32m$(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_YELLOW)🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 🀫 $(TERMINAL_COLOR_GREEN)████$(TERMINAL_COLOR_RESET)\033[0m"



bin/programs/%: programs/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling program \e[1m\e[36m$<\033[0m..."
	@g++ -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< -o $@ -I./include -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



bin/examples/%: examples/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling example \e[1m\e[36m$<\033[0m..."
	@g++ -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< -o $@ -I./include -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



obj/%.o: src/%.cpp
	@mkdir -p $(@D)
	@printf "compiling object file \e[1m\e[34m$<\033[0m..."
	@g++ -c -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -D_XOPEN_SOURCE_EXTENDED
	@echo "done. object at \033[1m\033[32m$@\033[0m"



$(LIBRARY_NAME): $(OBJECTS)
	@printf "compiling library \e[1m\e[36m$@\033[0m..."
ifeq ($(OBJECTS),)
	@echo "\033[1m\033[32mnothing to be done, there are no objects to build into a library\033[0m."
else
	@ar rs $(LIBRARY_NAME) $^
	@echo "done. Library file at \033[1m\033[32m$@\033[0m"
endif



obj/tests/%.o: tests/%.cpp $(OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling test object file \e[1m\e[36m$<\033[0m..."
	@g++ -c -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $< -o $@ -I./include -I$(GOOGLE_TEST_INCLUDE_DIR) -I$(YAML_CPP_INCLUDE_DIR) -I$(ALLEGRO_FLARE_INCLUDE_DIR)
	@echo "done. Object at \033[1m\033[32m$@\033[0m"



obj/tests/TestRunner.o: tests/TestRunner.cpp
	@mkdir -p $(@D)
	@printf "compiling test object for TestRunner \e[1m\e[36m$<\033[0m..."
	@g++ -c -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $< -o $@ -I$(GOOGLE_TEST_INCLUDE_DIR)
	@echo "done. Object at \033[1m\033[32m$@\033[0m"



bin/tests/%: obj/tests/%.o obj/tests/TestRunner.o
	@mkdir -p $(@D)
	@printf "compiling standalone test \e[1m\e[36m$<\033[0m..."
	@g++ -std=c++1z -Qunused-arguments -Wall -Wuninitialized -Weffc++ $(OBJECTS) $< obj/tests/TestRunner.o -o $@ -l$(GOOGLE_TEST_LIBS) -I./include -I$(GOOGLE_TEST_INCLUDE_DIR) -L$(GOOGLE_TEST_LIB_DIR) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -I$(ALLEGRO_FLARE_INCLUDE_DIR) -L$(ALLEGRO_FLARE_LIB_DIR) $(ALLEGRO_FLARE_LINK_ARGS) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB)
	@echo "done. Executable at \033[1m\033[32m$@\033[0m"



bin/run_all_tests: tests/TestRunner.cpp $(TEST_OBJECTS)
	echo $(TEST_OBJECTS)
	@mkdir -p $(@D)
	@printf "compiling test_runer \e[1m\e[36m$<\033[0m..."
	@g++ -std=gnu++11 -Qunused-arguments -Wall -Wuninitialized -Weffc++ $(OBJECTS) $(TEST_OBJECTS) $< -o $@ -I./include -l$(GOOGLE_TEST_LIBS) -I$(GOOGLE_TEST_INCLUDE_DIR) -L$(GOOGLE_TEST_LIB_DIR) -I$(NCURSES_INCLUDE_DIR) -L$(NCURSES_LIB_DIR) -l$(NCURSES_LIB) -I$(YAML_CPP_INCLUDE_DIR) -L$(YAML_CPP_LIB_DIR) -l$(YAML_CPP_LIBS) $(ALLEGRO_LIBS_LINK_MAIN_ARGS) -D_XOPEN_SOURCE_EXTENDED



clean:
	-rm -rdf obj/
	-rm $(PROGRAMS)
	-rm $(EXAMPLES)
	-rm $(ALL_COMPILED_EXECUTABLES_IN_BIN)



fresh:
	make clean
	make -j8
	make bin/run_all_tests
