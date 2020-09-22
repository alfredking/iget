//
//  LogTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Log.h"
@interface LogTests : XCTestCase

@end

@implementation LogTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)test_Log {
    NSString *prefix = @"prefix";
    const char file;
    int lineNumber;
    const char funcName;
    NSString *format = @"format";
    XCTAssertNoThrow(_Log(prefix, &file, lineNumber, &funcName, format));
}
- (void)test_Log_1 {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* lLogDir = [documentsDirectory stringByAppendingPathComponent:@"log/UAlog"];
    [manager removeItemAtPath:lLogDir error:nil];
    NSString *prefix = @"prefix";
    const char file;
    int lineNumber;
    const char funcName;
    NSString *format = @"format";
    XCTAssertNoThrow(_Log(prefix, &file, lineNumber, &funcName, format));
}
- (void)test_Log_printf {
    NSString *prefix = @"prefix";
    const char file;
    int lineNumber;
    const char funcName;
    char format ;
    XCTAssertNoThrow(_Log_printf(prefix, &file, lineNumber, &funcName, &format));
}
//- (void)test_Log_printf_1 {
//    NSString *prefix = @"prefix";
//    const char file;
//    int lineNumber;
//    const char funcName;
//    char format ;
//    XCTestExpectation *expection = [self expectationWithDescription:@"async method"];
//    [expection fulfill];
//    XCTAssertNoThrow(_Log_printf(prefix, &file, lineNumber, &funcName, &format));
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
