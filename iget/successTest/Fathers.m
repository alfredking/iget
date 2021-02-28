//
//  Father.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/29.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "Fathers.h"

@implementation Fathers

//@synthesize name;
//@synthesize old;
-(id)copyWithZone:(NSZone *)zone
{
    Fathers *fa =[[Fathers alloc]init];
    fa.name = self.name;
    fa.old=self.old;
    return fa;
}
@end
