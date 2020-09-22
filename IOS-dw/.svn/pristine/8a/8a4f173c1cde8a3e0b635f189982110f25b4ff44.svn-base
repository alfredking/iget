//
//  secFileStorageTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "secFileStorage.h"
@interface secFileStorageTests : XCTestCase

@end

@implementation secFileStorageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testsetUserInfo {
    NSDictionary *useInfo = nil;
    XCTAssert([secFileStorage setUserInfo:useInfo]);
}
- (void)testsetUserInfo_1 {
    NSDictionary *useInfo = @{@"key":@1};
    XCTAssert([secFileStorage setUserInfo:useInfo]);
}
- (void)testgetUserInfo {
    XCTAssertNoThrow([secFileStorage getUserInfo]);
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
