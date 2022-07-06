
#include <allegro5/allegro.h>

#include <gtest/gtest.h>

// look here for extending google test to handle events
// https://github.com/google/googletest/blob/main/docs/advanced.md#extending-googletest-by-handling-test-events

//class MinimalistPrinter : public testing::EmptyTestEventListener {
 //// Called before a test starts.
 //void OnTestStart(const testing::TestInfo& test_info) override {
   //printf("*** Test %s.%s starting.\n",
          //test_info.test_suite_name(), test_info.name());
 //}

 //// Called after a failed assertion or a SUCCESS().
 //void OnTestPartResult(const testing::TestPartResult& test_part_result) override {
   //printf("%s in %s:%d\n%s\n",
          //test_part_result.failed() ? "*** Failure" : "Success",
          //test_part_result.file_name(),
          //test_part_result.line_number(),
          //test_part_result.summary());
 //}

 //// Called after a test ends.
 //void OnTestEnd(const testing::TestInfo& test_info) override {
   //printf("*** Test %s.%s ending.\n",
          //test_info.test_suite_name(), test_info.name());
 //}
//};


int main(int argc, char **argv)
{
   ::testing::InitGoogleTest(&argc, argv);

   //// Gets hold of the event listener list.
   //testing::TestEventListeners& listeners =
      //testing::UnitTest::GetInstance()->listeners();
   //// Adds a listener to the end.  googletest takes the ownership.
   //listeners.Append(new MinimalistPrinter);

   return RUN_ALL_TESTS();
}

