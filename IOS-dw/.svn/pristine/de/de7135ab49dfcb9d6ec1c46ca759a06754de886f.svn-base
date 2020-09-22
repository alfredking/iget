//
//  IDMPQueryModelTests.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPQueryModel.h"
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"
@interface IDMPQueryModelTests : XCTestCase

@end

@implementation IDMPQueryModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testqueryAppPasswdWithUserName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *username = @"15868178826";
    [IDMPQueryModel queryAppPasswdWithUserName:username finishBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    } failBlock:^(NSDictionary *paraments) {
        
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testcheckWithAppId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *appid = APPID;
    NSString *appkey = APPKEY;
    [IDMPQueryModel checkWithAppId:appid andAppkey:appkey finishBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    } failBlock:^(NSDictionary *paraments) {
        
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testcheckWithAppId_1 {
    NSString *appid;
    NSString *appkey = APPKEY;
    [IDMPQueryModel checkWithAppId:appid andAppkey:appkey finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
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
