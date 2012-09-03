//
//  Model.h
//  CountYourMoney
//
//  Created by Chen Weigang on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern int minute;
//extern int second;

@interface Model : NSObject


@property (nonatomic, assign) int totalMoney;
@property (nonatomic, assign) int level; // 0-3 current lv

+(Model *)sharedModel;

- (BOOL)isLevelLocked:(int)lv;

- (void)save;
- (void)load;
@end
