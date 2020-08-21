#include <string>
#include <iostream>

#include <gtest/gtest.h>
#include <glog/logging.h>

#include "sha256Test.h"

#define TRACE_ENABLE 1

/////////////////////////////////////////////////////////////////////////////////
TEST( Test,  1) {uint32_t seed = time(0); LOG(INFO) << "Test_1  " << "seed: " << seed;srand(seed);ASSERT_EQ(EXIT_SUCCESS, sha256Tets(TRACE_ENABLE));}
/////////////////////////////////////////////////////////////////////////////////
 

int main(int argc, char **argv, char **env)
{
    FLAGS_logtostderr = 0;
    FLAGS_stderrthreshold = 3;

    google::InitGoogleLogging(*argv);

    testing::InitGoogleTest(&argc, argv);
    int result = RUN_ALL_TESTS();
    VLOG(1) << "ALL TESTS FINISHED";
    if (result==0){
    } else {
        LOG(ERROR) << "ERROR: some test is failed";        
    }
    return result;
}
