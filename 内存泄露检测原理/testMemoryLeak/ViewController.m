//
//  ViewController.m
//  testMemoryLeak
//
//  Created by alfredking－cmcc on 2021/3/6.
//

#import "ViewController.h"
#import "FirstViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor yellowColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches");
    FirstViewController *firstVC=[[FirstViewController alloc]init];
    [self.navigationController pushViewController:firstVC animated:YES];
}
@end
