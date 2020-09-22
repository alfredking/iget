//
//  IDMPKsModel.h
//  IDMPCMCC
//
//  Created by HGQ on 16/3/30.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UMCSDKCallBack)(id result);

@interface IDMPKsModel : NSObject

+ (void)renewKsWithAppid:(NSString *)appid appkey:(NSString *)appkey certID:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack;

+ (void)getToken:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack;

@end
