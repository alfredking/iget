//
//  ViewController.m
//  testIOS
//
//  Created by alfredking－cmcc on 2021/3/22.
//

#import "ViewController.h"
#import "UserConfig.h"
#import "SychronizeConfig.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SychronizeConfig *sychronizeConfig = [[SychronizeConfig alloc]init];
    UserConfig *userConfig =[[UserConfig alloc]init];
    
    [userConfig addObserver:sychronizeConfig forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    userConfig.font =[NSMutableString stringWithFormat: @"3"];
    userConfig.font =[NSMutableString stringWithFormat: @"5"];
    
    
    
    NSLog(@"finish");
}


@end
