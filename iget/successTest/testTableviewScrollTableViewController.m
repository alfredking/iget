//
//  testTableviewScrollTableViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/6/5.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testTableviewScrollTableViewController.h"

@interface testTableviewScrollTableViewController ()

@end

@implementation testTableviewScrollTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"self.tableView is %@",self.tableView);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testTableviewScroll"];
//    [self.tableView reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:35 inSection:0];
//    NSLog(@"current thread is %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    NSLog(@"inside current thread is %@",[NSThread currentThread]);
    });
    [self.tableView reloadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testTableviewScroll" forIndexPath:indexPath];
    if (cell) {
        NSLog(@"cell is %@",cell);
        cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    }
    else
    {
        NSLog(@"create new cell");
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testTableviewScroll"];
    }
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.backgroundColor = [UIColor greenColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];;
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.text = @"header";
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    return titleLabel;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 25;
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
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
