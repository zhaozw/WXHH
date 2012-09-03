//
//  HelpViewController.m
//  WXHH
//
//  Created by Chen Weigang on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "AppDelegate.h"
#import "GameAudio.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    [pc setCurrentPage:offset.x/320];
}

- (IBAction)pressBack
{
    [GameAudio playSoundEffect:@"界面切换.mp3"];
    
    if (isHelpVCPresent) {
        [self dismissModalViewControllerAnimated:YES];
        isHelpVCPresent = YES;
    }
    else {        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate changeState:AppStateMain];
        isHelpVCPresent = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"YES" forKey:@"IsHelpViewShowed"];
    [ud synchronize];
    
    sv.contentSize = CGSizeMake(960, 388);
    sv.pagingEnabled = YES;
    sv.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
