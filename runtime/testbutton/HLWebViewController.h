//
//  HLWebViewController.h
//  HYZBLive
//
//  Created by 徐培帅 on 2017/7/17.
//  Copyright © 2017年  . All rights reserved.
//

#import <UIKit/UIKit.h>


//来源类型
typedef NS_ENUM (NSInteger,HLSourceType) {
   
   homeBannerSource = 1,

};

@interface HLWebViewController : UIViewController

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *html;

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, assign) BOOL browserHeadDisplay; //是否展示标题栏

@property (nonatomic, assign) NSInteger type; //0 默认正常、 1 是弹窗 、 2活动链接 、3游戏 4、点播

@property (nonatomic, assign) HLSourceType sourceType;

@property (nonatomic, copy) NSString * activityId; //活动Id

- (instancetype)initWithUrl:(NSString *)url;

@end
