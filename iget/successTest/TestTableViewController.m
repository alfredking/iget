//
//  TestTableViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/9/4.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestCustomTableViewCell.h"
@interface TestTableViewController ()

@end

NSString *reuseIdentifier = @"TestTableViewController";

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [[NSMutableArray alloc]init];
    for(int i =0;i<300;i++)
    {
        [self.dataList addObject:[NSString stringWithFormat:@"%d",i]];
    }

    [self.tableView registerClass:[TestCustomTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView reloadData];
    
    NSDictionary *dic =   @{@"token":@"test",@"expires_in":@"uid"};
    [self  setIconImageUrl:dic];
    
}

// 根据外部数据更新左图
- (void)setIconImageUrl:(NSString *)iconImageUrl{
    NSLog(@"iconImageUrl is %@",iconImageUrl);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell)
    {
        NSLog(@"cell is %@",cell);
        cell.textLabel.text=[NSString stringWithFormat:@"%@",self.dataList[indexPath.row]];
        [cell updateCellAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview =[[UIView alloc]init];
    headerview.backgroundColor = [UIColor redColor];
    return headerview;
}


-(void)dealloc
{
    NSLog(@"TestTableViewController dealloc called");
}
@end
