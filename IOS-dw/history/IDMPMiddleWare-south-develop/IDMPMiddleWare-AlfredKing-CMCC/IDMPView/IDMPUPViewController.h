//
//  IDMPUPViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 14/11/6.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^callbackBlock)(NSDictionary *paraments);

@interface IDMPUPViewController : UIViewController
@property (nonatomic, copy)     callbackBlock   callBlock;
@property (nonatomic, copy)     callbackBlock   callFailBlock;
@property (nonatomic, strong)   UIView          *customV;

- (instancetype)init;

- (void)showInView:(UIViewController *)superV placedUserName:(NSString *)userName callBackBlock:(callbackBlock)successBlock callFailBlock:(callbackBlock)failBlock;

- (void)dismissView;

@end
