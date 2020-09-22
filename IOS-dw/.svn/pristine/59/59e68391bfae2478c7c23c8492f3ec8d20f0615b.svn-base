//
//  IDMPReAuthViewController.h
//  IDMPCMCC
//
//  Created by wj on 2017/7/19.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^accessBlock)(NSDictionary *paraments);

typedef NS_ENUM(NSInteger,IDMPReAuthType) {
    IDMPReAuthSetCode,
    IDMPReAuthValidateCode
};

@interface IDMPReAuthViewController : UIViewController
@property (nonatomic, copy) void(^returnBlcok)(NSDictionary *parameters);
@property (nonatomic, assign) IDMPReAuthType authType;
@property (nonatomic, strong) NSString *forgetPwdDesc;

- (instancetype)initWithUserName:(NSString *)userName;

- (void)requestReAuthStatusWithUsername:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
@end
