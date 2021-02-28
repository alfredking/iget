//
//  HistoryVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "HistoryVC.h"
#import "JHCusomHistory.h"

@interface HistoryVC ()
@property (nonatomic, strong) JHCusomHistory *history;
@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加历史记录视图
    self.history.searchKey = @"45678";
    self.history.searchKey = @"sx";
    self.history.searchKey = @"2345ydfc";
    self.history.searchKey = @"oiudc1234";
    self.history.searchKey = @"456yhbcx";
    
    [self.view addSubview:self.history];
}

#pragma 历史记录相关
- (JHCusomHistory *)history{
    if (!_history) {
//        __weak typeof(self) weakSelf = self;
        JHCusomHistory *history = [[JHCusomHistory alloc] initWithFrame:CGRectMake(0, 200, 400, 200) maxSaveNum:5 fileName:@"parkingHistorySearch.data" andItemClickBlock:^(NSString *keyword) {
            NSLog(@"~~~~%@",keyword);
        }];
        history.backgroundColor = [UIColor purpleColor];
        _history = history;
    }
    return _history;
}
@end
