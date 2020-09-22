//
//  IDMPRSA_Encrypt_DecryptTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPRSA_Encrypt_Decrypt.h"
@interface IDMPRSA_Encrypt_DecryptTests : XCTestCase

@end

@implementation IDMPRSA_Encrypt_DecryptTests
//NSString *RSA_encrypt(NSString *data);
//NSString *RSA_decrypt(NSString *data);
//+ (SecKeyRef)addPublicKey:(NSString *)key;
//+ (SecKeyRef)addPrivateKey:(NSString *)key;
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testformatPublicKey {
    XCTAssert(formatPublicKey(PUBLIC_KEY));
}
- (void)testformatPrivateKey {
    XCTAssert(formatPrivateKey(PRIVATE_KEY));
}
- (void)teststripPrivateKeyHeader {
    NSData *d_key = nil;
    XCTAssertNil([IDMPRSA_Encrypt_Decrypt stripPrivateKeyHeader:d_key]);
}
- (void)teststripPrivateKeyHeader_1 {
    NSString * str = @"";
    NSData * d_key = [str dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNil([IDMPRSA_Encrypt_Decrypt stripPrivateKeyHeader:d_key]);
}
- (void)teststripPrivateKeyHeader_2 {
    NSString * str = @"hello world!";
    NSData * d_key = [str dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNil([IDMPRSA_Encrypt_Decrypt stripPrivateKeyHeader:d_key]);
}
- (void)testRSA_encrypt {
    NSString *data = @"test";
    XCTAssert(RSA_encrypt(data));
}
- (void)testRSA_decrypt {
    NSString *data = @"test";
    XCTAssertFalse(RSA_decrypt(data));
}

- (void)testaddPublicKey {
    XCTAssert([IDMPRSA_Encrypt_Decrypt addPublicKey:PUBLIC_KEY]);
}
- (void)testaddPrivateKey {
    XCTAssert([IDMPRSA_Encrypt_Decrypt addPrivateKey:PRIVATE_KEY]);
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
