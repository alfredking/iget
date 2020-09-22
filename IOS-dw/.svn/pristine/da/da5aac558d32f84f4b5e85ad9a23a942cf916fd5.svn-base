//
//  userIndoStorageTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "userInfoStorage.h"
@interface userIndoStorageTests : XCTestCase

@end

@implementation userIndoStorageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testsetInfo {
    NSDictionary *userinfo;
    NSString *key;
    XCTAssertThrows([userInfoStorage setInfo:userinfo withKey:key]);
}
- (void)testgetInfoWithKey {
    NSString *key = @"key";
    XCTAssert([userInfoStorage getInfoWithKey:key]);
}
- (void)testremoveInfoWithKey {
    NSString *key = nil;
    XCTAssertThrows([userInfoStorage removeInfoWithKey:key]);
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
