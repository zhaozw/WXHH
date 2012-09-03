//
//  MainViewController.m
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "CardView.h"
#import "ModelWXHH.h"
#import "GameAudio.h"
#import "HelpViewController.h"
#import "WXHH.h"


@interface MainViewController ()
- (void)addFireView;
- (void)removeFireView;
@end

@implementation MainViewController

# pragma mark - press event

- (IBAction)pressMenu:(id)sender
{
    [GameAudio playSoundEffect:@"界面切换.mp3"];
    
    UIButton *btn = sender;
    switch (btn.tag) {
        case 0:
            [self pressRate];
            break;
        case 1:
            [self removeFireView];
            [GameAudio stopBgMusic];
            [self performSelector:@selector(pressStartGame) withObject:nil afterDelay:0.1f];
            break;
        case 2:
            [self removeFireView];
            [GameAudio stopBgMusic];
            [self performSelector:@selector(pressHelp) withObject:nil afterDelay:0.1f];
            break;
    }
}

- (void)pressRate
{
    NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", APP_ID];        
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (void)pressStartGame
{   
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate changeState:AppStateGame];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)pressHelp
{    
    isHelpVCPresent = NO;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate changeState:AppStateHelp];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (IBAction)pressShowSocialButton
{    
    if (viewSocialBg.frame.size.height==1) {
        [UIView animateWithDuration:0.25f animations:^{
            viewSocialBg.alpha = 1.f;
            viewSocialBg.frame = CGRectMake(273, 35, 43, 213);
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.25f animations:^{
            viewSocialBg.alpha = 0.f;
            viewSocialBg.frame = CGRectMake(273, 35, 43, 1);
        } completion:^(BOOL finished) {
        }];
    }
}

- (IBAction)pressSocialButton:(id)sender
{
}

# pragma mark - methods

- (void)addFireView
{
    if (isParticleSupported()) {
        fireView0 = [[FireView alloc] initWithFrame:CGRectMake(110, 95, 100, 280)];
        [self.view insertSubview:fireView0 belowSubview:imgWXHH];
        
        fireView1 = [[FireView alloc] initWithFrame:CGRectMake(110, 95, 100, 280)];
        [self.view insertSubview:fireView1 belowSubview:imgWXHH];
        
        [UIView animateWithDuration:3.f 
                         animations:^{
                             fireView0.frame = CGRectMake(80,  112, 100, 280);
                             fireView1.frame = CGRectMake(140, 112, 100, 280);
                             
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)removeFireView
{
    if (isParticleSupported()) {
        [fireView0 removeFromSuperview];
        [fireView0 release], fireView0 = nil;
        [fireView1 removeFromSuperview];
        [fireView1 release], fireView1 = nil;
    }
}




- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{    
    
}

# pragma mark - animation

- (void)logoAnimation
{
    imgLogo.frame = CGRectMake( 41, 127, 228, 227);
    [self.view bringSubviewToFront:imgLogo];
    [UIView animateWithDuration:1.5f 
                     animations:^{
                         imgLogo.frame = CGRectMake( 54, 20, 196, 196);
                     } completion:^(BOOL finished) {
                         [self.view sendSubviewToBack:imgLogo];
                         [self performSelector:@selector(diceAnimation)];
                     }];
}

- (void)diceAnimation
{
    imgDice.hidden = NO;
    imgDice.alpha = 0.f;
    [UIView animateWithDuration:1.5f 
                     animations:^{
                         imgDice.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(wxhhAnimation)];
                     }];
}

- (void)wxhhAnimation
{
    imgWXHH.hidden = NO;
    imgWXHH.alpha = 0.f;
    imgWXHHBg.hidden = NO;
    imgWXHHBg.alpha = 0.f;
    
    [UIView animateWithDuration:1.0f
                          delay:2.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{  
                         imgWXHHBg.alpha = 1.f;
                     } completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:2.f
                          delay:2.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         imgWXHH.alpha = 1.f;   
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(menuBtnAnimation)];
                         
                     }];
    
    [self addFireView];
}

- (void)menuBtnAnimation
{
    imgBtnMenu0.hidden = NO;
    imgBtnMenu1.hidden = NO;
    imgBtnMenu2.hidden = NO;
    imgBtnMenu0.alpha = 0;
    imgBtnMenu1.alpha = 0;
    imgBtnMenu2.alpha = 0;
    labHelp.hidden = NO;    
    labComment.hidden = NO;
    labStart.hidden = NO;
    labHelp.alpha = 0;    
    labComment.alpha = 0;
    labStart.alpha = 0;
    
    labHelp.frame = labStart.frame;
    labComment.frame = labStart.frame;
    imgBtnMenu0.frame = imgBtnMenu1.frame;
    imgBtnMenu2.frame = imgBtnMenu1.frame;
    
    [UIView animateWithDuration:0.5f
                          delay:0.10f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{    
                         imgBtnMenu0.alpha = 1;
                         imgBtnMenu1.alpha = 1;
                         imgBtnMenu2.alpha = 1;     
                         labStart.alpha = 1;       
                         labComment.alpha = 1;
                         labHelp.alpha = 1;  
                         imgBtnMenu0.frame = CGRectMake(33, 411, 73, 30);
                         imgBtnMenu2.frame = CGRectMake(215, 411, 73, 30); 
                         labComment.frame = CGRectMake(36, 414, 66, 21);
                         labHelp.frame = CGRectMake(219, 414, 66, 21);    
                         
                     } completion:^(BOOL finished) {
                         btnHelp.hidden = NO;
                         btnComment.hidden = NO;
                         btnStart.hidden = NO;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                          } completion:^(BOOL finished) {
                                              [self socailAnimation];
                                          }];
                     }];
}

- (void)socailAnimation
{
    [UIView animateWithDuration:1.f 
                          delay:0.5f 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         labPresent.alpha = 1.f;
                         labVersion.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         
                     }];
}



# pragma mark - view controller

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"bg0");
    [GameAudio playBgMusic:@"intro.mp3" times:-1 startAt:0.0];
    
    
    static bool firstLaunch = YES;
    if (firstLaunch) {
        firstLaunch = NO;        
        [self performSelector:@selector(logoAnimation)];
    }
    else {        
        imgBtnMenu0.hidden = NO;
        imgBtnMenu1.hidden = NO;
        imgBtnMenu2.hidden = NO;
        labHelp.hidden = NO;    
        labComment.hidden = NO;
        labStart.hidden = NO;
        imgLogo.hidden = NO;
        imgDice.hidden = NO;
        imgWXHH.hidden = NO;
        imgWXHHBg.hidden = NO;
        labPresent.hidden = NO;
        labVersion.hidden = NO;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] >=5.0) {
            
            if (NSClassFromString(@"CAEmitterLayer") && NSClassFromString(@"CAEmitterCell"))
            {
                // available       
                fireView0 = [[FireView alloc] initWithFrame:CGRectMake(110, 95, 100, 280)];
                [self.view insertSubview:fireView0 belowSubview:imgWXHH];
                
                fireView1 = [[FireView alloc] initWithFrame:CGRectMake(110, 95, 100, 280)];
                [self.view insertSubview:fireView1 belowSubview:imgWXHH];
                
                [UIView animateWithDuration:3.f 
                                 animations:^{
                                     fireView0.frame = CGRectMake(80,  112, 100, 280);
                                     fireView1.frame = CGRectMake(140, 112, 100, 280);
                                     
                                 } completion:^(BOOL finished) {
                                 }];
            }
        }
        
        
        [self.view bringSubviewToFront:imgLogo];
        [UIView animateWithDuration:0.5f animations:^{
            
            
            imgLogo.frame = CGRectMake( 54, 20, 196, 196);
        }completion:^(BOOL finished) {
            [self.view sendSubviewToBack:imgLogo];
            [UIView animateWithDuration:0.75f 
                             animations:^{
                                 labPresent.alpha = 1.f;
                                 labVersion.alpha = 1.f;
                                 imgLogo.alpha = 1.f;
                                 imgDice.alpha = 1.f;
                                 imgWXHHBg.alpha = 1.f;
                                 imgBtnMenu0.alpha = 1;
                                 imgBtnMenu1.alpha = 1;
                                 imgBtnMenu2.alpha = 1;     
                                 labStart.alpha = 1;    
                                 labComment.alpha = 1;
                                 labHelp.alpha = 1;  
                                 imgBtnMenu0.frame = CGRectMake(33, 411, 73, 30);
                                 imgBtnMenu2.frame = CGRectMake(215, 411, 73, 30); 
                                 labHelp.frame = CGRectMake(219, 414, 66, 21);    
                                 labComment.frame = CGRectMake(36, 414, 66, 21);
                                 
                             } completion:^(BOOL finished) {
                                 btnHelp.hidden = NO;
                                 btnComment.hidden = NO;
                                 btnStart.hidden = NO;
                             }];
        }];
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    [avBg stop];
//    [avBg release], avBg = nil;
//    [audioPlayer stop];
//    [audioPlayer release], audioPlayer = nil;
    
    [labComment release], labComment = nil;
    [labStart release], labStart = nil;
    [labHelp release], labHelp = nil;
    [labVersion release], labVersion = nil;
    [labPresent release], labPresent = nil;
    
    [imgLogo release], imgLogo = nil;
    [imgWXHH release], imgWXHH = nil;
    [imgDice release], imgDice = nil;
    
    [imgBtnMenu0 release], imgBtnMenu0 = nil;
    [imgBtnMenu1 release], imgBtnMenu1 = nil;    
    [imgBtnMenu2 release], imgBtnMenu2 = nil;
    
    [btnComment release], btnComment = nil;
    [btnStart release], btnStart = nil;
    [btnHelp release], btnHelp = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{    
//    [audioPlayer stop];
//    [audioPlayer release];
//    
//    [avBg stop];
//    [avBg release];  
    
    [labComment release];
    [labStart release];
    [labHelp release];
    [labVersion release];
    [labPresent release];
    
    [imgLogo release];
    [imgWXHH release];
    [imgDice release];
    
    [imgBtnMenu0 release];
    [imgBtnMenu1 release];    
    [imgBtnMenu2 release];
        
    [btnComment release];
    [btnStart release];
    [btnHelp release];
    
    [super dealloc];
}

@end
