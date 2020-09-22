//
//  IDMPCustomUI.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/27.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callbackBlock)(void);

@interface IDMPCustomUI : UIView
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (strong,nonatomic) callbackBlock loginBlock;
@property (strong, nonatomic) callbackBlock getValidBlock;
@property (strong,nonatomic)callbackBlock loginWithValidBlock;

@end
