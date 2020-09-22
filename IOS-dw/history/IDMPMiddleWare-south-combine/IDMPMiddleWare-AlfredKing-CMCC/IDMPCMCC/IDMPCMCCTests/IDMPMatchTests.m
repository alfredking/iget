//
//  IDMPMatchTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPMatch.h"
@interface IDMPMatchTests : XCTestCase

@end

@implementation IDMPMatchTests
//+ (BOOL) validateMobile:(NSString *)mobile;
//+ (BOOL) validatePassword:(NSString *)passWord;
//+ (BOOL) validateCheck:(NSString *)checkWord;
//+ (BOOL) validateEmail:(NSString *)email;
//+ (BOOL) validatePassID:(NSString *)passId;
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testvalidateMobile {
    NSString *mobile = @"15868178826";
    XCTAssert([IDMPMatch validateMobile:mobile]);
}
- (void)testvalidatePassword {
    NSString *passWord = @"123456qwe";
    XCTAssert([IDMPMatch validatePassword:passWord]);
}
- (void)testvalidateCheck {
    NSString *checkWord = @"343234";
    XCTAssert([IDMPMatch validateCheck:checkWord]);
}
- (void)testvalidateEmail {
    NSString *email = @"15868178826@139.com";
    XCTAssert([IDMPMatch validateEmail:email]);
}
- (void)testvalidatePassID {
    NSString *passId;
    XCTAssertFalse([IDMPMatch validatePassID:passId]);
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
