////
////  UnsubscibePromptView.m
////  IDMPCMCC
////
////  Created by wj on 2017/12/2.
////  Copyright © 2017年 zwk. All rights reserved.
////
//
//#import "UnsubscibePromptView.h"
//#import "UnsubscribePromptTableViewCell.h"
//#import "UIColor+Hex.h"
//#import "IDMPScreen.h"
//#import "IDMPValidateCodeNaviView.h"
//
//static NSString *unsubscribePromptCellIdentifier = @"unsubscribePromptCellIdentifier";
//
//
//@interface UnsubscibePromptView()<UITableViewDataSource, UITableViewDelegate>
//
//@property (nonatomic, strong)IDMPValidateCodeNaviView *naviView;
//@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)UIView *headerView;
//@property (nullable, nonatomic, strong) UIWindow *window;
//@property (nonatomic, strong)NSArray *itemArray;
//@property (nonatomic, strong)NSArray *detailArray;
//@property (nonatomic, copy)voidBlcok closeBlock;
//@property (nonatomic, strong)NSDictionary *configureColorDic;
//
//
//@end
//
//@implementation UnsubscibePromptView
//
//- (instancetype)initWithStatusArr:(NSArray *)arr CloseHandler:(voidBlcok)handler {
//    if (self = [super init]) {
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FreeFlowConfigure" ofType:@"plist"];
//        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//        self.configureColorDic = data;
//        [self setup];
//        self.itemArray = @[@"绑定手机号码",@"套餐有效期",@"退订时间",@"办理日期"];
//        self.detailArray = arr;
//        self.closeBlock = handler;
//
//    }
//    return self;
//}
//
//- (void)show {
//    UIViewController *viewController = [UIViewController new];
//    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.windowLevel = UIWindowLevelNormal;
//    
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
//    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
//    [closeItem setTintColor:[UIColor colorWithHexString:self.configureColorDic[@"unsubscribeNaviCloseBtnColor"]]];
//    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"4G+终端定向流量120G免费送" style:UIBarButtonItemStylePlain target:self action:nil];
//    [titleItem setTintColor:[UIColor colorWithHexString:self.configureColorDic[@"unsubscribeNaviTitleColor"]]];
//    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedItem.width = -16;
//    viewController.navigationItem.leftBarButtonItems = @[closeItem,titleItem];
//    [viewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:self.configureColorDic[@"unsubscribeNaviBgColor"]]];
//    viewController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    
//    window.rootViewController = navi;
//    [window makeKeyAndVisible];
//    self.window = window;
//    
//    [viewController.view addSubview:self];
//    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
//    NSLayoutConstraint *alertCenterX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//
//    NSLayoutConstraint *alertLeft = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    NSLayoutConstraint *alertTop = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:64];
//    NSLayoutConstraint *alertBottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    [viewController.view addConstraints:@[alertCenterX,alertBottom,alertLeft,alertTop]];
//    
//    [self.window layoutIfNeeded];
//}
//
//- (void)close {
//    [self removeFromSuperview];
//    self.window.rootViewController = nil;
//    self.window.hidden = YES;
//    self.window = nil;
//    self.closeBlock();
//}
//
//- (void)setup {
//    self.backgroundColor = [UIColor colorWithHexString:self.configureColorDic[@"unsubscirbeBgColor"]];
//    
//    [self addSubview:self.tableView];
//    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    NSLayoutConstraint *tableViewCenterX = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//    NSLayoutConstraint *tableViewCenterY = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//    NSLayoutConstraint *tableViewLeft = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    [self addConstraints:@[tableViewTop,tableViewLeft,tableViewCenterX,tableViewCenterY]];
//    
//}
//
//
//
//#pragma mark - UITableViewDataSource & UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 15 * IDMPWidthScale;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UnsubscribePromptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unsubscribePromptCellIdentifier];
//    if (!cell) {
//        if (indexPath.section == 1) {
//            cell = [[UnsubscribePromptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unsubscribePromptCellIdentifier detailtype:DetailButtion];
//        } else {
//            cell = [[UnsubscribePromptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unsubscribePromptCellIdentifier detailtype:DetailLabel];
//        }
//    }
//    cell.itemLabel.text = self.itemArray[indexPath.section];
//    if (indexPath.section == 1) {
//        [cell.detailButton setTitle:self.detailArray[indexPath.section] forState:UIControlStateNormal];
//    } else {
//        cell.detailLabel.text = self.detailArray[indexPath.section];
//    }
//    if (indexPath.section == 2) {
//        [cell setItemLblColor:self.configureColorDic[@"unsubscribeCellItemColor2"] detailLblColor:self.configureColorDic[@"unsubscribeCellItemColor2"] btnBgColor:self.configureColorDic[@"unsubscribeCellBtnBgColor"] btnTitleColor:self.configureColorDic[@"unsubscribeCellBtnTitleColor"]];
//    } else {
//        [cell setItemLblColor:self.configureColorDic[@"unsubscribeCellItemColor1"] detailLblColor:self.configureColorDic[@"unsubscribeCellDetailColor"] btnBgColor:self.configureColorDic[@"unsubscribeCellBtnBgColor"] btnTitleColor:self.configureColorDic[@"unsubscribeCellBtnTitleColor"]];
//    }
//    return cell;
//}
//
//#pragma mark -lazy load
//- (UITableView *)tableView {
//    if (!_tableView) {
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];;
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        tableView.rowHeight = 56 * IDMPWidthScale;
//        tableView.tableFooterView = [UIView new];
//        tableView.tableHeaderView = self.headerView;
//        tableView.backgroundColor = [UIColor clearColor];
//        //适配iOS11，不然无法进入高度回调
//        tableView.sectionHeaderHeight = 0;
//        tableView.sectionFooterHeight = 0;
//        tableView.estimatedRowHeight = 0;
//        
//        _tableView = tableView;
//    }
//    return _tableView;
//}
//
//- (UIView *)headerView {
//    if (!_headerView) {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 188)];
//        headerView.backgroundColor = [UIColor whiteColor];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IDMPCMCC.bundle/icon_bigFlow"]];
//        [headerView addSubview:imageView];
//        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        NSLayoutConstraint *imgCenterX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//        NSLayoutConstraint *imgCenterY = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//        NSLayoutConstraint *imgHeight = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:151 * IDMPWidthScale];
//        NSLayoutConstraint *imgWidth = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:288 * IDMPWidthScale];
//        [imageView addConstraints:@[imgWidth,imgHeight]];
//        [headerView addConstraints:@[imgCenterX,imgCenterY]];
//        _headerView = headerView;
//    }
//    return _headerView;
//}
//@end

