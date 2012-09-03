//
//  MainViewController.h
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameAudio.h"
#import "FireView.h"

@interface MainViewController : UIViewController <AVAudioPlayerDelegate>
{
    IBOutlet UILabel *labComment;
    IBOutlet UILabel *labStart;
    IBOutlet UILabel *labHelp;
    IBOutlet UILabel *labVersion;
    IBOutlet UILabel *labPresent;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIImageView *imgWXHH;
    IBOutlet UIImageView *imgWXHHBg;
    IBOutlet UIImageView *imgDice;
    
    IBOutlet UIImageView *imgBtnMenu0;
    IBOutlet UIImageView *imgBtnMenu1;
    IBOutlet UIImageView *imgBtnMenu2;
    
    IBOutlet UIButton *btnComment;
    IBOutlet UIButton *btnStart;
    IBOutlet UIButton *btnHelp;
    
    
    
    IBOutlet UIButton *btnSocailButton;
    IBOutlet UIView *viewSocialBg;
    
    FireView *fireView0;
    FireView *fireView1;
    
    int nextStateTag;
    
}



@end
