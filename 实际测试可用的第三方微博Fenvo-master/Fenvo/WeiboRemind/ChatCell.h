//
//  ChatCell.h
//  Fenvo
//
//  Created by Caesar on 15/6/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboAvatarView.h"

@interface ChatCell : UITableViewCell
@property (strong, nonatomic) IBOutlet WeiboAvatarView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *chat_description;

@end
