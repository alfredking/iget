//
//  IDMPKeychainTest.m
//  IDMPCMCCTests
//
//  Created by wj on 2018/1/25.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPKeychain.h"

@interface IDMPKeychainTest : XCTestCase

@end

@implementation IDMPKeychainTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testKeychain {
    //需在真机下测试
    NSDictionary *rawDic = @{@"name":@"alex"};
    BOOL result = [IDMPKeychain setData:rawDic account:@"user"];
    NSDictionary *dic = [IDMPKeychain getDataForAccount:@"user"];
    XCTAssertTrue([rawDic isEqualToDictionary:dic]);
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
