//
//  ViewController.h
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboViewController : UIViewController<UIWebViewDelegate>
@property(strong, nonatomic)UIWebView *loginView;
@property(strong, nonatomic)NSString *access_token;
@end

