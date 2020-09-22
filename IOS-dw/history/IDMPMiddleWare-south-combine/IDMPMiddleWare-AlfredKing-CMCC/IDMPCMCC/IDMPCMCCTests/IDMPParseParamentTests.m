//
//  IDMPParseParamentTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPParseParament.h"
@interface IDMPParseParamentTests : XCTestCase

@end

@implementation IDMPParseParamentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testparseParamentFrom {
    NSString *wwwauthenticate = @"wwwauthenticate";
    XCTAssert(wwwauthenticate);
    XCTAssertThrows([IDMPParseParament parseParamentFrom:wwwauthenticate]);
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
