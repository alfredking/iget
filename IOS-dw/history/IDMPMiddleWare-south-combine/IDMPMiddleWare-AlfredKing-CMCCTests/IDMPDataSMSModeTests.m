//
//  IDMPDataSMSModeTests.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPDataSMSMode.h"
@interface IDMPDataSMSModeTests : XCTestCase
@property (nonatomic, strong) IDMPDataSMSMode *mode;
@end

@implementation IDMPDataSMSModeTests

- (void)setUp {
    _mode = [[IDMPDataSMSMode alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testgetDataSmsKSWithSuccessBlock {
    
    XCTAssertNoThrow([_mode getDataSmsKSWithSuccessBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        
    }]);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _mode = nil;
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
