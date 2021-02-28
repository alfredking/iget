//
//  TabAloneSelectVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "TabAloneSelectVC.h"
#import "tabViewSelect.h"

@interface TabAloneSelectVC ()
@property (nonatomic,strong)tabViewSelect *tabViewSelect;
@end

@implementation TabAloneSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self selectTabViewCell];
}

#pragma mark TableView单选
- (void)selectTabViewCell{
    self.tabViewSelect = [[tabViewSelect alloc] init];
    self.tabViewSelect.selecTitle = @"tabViewSelect单选";
//    __weak typeof(self) weakSelf = self;
    NSArray *allArr = @[@"不限",@"以后再告诉你",@"与父母同住",@"租房",@"已购房（有贷款）",@"已购房（无贷款）",@"住单位房",@"住亲朋家",@"需要时购置"];
    self.tabViewSelect.dataArr = allArr;
    self.tabViewSelect.config = ^(NSString *contentTitle){
        NSLog(@"%@",contentTitle);
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.tabViewSelect];
}

@end
