//
//  Model.m
//  CountYourMoney
//
//  Created by Chen Weigang on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"

static Model *instance = nil;

@implementation Model

@synthesize totalMoney;
@synthesize level;

+(Model *)sharedModel{
    
    @synchronized(self){
        if (instance==nil) {                
            instance = [[Model alloc] init];// assignment not done here
            [instance load];
        }
    }
    
    return instance;
}

- (void)save
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithInt:totalMoney] forKey:@"TotalMoney"];
}

- (void)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    totalMoney = [[ud objectForKey:@"TotalMoney"] intValue];
}

- (BOOL)isLevelLocked:(int)lv 
{
    if (lv==0) {
        return NO;
    }
    else if (lv==1 && totalMoney>=500) {
        return NO;
    }
    else if (lv==2 && totalMoney>=5000) {
        return NO;
    }
    else if (lv==3 && totalMoney>=20000) {        
        return NO;
    }
    
    return YES;
}

@end
