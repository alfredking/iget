//
//  IDMPPopTool.h
//  IDMPCMCC
//
//  Created by wj on 2017/7/19.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^completeBlock)(NSDictionary *parameters);

@interface IDMPPopTool : NSObject

@property (nonatomic, strong) UIColor *popBackgroundColor;
@property (nonatomic, assign) BOOL tapOutsideToDismiss;

/**
 create a shared instance
 @return IDMPPopTool
 */
+ (IDMPPopTool *)sharedInstance;

- (void)showWithPresentViewController:(UIViewController *)presentViewController completion:(completeBlock)completion animated:(BOOL)animated;
@end
