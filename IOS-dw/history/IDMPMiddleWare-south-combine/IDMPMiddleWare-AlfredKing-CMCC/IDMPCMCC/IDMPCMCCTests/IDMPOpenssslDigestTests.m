//
//  IDMPOpenssslDigestTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPOpensslDigest.h"
@interface IDMPOpenssslDigestTests : XCTestCase

@end

@implementation IDMPOpenssslDigestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testsha256WithKeyAndData {
    char key;
    int key_len;
    char data;
    int data_len;
    XCTAssert(sha256WithKeyAndData(&key, key_len, &data, data_len));
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
