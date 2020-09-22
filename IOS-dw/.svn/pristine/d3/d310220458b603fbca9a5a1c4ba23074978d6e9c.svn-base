//
//  IDMPAccountManagerModeTests.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPAccountManagerMode.h"
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"
@interface IDMPAccountManagerModeTests : XCTestCase

@end

@implementation IDMPAccountManagerModeTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testshareAccountManager {
    NSMutableArray *singletons = [NSMutableArray array];

//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        IDMPAccountManagerMode *mode = [[IDMPAccountManagerMode alloc] init];
//        [singletons addObject:mode];
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IDMPAccountManagerMode *mode = [IDMPAccountManagerMode shareAccountManager];
        [singletons addObject:mode];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IDMPAccountManagerMode *mode = [IDMPAccountManagerMode shareAccountManager];
        [singletons addObject:mode];
    });
    
    IDMPAccountManagerMode *mode_s = [IDMPAccountManagerMode shareAccountManager];
    
    [singletons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertEqual(mode_s, obj,@"不是单例");
    }];
}
- (void)testregisterUserWithAppId {
    
    NSString *phoneNo;
    NSString *passWord = @"123qwe";
    NSString *validCode = @"242617";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_4 {
    
    NSString *phoneNo = @"qwewkqeqwkejqwklj";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"242617";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_1 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord;
    NSString *validCode = @"178237";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_5 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123";
    NSString *validCode = @"178237";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_2 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode;
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_3 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"534512";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testregisterUserWithAppId_6 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"213knsajknd";
    [[IDMPAccountManagerMode shareAccountManager] registerUserWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId {
    
    NSString *phoneNo;
    NSString *passWord = @"123qwe";
    NSString *validCode = @"142342";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_4 {
    
    NSString *phoneNo = @"15868178826abc";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"142342";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_1 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord;
    NSString *validCode = @"362523";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_5 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123";
    NSString *validCode = @"362523";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_2 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode;
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_6 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"hagdhhg123";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testresetPasswordWithAppId_3 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *validCode = @"351262";
    [[IDMPAccountManagerMode shareAccountManager] resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andValidCode:validCode finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId {
    
    NSString *phoneNo;
    NSString *passWord = @"123qwe";
    NSString *newPassWd = @"524362";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_4 {
    
    NSString *phoneNo = @"15868178826aweqe";
    NSString *passWord = @"123qwe";
    NSString *newPassWd = @"524362";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_1 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord;
    NSString *newPassWd = @"423412";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_5 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123";
    NSString *newPassWd = @"423412";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_2 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *newPassWd;
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_6 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *newPassWd = @"123";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testchangePasswordWithAppId_3 {
    
    NSString *phoneNo = @"15868178826";
    NSString *passWord = @"123qwe";
    NSString *newPassWd = @"243452";
    [[IDMPAccountManagerMode shareAccountManager] changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:phoneNo passWord:passWord andNewPSW:newPassWd finishBlock:^(NSDictionary *paraments) {
        
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
