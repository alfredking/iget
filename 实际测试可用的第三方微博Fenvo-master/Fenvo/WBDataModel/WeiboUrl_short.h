//
//  WeiboUrl_short.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUrl_short : NSObject
//url_short	string	短链接
@property (nonatomic, copy)NSString *url_short;
//url_long	string	原始长链接
@property (nonatomic, copy)NSString *url_long;
//type	int	链接的类型，0：普通网页、1：视频、2：音乐、3：活动、5、投票
@property (nonatomic, assign)NSUInteger type;
//result	boolean	短链的可用状态，true：可用、false：不可用。
@property (nonatomic, assign)Boolean result;
@end
