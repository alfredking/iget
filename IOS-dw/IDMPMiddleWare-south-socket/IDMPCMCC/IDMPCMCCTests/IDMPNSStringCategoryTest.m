//
//  IDMPNSStringCategoryTest.m
//  IDMPCMCCTests
//
//  Created by wj on 2018/1/24.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+IDMPAdd.h"
#import "NSString+IDMPAdd.h"

@interface IDMPNSStringCategoryTest : XCTestCase

@end

@implementation IDMPNSStringCategoryTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testAes {
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
//    NSError *fileError=nil;
//    NSDictionary *userInfo = @{@"username":@"wj"};
//    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
////    NSData *encData = [infoData aesEncryptWithKey:@"123456"];
//    NSData *encData = [IDMPAES128 AESEncryptWithKey:@"123456" andData:infoData];
//
//    [encData writeToFile:plistPath options:NSDataWritingAtomic error:&fileError];
//    NSData *userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:&fileError];
////    NSData *decUserData = [userData aesDecryptWithKey:@"123456"];
//    NSData *decUserData = [IDMPAES128 AESDecryptWithKey:@"123456" andData:userData];
//    NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithData:decUserData];
//    XCTAssertTrue([userInfo isEqualToDictionary:users]);
//}



- (void)testidmp_isphone_f1 {
    NSString *tmp = @"123";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isphone_f2 {
    NSString *tmp = @"18823717312314123123121";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isphone_f3 {
    NSString *tmp = @"";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertFalse(res);
}


- (void)testidmp_isphone_f4 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isphone_f5 {
    NSString *tmp = NULL;
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isphone_t1 {
    NSString *tmp = @"18867105231";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertTrue(res);
}

- (void)testidmp_isphone_t2 {
    NSString *tmp = @"18867101";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertTrue(res);
}

- (void)testidmp_isphone_t3 {
    NSString *tmp = @"188671011231232";
    
    BOOL res = [tmp idmp_isPhoneNum];
    
    XCTAssertTrue(res);
}

- (void)testidmp_isPassword_f1 {
    NSString *tmp = @"";
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isPassword_f2 {
    NSString *tmp = @"12345";
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isPassword_f3 {
    NSString *tmp = @"1234512342434234234235234";
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isPassword_f4 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isPassword_f5 {
    NSString *tmp = NULL;
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isPassword_t1 {
    NSString *tmp = @"123sddasd123";
    
    BOOL res = [tmp idmp_isPassword];
    
    XCTAssertTrue(res);
}

- (void)testidmp_isipaddress_f1 {
    NSString *tmp = NULL;
    
    BOOL res = [tmp idmp_isIPAddress];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isipaddress_f2 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_isIPAddress];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isipaddress_f3 {
    NSString *tmp = @"123.1234";
    
    BOOL res = [tmp idmp_isIPAddress];
    
    XCTAssertFalse(res);
}

- (void)testidmp_isipaddress_t1 {
    NSString *tmp = @"172.23.21.2";
    
    BOOL res = [tmp idmp_isIPAddress];
    
    XCTAssertTrue(res);
}

- (void)testidmp_containsString_f1 {
    NSString *tmp = @"123.1234";
    
    BOOL res = [tmp idmp_containsString:@"12333"];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_f2 {
    NSString *tmp = @"";
    
    BOOL res = [tmp idmp_containsString:@"12333"];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_f3 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_containsString:@"12333"];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_f4 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_containsString:NULL];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_f5 {
    NSString *tmp = nil;
    
    BOOL res = [tmp idmp_containsString:nil];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_f6 {
    NSString *tmp = @"123";
    
    BOOL res = [tmp idmp_containsString:nil];
    
    XCTAssertFalse(res);
}

- (void)testidmp_containsString_t1 {
    NSString *tmp = @"123";
    
    BOOL res = [tmp idmp_containsString:@"2"];
    
    XCTAssertTrue(res);
}

- (void)testidmp_hideMiddleFourFromStart_f1 {
    NSString *tmp = @"123123";
    
    NSString *res = [tmp idmp_hideMiddleFourFromStart];
    
    XCTAssertEqual(tmp, res);
}

- (void)testidmp_hideMiddleFourFromStart_f2 {
    NSString *tmp = nil;
    
    NSString *res = [tmp idmp_hideMiddleFourFromStart];
    
    XCTAssertEqual(tmp, res);
}

- (void)testidmp_hideMiddleFourFromStart_t1 {
    NSString *tmp = @"12343553";
    
    NSString *res = [tmp idmp_hideMiddleFourFromStart];
    
    XCTAssertNotEqual(tmp, res);
}

- (void)testidmp_hideMiddleFourFromEnd_f1 {
    NSString *tmp = nil;
    
    NSString *res = [tmp idmp_hideMiddleFourFromEnd];
    
    XCTAssertTrue([res isEqualToString:tmp]);
}

- (void)testidmp_hideMiddleFourFromEnd_f2 {
    NSString *tmp = @"12312";
    
    NSString *res = [tmp idmp_hideMiddleFourFromEnd];
    
    XCTAssertEqual(tmp, res);
}

- (void)testidmp_hideMiddleFourFromEnd_t1 {
    NSString *tmp = @"18867105123";
    
    NSString *res = [tmp idmp_hideMiddleFourFromEnd];
    
    XCTAssertTrue([res isEqualToString:@"188****5123"]);
}




- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
