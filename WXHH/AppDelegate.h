//
//  AppDelegate.h
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHHUtil.h"

typedef enum {
    AppStateLaunch  = -1,
    AppStateMain    = 0,
    AppStateGame   = 1,
    AppStateHelp = 2,
}AppState;


int showIndex;

@class GameViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIViewController *vc;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int state;


- (void)changeState:(int)nextState;

@end
