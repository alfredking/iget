//
//  ChangeFontVC.m
//  testbutton
//
//  Created by lmcqc on 2020/11/9.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ChangeFontVC.h"

@interface ChangeFontVC ()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@end

@implementation ChangeFontVC

- (void)viewDidLoad {
    [super viewDidLoad];
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"Font FamilyName = %@",familyName); //输出字体族科名字
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"\t%@",fontName);         //输出字体族科下字样名字
        }
    }
//
//    _myLabel.font = [UIFont fontWithName:@"FZLBJW--GB1-0" size:17.0f];
//    _myButton.titleLabel.font = [UIFont fontWithName:@"FZLBJW--GB1-0" size:17.0f];
//    _myLabel.tag = 10086;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
