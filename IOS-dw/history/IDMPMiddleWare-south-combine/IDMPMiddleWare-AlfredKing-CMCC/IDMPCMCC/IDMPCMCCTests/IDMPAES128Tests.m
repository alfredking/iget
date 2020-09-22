
//
//  IDMPAES128Tests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPAES128.h"
@interface IDMPAES128Tests : XCTestCase

@end

@implementation IDMPAES128Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testAESEncryptWithKey {
    XCTAssert([IDMPAES128 AESEncryptWithKey:@"key" andString:@"sourceString"],@"failed");
}
- (void)testAESDecryptWithKey {
    XCTAssert([IDMPAES128 AESDecryptWithKey:@"key" andString:@"sourceString"],@"failed");
}
- (void)testAESEncryptWithKeyAndData {
    NSData *data = [NSData data];
    XCTAssert(data);
    XCTAssert([IDMPAES128 AESEncryptWithKey:@"key" andData:data],@"failed");
}
- (void)testAESDncryptWithKeyAndData {
    NSData *data = [NSData data];
    XCTAssert(data);
    XCTAssert([IDMPAES128 AESDecryptWithKey:@"key" andData:data],@"failed");
}
- (void)testbase64EncodingWithData {
//    NSData *data = [NSData data];
//    XCTAssertNil(data);
    XCTAssert([IDMPAES128 base64EncodingWithData:nil]);
}
- (void)testbase64EncodingWithData_1 {

    NSString *string = @"test";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssert(data);
    XCTAssert([IDMPAES128 base64EncodingWithData:data]);
}
- (void)testdataWithBase64EncodedString {
    NSString *string = nil;
    //异常处理机制，抛出异常才算通过
    XCTAssertThrows([IDMPAES128 dataWithBase64EncodedString:string]);
}
- (void)testdataWithBase64EncodedString_1 {
    NSString *string = @"";
    XCTAssertNotNil([IDMPAES128 dataWithBase64EncodedString:string]);
}
- (void)testdataWithBase64EncodedString_2 {
    NSString *string = @"string";
    //异常处理机制，不抛出异常才算通过
    XCTAssertNoThrow([IDMPAES128 dataWithBase64EncodedString:string]);
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
