//
//  UIViewController+Standard.h
//  LSArchitecture
//
//  Created by 王隆帅 on 17/3/3.
//  Copyright © 2017年 王隆帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSUIStandardProtocol.h"
#import "LSVMUIBridgeProtocol.h"
#import "LSBaseViewControllerProtocol.h"

@interface UIViewController (Standard) <LSUIStandardProtocol,LSVMUIBridgeProtocol,LSBaseViewControllerProtocol>

@end
