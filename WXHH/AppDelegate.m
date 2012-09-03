//
//  AppDelegate.m
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ModelWXHH.h"
#import "GameViewController.h"
#import "CALayer+Animation.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize state;

- (void)changeState:(int)nextState
{    
    if (state==nextState) {
        return;
    }
    
    NSArray *array = [NSArray arrayWithObjects:
                      @"MainViewController",
                      @"GameViewController",
                      @"HelpViewController",
                      nil];
    
    NSString *className = [array objectAtIndex:nextState];
    Class class =  NSClassFromString(className);
    
    [vc.view.layer removeAllAnimations];
    [vc.view removeFromSuperview];
    [vc release];
    vc = [[class alloc] initWithNibName:className bundle:nil];
    
    [self.window addSubview:vc.view];
    
    [self.window.layer transitionOglFlipByDirection:2];
    
    
    state = nextState;

}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [UIColor blackColor];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    state = AppStateLaunch;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:bounds] autorelease];
    // Override point for customization after application launch.
    
    [self changeState:AppStateMain];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ModelWXHH sharedInstance] autosave];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    ModelWXHH *model = [ModelWXHH sharedInstance];
    [ud setObject:[NSNumber numberWithInt:model.money] forKey:@"UserMoney"];
    [ud synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ModelWXHH sharedInstance] autosave];
}

@end
