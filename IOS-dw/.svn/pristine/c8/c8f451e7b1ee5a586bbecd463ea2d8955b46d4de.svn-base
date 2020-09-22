//
//  IDMPAutoLoginViewControllerTests.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by apple on 16/8/4.
//  Copyright © 516年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPAutoLoginViewController.h"
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"
@interface IDMPAutoLoginViewControllerTests : XCTestCase
@property (nonatomic, strong) IDMPAutoLoginViewController *autoLoginVc;
@end

@implementation IDMPAutoLoginViewControllerTests

- (void)setUp {
    [super setUp];
    _autoLoginVc = [[IDMPAutoLoginViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
#pragma mark - testgetAuthType
- (void)testgetAuthType {
    XCTAssert([_autoLoginVc getAuthType],@"获取网络状态失败");
}
#pragma mark - testgetAccessTokenByConditionWithUserName
- (void)testgetAccessTokenByConditionWithUserName {
     XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [_autoLoginVc getAccessTokenByConditionWithUserName:nil Content:nil andLoginType:1 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
     [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetAccessTokenByConditionWithUserName_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [_autoLoginVc getAccessTokenByConditionWithUserName:@"15868178826" Content:nil andLoginType:0 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetAccessTokenByConditionWithUserName_2 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [_autoLoginVc getAccessTokenByConditionWithUserName:@"15868178826" Content:@"123qweqwe" andLoginType:2 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}
- (void)testgetAccessTokenByConditionWithUserName_3 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [_autoLoginVc getAccessTokenByConditionWithUserName:@"15868178826123abc" Content:@"123456" andLoginType:2 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetAccessTokenByConditionWithUserName_4 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [_autoLoginVc getAccessTokenByConditionWithUserName:@"15868178826" Content:@"123456" andLoginType:2 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testgetAccessTokenWithUserName
/**正常用例:username传空,loginType为1，默认UI：NO   无缓存，WAP协商Ks，签发token    期望resultCode:1000000*/
- (void)testgetAccessTokenWithUserName {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAccessTokenWithUserName:nil andLoginType:1 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 *	正常用例:username传空,loginType为1，默认UI：NO   无缓存，WAP协商Ks，签发token    期望resultCode:1000000
 */
- (void)testgetAccessTokenWithUserName_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAccessTokenWithUserName:nil andLoginType:2 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
//- (void)testgetAccessTokenWithUserName_2 {
//    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
//    [_autoLoginVc getAccessTokenWithUserName:nil andLoginType:3 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
//        [completionExpectation fulfill];
//        XCTAssertNotNil(paraments,@"获取成功");
//    } failBlock:^(NSDictionary *paraments) {
//        
//    }];
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//}
- (void)testgetAccessTokenWithUserName_3 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAccessTokenWithUserName:@"15868178826" andLoginType:1 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testgetAppPasswordByConditionWithUserName
- (void)testgetAppPasswordByConditionWithUserName {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAppPasswordByConditionWithUserName:nil Content:nil andLoginType:1 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetAppPasswordByConditionWithUserName_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAppPasswordByConditionWithUserName:@"15868178826" Content:@"123qwe" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识失败");
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}
- (void)testgetAppPasswordByConditionWithUserName_2 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAppPasswordByConditionWithUserName:@"15868178826" Content:@"123qwe" andLoginType:2 finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取身份标识成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
//- (void)testgetAppPasswordByConditionWithUserName_3 {
//    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
//    [_autoLoginVc getAppPasswordByConditionWithUserName:@"15868178826" Content:@"123456qwe" andLoginType:3 finishBlock:^(NSDictionary *paraments) {
//        [completionExpectation fulfill];
//        XCTAssertNotNil(paraments,@"获取身份标识成功");
//    } failBlock:^(NSDictionary *paraments) {
//        
//    }];
//    [self waitForExpectationsWithTimeout:5 handler:nil];
//}
#pragma mark - testgetAppPasswordWithUserName
- (void)testgetAppPasswordWithUserName {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAppPasswordWithUserName:@"15868178826" andLoginType:3  isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetAppPasswordWithUserName_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc getAppPasswordWithUserName:@"15868178826" andLoginType:1  isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"获取成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testregisterUserWithPhoneNo
- (void)testregisterUserWithPhoneNo {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc registerUserWithPhoneNo:nil passWord:@"123qwe" andValidCode:@"321412" finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"注册成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testregisterUserWithPhoneNo_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc registerUserWithPhoneNo:@"15858656776" passWord:@"123qwe" andValidCode:@"321412" finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"注册成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testresetPasswordWithPhoneNo
- (void)testresetPasswordWithPhoneNo {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc resetPasswordWithPhoneNo:@"" passWord:@"123qwe" andValidCode:@"876273" finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"修改密码成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testresetPasswordWithPhoneNo_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc resetPasswordWithPhoneNo:@"15868178826" passWord:@"123qwe" andValidCode:@"876273" finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"修改密码成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testchangePasswordWithPhoneNo
- (void)testchangePasswordWithPhoneNo {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc changePasswordWithPhoneNo:nil passWord:@"123qwe" andNewPSW:@"newPassword" finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"密码修改成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testchangePasswordWithPhoneNo_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc changePasswordWithPhoneNo:@"15868178826" passWord:@"123qwe1" andNewPSW:@"123qwe" finishBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"密码修改成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
#pragma mark - testcleanSSO
- (void)test_cleanSSO_1
{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];  //信号量,当等待运行完成or等待时间50秒，才会执行其他操作
    
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    
    BOOL result = [controller cleanSSO];
    [expectation fulfill];
    
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert(result == YES);  //断言
}



#pragma mark - testcleanSSOWithUserName
- (void)test_cleanSSO_2
{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];  //信号量,当等待运行完成or等待时间50秒，才会执行其他操作
    
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    
    BOOL result = [controller cleanSSOWithUserName:@"15868178826"];
    [expectation fulfill];
    
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert(result == YES);  //断言
}
#pragma mark - testcurrentEdition
//- (void)testcurrentEdition {
//    XCTAssertThrows([_autoLoginVc currentEdition],@"没有可编辑选项");
//}
#pragma mark - testcheckIsLocalNumberWith
- (void)testcheckIsLocalNumberWith {
    XCTAssertTrue([_autoLoginVc checkIsLocalNumberWith:@"15868178826"],@"当前登录手机号码不是为本机号码");
}
#pragma mark - testinitWithAppid
- (void)testinitWithAppid {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc initWithAppid:nil Appkey:APPKEY TimeoutInterval:2 finishBlock:^(NSDictionary *paraments) {
    } failBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"初始化成功");
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testinitWithAppid_1 {
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Expectations"];
    [_autoLoginVc initWithAppid:APPID Appkey:APPKEY TimeoutInterval:20 finishBlock:^(NSDictionary *paraments) {
        [completionExpectation fulfill];
        XCTAssertNotNil(paraments,@"初始化失败");
    } failBlock:^(NSDictionary *paraments) {
        
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _autoLoginVc = nil;
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
