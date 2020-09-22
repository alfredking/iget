//
//  IDMPTestViewController.m
//  testlib
//
//  Created by zwk on 14/11/28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTestViewController.h"
#import "IDMPTempSmsMode.h"
#import "IDMPRegisterViewController.h"
#import "secTokenCheck.h"


@interface IDMPTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *smscode;
@end


@implementation IDMPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tokenUI:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    secTokenCheck *tokencheck = [[secTokenCheck alloc]init];
    for(int i=0;i<1;i++)
    {
        [autoLogin getAccessTokenWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {

                NSLog(@"tokenUI %@",paraments);
        NSString *tokenStr = [paraments objectForKey:@"token"];
        [tokencheck checkToken:tokenStr
        successBlock:^(NSDictionary *dic)
        {
            NSLog(@"token validate=%@",dic);
            
        }
        failBlock:^(NSDictionary *dic)
        {
            NSLog(@"token validate fail %@",dic);
        }];

        }
        failBlock:^(NSDictionary *paraments) {
                NSLog(@"tokenUI fail %@",paraments);
                
            }];
        
       
        
       
    }
    
//    NSThread *tokenThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(tokenCondition) object:nil];
//    [tokenThreadone setName:@"Thread-1"];
//    [tokenThreadone start];
//    
//    
//    NSThread *tokenThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(tokenCondition) object:nil];
//    [tokenThreadtwo setName:@"Thread-2"];
//    [tokenThreadtwo start];
}
- (IBAction)tokenCondition:(id)sender {
//- (void)tokenCondition
//{

    
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    secTokenCheck *tokencheck = [[secTokenCheck alloc]init];
    for(int i=0;i<1;i++)
    {

    [autoLogin getAccessTokenByConditionWithUserName:@"18758559687" Content:@"120647ak" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
         NSString *tokenStr = [paraments objectForKey:@"token"];
        
        [tokencheck checkToken:tokenStr
                 successBlock:^(NSDictionary *dic)
         {
             NSLog(@"token validate success test=%@",dic);
             
         }
                    failBlock:^(NSDictionary *dic)
         {
             NSLog(@"token validate fail test%@",dic);
         }];
        

    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
    }
}

- (IBAction)passwordUI:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    secTokenCheck *tokencheck = [[secTokenCheck alloc]init];
    for(int i=0;i<1;i++)
    {
    [autoLogin getAppPasswordWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"passwordUI%@",paraments);
        NSString *tokenStr = [paraments objectForKey:@"token"];
        
        [tokencheck checkToken:tokenStr
        successBlock:^(NSDictionary *dic)
         {
             NSLog(@"token validate=%@",dic);
             
         }
         failBlock:^(NSDictionary *dic)
         {
             NSLog(@"token validate fail %@",dic);
         }];
        

    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
    }
}
- (IBAction)passwordCondition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    secTokenCheck *tokencheck = [[secTokenCheck alloc]init];
    for(int i=0;i<10;i++)
    {
    [autoLogin getAppPasswordByConditionWithUserName:@"18867101277" Content:@"hong123"andLoginType:1 finishBlock:^(NSDictionary *paraments)
     {
         NSLog(@"count i %d test %@",i,paraments);
         NSString *tokenStr = [paraments objectForKey:@"token"];
         //NSString *tokenStr = @"8484010001320200344F445A44517A517A516A4D314E7A52434E6A64424D546C4640687474703A2F2F3231312E3133362E31302E3133313A383038302F03000401C17689040006303031303032FF002032C39C3EEFF090E15B41E37CC2FB68D97A05F5E3508F082CB4AAA10D07ED6275";
         
         [tokencheck checkToken:tokenStr
                  successBlock:^(NSDictionary *dic)
          {
              NSLog(@"count i %d token validate=%@",i,dic);
              
          }
          failBlock:^(NSDictionary *dic)
          {
              NSLog(@"count i %d token validate fail %@",i,dic);
          }];
         
         
     } failBlock:^(NSDictionary *paraments) {
         NSLog(@"count i %d fail %@",i,paraments);
     }];
    }
}

- (IBAction)getSms:(id)sender
{
    IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
    [tmpSms getSmsCodeWithUserName:self.username.text busiType:@"3" successBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码成功:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码失败:%@",paraments);
    }];

}

- (IBAction)tempSms:(id)sender
{
       IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
      [tmpSms getTMKSWithUserName:self.username.text messageCode:self.smscode.text successBlock:^(NSDictionary *paraments) {
            NSLog(@"登录成功:%@",paraments);
        } failBlock:^(NSDictionary *paraments) {
            NSLog(@"登录失败:%@",paraments);
        }];
    

}

- (IBAction)clearCache:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin cleanSSO];
}
- (IBAction)accountManager:(id)sender {
    IDMPRegisterViewController *accountController = [[IDMPRegisterViewController alloc]init];
    [self presentViewController:accountController animated:YES completion:nil];
}

- (IBAction)currentEdition:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    
    [autoLogin checkIsLocalNumberWith:@"18758559687" finishBlock:^(NSDictionary *paraments) {
        NSLog(@"success paraments is %@",paraments);
        NSString *resut=[paraments objectForKey:@"resultCode"];
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail paraments is %@",paraments);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
