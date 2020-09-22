//
//  IDMPMiddleWare_AlfredKing_CMCCTests.m
//  IDMPMiddleWare-AlfredKing-CMCCTests
//
//  Created by alfredking－cmcc on 14-8-13.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPToken.h"
#import "IDMPConst.h"
#import "IDMPWapMode.h"
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"
@interface IDMPMiddleWare_AlfredKing_CMCCTests : XCTestCase

@end

@implementation IDMPMiddleWare_AlfredKing_CMCCTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testcheckToken {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *token = @"848401000132020034526B49304F454931516B4D774E446B7A4D7A4177517A684340687474703A2F2F3231312E3133362E31302E3133313A383038302F030004035546520400083030313030323138FF00202FD7BE003B2AA0AD2A4F6524250DAEA42B39A3E30F60F6C36C4387CAB23AF935";
    [IDMPToken checkToken:token successBlock:^(NSDictionary *dic) {
        
    } failBlock:^(NSDictionary *dic) {
        [expectation fulfill];
        XCTAssertNotNil(dic);//resultCode = 103133,sourceId不合法
        
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
- (void)testgetWapKSWithSuccessBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    IDMPWapMode *mode = [[IDMPWapMode alloc] init];
    [mode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
    {
        
    }
    failBlock:^(NSDictionary *paraments)
    {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
