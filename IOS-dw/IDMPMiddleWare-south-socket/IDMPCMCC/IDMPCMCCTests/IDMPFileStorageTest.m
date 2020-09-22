//
//  IDMPFileStorageTest.m
//  IDMPCMCCTests
//
//  Created by wj on 2018/1/24.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "secFileStorage.h"

@interface IDMPFileStorageTest : XCTestCase

@end

@implementation IDMPFileStorageTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testFileStorage {
    NSError *error;
    NSDictionary *rawdic = @{@"username":@"alex"};
    [secFileStorage setUserInfo:rawdic withError:&error];
    NSDictionary *dic = [secFileStorage getUserInfoWithError:&error];
    XCTAssertTrue([rawdic isEqualToDictionary:dic]);
    
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
