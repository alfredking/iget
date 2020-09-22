//
//  IDMPMD5Tests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPMD5.h"
@interface IDMPMD5Tests : XCTestCase
@property (nonatomic, strong) IDMPMD5 *md5;
@end

@implementation IDMPMD5Tests

- (void)setUp {
    [super setUp];
    _md5 = [[IDMPMD5 alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testgetMd5_32Bit_String {
    NSString *string = @"test";
    XCTAssert([_md5 getMd5_32Bit_String:string]);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _md5 = nil;
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
