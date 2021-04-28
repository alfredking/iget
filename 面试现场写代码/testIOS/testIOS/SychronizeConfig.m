//
//  SychronizeConfig.m
//  testIOS
//
//  Created by alfredking－cmcc on 2021/3/22.
//

#import "SychronizeConfig.h"
#import "UserConfig.h"

@implementation SychronizeConfig

-(instancetype)init
{
    self =[super init];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (context == <#context#>) {
//        <#code to be executed upon observing keypath#>
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
    
    
    if ([keyPath isEqualToString:@"font"]) {
        NSLog(@"font changed");
        NSLog(@"new value is %@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
    else
    {
        NSLog(@"other variable changed");
    }
}

@end
