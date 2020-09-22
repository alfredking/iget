//
//  testTableViewController.m
//  上下滚动
//
//  Created by alfredking－cmcc on 2019/8/12.
//  Copyright © 2019 chinajes. All rights reserved.
//p134 tableview

#import "testTableViewController.h"
#import "TestBezierPathViewController.h"
@interface testTableViewController ()

@end

@implementation testTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"此时TabbleView contentSize 值== %@",  NSStringFromCGSize(self.tableView.contentSize));
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"%s",__FUNCTION__);
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTableViewCell"];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    cell.textLabel.textColor = [UIColor blackColor];
    
    NSLog(@"%s",__FUNCTION__);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//根据文字设置高度 https://www.jianshu.com/p/fa0288a18ede
//    //    模拟的数据
//    if (indexPath.row % 2) {
//
//        self.temCell.contentLab.text = @"我们睡觉族自然也没闲着，每天早晨从中午开始，当一天和尚撞一天钟或者干脆连钟都不撞。上厕所、吃饭，看NBA、打篮球，上网、约会；各有各的一份事做。天天如此，日子也就在这些单调无聊的事情中被消耗。回过头来看看强哥，那才真叫一个收获满满。拿到了国家英语四六级证书，计算机二级证书，普通话一级乙等证书等各类证书，国家奖学金，以及保送研究生的资格。";
//    }else{
//        self.temCell.contentLab.text = @"除了这些能看得到的收获，强哥还有一件更牛逼的本领，那就是精通计算机。组装，修理，装系统，制作表格，处理照片，以及各类软件，均不在话下。因此，他想找份工作，易如反掌因此";
//    }
//
//    //    先确定label的最大宽度，根据自己需求确定宽度
//    CGFloat preMaxWaith = SCREENWIDTH - 96;
//    [self.temCell.contentLab setPreferredMaxLayoutWidth:preMaxWaith];
//
//    //    直接返回cellsize，最后+1，是cell分割线的高度
//    CGSize cellSize = [self.temCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return cellSize.height + 1;
    NSLog(@"%s",__FUNCTION__);
    return 200;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//
//    NSLog(@"%s",__FUNCTION__);
//    return 300;
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath is %@",indexPath);
    switch (indexPath.row) {
        case 0:
        {
            
            TestBezierPathViewController *testBezier = [[TestBezierPathViewController alloc] init];
            [self.navigationController pushViewController:testBezier animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"table ContentSize %@",  NSStringFromCGSize(scrollView.contentSize));
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
