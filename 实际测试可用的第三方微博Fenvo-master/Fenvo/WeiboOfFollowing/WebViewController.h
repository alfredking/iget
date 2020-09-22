//
//  WebViewController.h
//  Fenvo
//
//  Created by Caesar on 15/5/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
- (void)initWithLink:(NSString *)linkAdr;
@end
