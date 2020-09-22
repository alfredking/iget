//
//  IDMPListUserView.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/12/4.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPListUserView.h"
#import "IDMPConst.h"
#import "IDMPUPViewController.h"

#define MAX_HEIGHT 210.0

static IDMPListUserView *m_listV;

@implementation IDMPListUserView

+ (instancetype)sharedView
{
    if (m_listV == nil)
    {
        m_listV = [[IDMPListUserView alloc]init];
    }
    return m_listV;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    _tableV = [[UITableView alloc]init];
    _tableV.center = self.view.center;
    _tableV.rowHeight = 30.0;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.layer.cornerRadius = 5;
    _tableV.sectionFooterHeight = 30.0;
    _tableV.sectionHeaderHeight = 30.0;
    self.view.backgroundColor = [UIColor lightGrayColor];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (30*(self.userInfoArr.count+2)<MAX_HEIGHT)
    {
        self.tableV.bounds = CGRectMake(0, 0, self.view.bounds.size.width/2, 30*(self.userInfoArr.count+2));
    }
    else
    {
        self.tableV.bounds = CGRectMake(0, 0, self.view.bounds.size.width/2, MAX_HEIGHT);
    }
}

- (void)showInView:(UIViewController *)superVC
{
    NSLog(@"--%@",self.userInfoArr);
    self.superVC = superVC;
    [self.view addSubview:_tableV];
    [superVC presentViewController:self animated:YES completion:nil];
}

- (void)dismissView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userInfoArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"选择账号";
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 160, 40);
    [button setTitle:@"其他登录方式>>" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)onBtnClick
{
    NSLog(@"click");
    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
    [upView showInView:self placedUserName:nil callBackBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissView];
        });
        
    } callFailBlock:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _userInfoArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *userName = cell.textLabel.text;
    NSDictionary *parament = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName", nil];
    if (self.callBack)
    {
        self.callBack(parament);
    }
    NSLog(@"userName:%@",userName);
    [self dismissView];
}

@end
