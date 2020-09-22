//
//  IDMPFormatTransformTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPFormatTransform.h"
@interface IDMPFormatTransformTests : XCTestCase

@end

@implementation IDMPFormatTransformTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testcharToHex {
    char str = 1;
    int length = 1;
    XCTAssert(charToHex(&str, length));
}
- (void)testcharToNSHex {
    unsigned char str = 1;
    int length = 1;
    XCTAssert(str);
    XCTAssert(length);
    XCTAssert([IDMPFormatTransform charToNSHex:&str length:length]);
}
- (void)testprint_hex {
    char buff = 1;
    XCTAssertNoThrow(print_hex(&buff));
}
- (void)testHexStrToByte {
    const char sourceString = 1;
    int sourceLen = 1;
    XCTAssertNoThrow(HexStrToByte(&sourceString, sourceLen));
}
- (void)testhexStringToNSData {
    NSString *hexStr = @"hexStr";
    XCTAssert(hexStr);
    XCTAssert([IDMPFormatTransform hexStringToNSData:hexStr]);
}
- (void)testcheckNSStringisNULL {
    NSString *string = nil;
    XCTAssertTrue([IDMPFormatTransform checkNSStringisNULL:string]);
}
- (void)testcheckNSStringisNULL_1 {
    NSString *string = @"test";
    XCTAssertFalse([IDMPFormatTransform checkNSStringisNULL:string]);
}
- (void)testcheckNSStringisNULL_2 {
    NSString *string = @"<null>";
    XCTAssert([IDMPFormatTransform checkNSStringisNULL:string]);
}
- (void)testcheckNSStringisNULL_3 {
    NSString *string = @"(null)";
    XCTAssert([IDMPFormatTransform checkNSStringisNULL:string]);
}
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
