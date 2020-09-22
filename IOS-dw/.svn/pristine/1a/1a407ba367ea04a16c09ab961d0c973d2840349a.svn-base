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
#import "IDMPToken.h"


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
    for(int i=0;i<1;i++)
    {
        [autoLogin getAccessTokenWithUserName:@"15868178826" andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
            
            NSLog(@"%@",paraments);
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr
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
                                        NSLog(@"%@",paraments);
                                        
                                    }];
        
        
    }
}
- (IBAction)tokenCondition:(id)sender {
    
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    for(int i=0;i<1;i++)
    {
        
        [autoLogin getAccessTokenByConditionWithUserName:@"15868178826" Content:@"123456qwe" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
            NSLog(@"%@",paraments);
            NSString *tokenStr = [paraments objectForKey:@"token"];
            
            [IDMPToken checkToken:tokenStr
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

- (IBAction)passwordUI:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    
    for(int i=0;i<1000;i++)
    {

    [autoLogin getAppPasswordWithUserName:@"18867101271" andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        NSString *tokenStr = [paraments objectForKey:@"token"];
        
        [IDMPToken checkToken:tokenStr
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
    [autoLogin getAppPasswordByConditionWithUserName:@"18867101271" Content:@"120647ak"andLoginType:1 finishBlock:^(NSDictionary *paraments)
     {
         NSLog(@"test %@",paraments);
         NSString *tokenStr = [paraments objectForKey:@"token"];
         
         [IDMPToken checkToken:tokenStr
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

- (IBAction)clearCache:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin cleanSSO];
}
- (IBAction)accountManager:(id)sender {
    IDMPRegisterViewController *accountController = [[IDMPRegisterViewController alloc]init];
    [self presentViewController:accountController animated:YES completion:nil];
}

- (IBAction)presentTest2:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin currentEdition];
    
   }


@end
