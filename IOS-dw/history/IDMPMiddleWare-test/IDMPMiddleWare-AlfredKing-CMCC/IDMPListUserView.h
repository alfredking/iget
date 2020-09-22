//
//  IDMPListUserView.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/12/4.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBlock)(NSDictionary *paraments);

@interface IDMPListUserView : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *userInfoArr;
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)callBlock callBack;
@property (nonatomic,strong)UIViewController *superVC;
- (instancetype)init;

- (void)showInView:(UIViewController *)superVC;

- (void)dismissView;

+ (instancetype)sharedView;

@end
