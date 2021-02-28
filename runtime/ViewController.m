//
//  ViewController.m
//  testbutton
//
//  Created by 大碗豆 on 17/4/11.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "ViewController.h"
#import "EFButton.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *controlArr;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    EFButton *btn = [EFButton new];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 600, 140, 60);
    [btn setTitle:@"客服服务" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"qwas.png"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = @[@"数组字符串数据处理",@"动态方法调用",@"车牌键盘",@"加载转圈",@"历史记录展示",@"图片浏览",@"label搜索条件展示",@"不限制内容弹窗提示",@"tab弹窗单选",@"keep动画",@"日历自定义",@"控制连续跳转返回",@"文字滚动",@"涂鸦测试",@"图片旋转",@"打电话方式",@"改变系统弹窗字体颜色",@"简单加载转圈",@"照片选择",@"控制器视图设置为弹窗",@"照片选择上传",@"百叶窗",@"自定义字体",@"block学习",@"runTime学习"];
    self.controlArr = @[@"ArrayHandelVC",@"DynamicMethodVC",@"LicensePlateVC",@"LoadingViewVC",@"HistoryVC",@"ImagebrowseVC",@"SelectLabelShowVC",@"ANPopoverVC",@"TabAloneSelectVC",@"KeepLaunchAnimationVC",@"CalendarCustomVC",@"alertviewViewController",@"LabelScrlllVC",@"ScrawlViewController",@"ImagRotateVC",@"CallNumberVC",@"ChangesystemalertviewVC",@"TestLoadingRotateVC",@"PickImageVC",@"VCViewSetAlertView",@"imagePickerViewController",@"BlindAnimationVC",@"ChangeFontVC",@"BlockTestViewController",@"runTimeVC"];
    self.title = @"首页";
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleName = self.dataArr[indexPath.row];
    NSString *VCName = self.controlArr[indexPath.row];
    Class contrName = NSClassFromString(VCName);
    UIViewController *VC = [[contrName alloc] init];
    VC.title = titleName;
    [self.navigationController pushViewController:VC animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - TABBAR_SPACE) style:(UITableViewStylePlain)];
            tab.rowHeight = 50;
            tab.dataSource = self;
            tab.delegate = self;
            tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            tab.backgroundColor = [UIColor whiteColor];
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            tab;
        });
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.backgroundColor = ANYColorRandom;
    NSString *titleName = self.dataArr[indexPath.row];
    NSString *VCName = self.controlArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@~~%@",titleName,VCName];
    return cell;
}

- (void)btnAction:(UIButton *)btn{
    
}

- (void)removeAllSubviews{
    //要删除当前View的所有子View下面一行代码即可搞定
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
