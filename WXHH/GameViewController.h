//
//  ViewController.h
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "GameAudio.h"
#import "VPRepeatButton.h"
#import "CashCountView.h"

@class CardView;
@class ModelWXHH;

typedef enum {    
    GameStateRoundBegin = 0,
    GameStateBet = 1,
    GameStateAtferBetDelay = 2,
    GameStateShow = 3,
    GameStateCheckMoney = 4,
    GameStateRoundEnd = 5,
    GameStateExit = 6,
    
}GameState;

@interface GameViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, ADBannerViewDelegate, AVAudioPlayerDelegate, VPRepeatButtonDelegate, CashCountViewDelegate> {

    IBOutlet UILabel *labMoney;
    IBOutlet UILabel *labPlays;
    IBOutlet UILabel *labRounds;
     
    IBOutlet UIImageView *imgCard;
    IBOutlet CardView *cardsList;
    
    IBOutlet UILabel *labSpadeCount;
    IBOutlet UILabel *labHeartCount;
    IBOutlet UILabel *labClubeCount;
    IBOutlet UILabel *labDmondCount;
    IBOutlet UILabel *labKing;
    
    IBOutlet UILabel *labCredit;
    IBOutlet UILabel *labWin;
    IBOutlet UILabel *labChangeType;
    
    IBOutlet UILabel *labBetSpade;
    IBOutlet UILabel *labBetHeart;
    IBOutlet UILabel *labBetClube;
    IBOutlet UILabel *labBetDmond;
    IBOutlet UILabel *labBetKing;
    
    GameState state;
    
    ModelWXHH *model;
    
    int winCount;
    int rateType;
    int betValue;
    
    
    IBOutlet UIView *viewForTimeAndPurchase;
    IBOutlet UILabel *labForTimeAndPurchase;
    
    NSTimer *timerForWainting;
    
    // iAd
    ADBannerView *_bannerView;
    IBOutlet UIView *viewForiAd;
    
    
    NSTimer *timerForSecond;
    NSTimer *timerForScorecard;
    
    
    IBOutlet UILabel *labHighScore;
    IBOutlet UILabel *labLevel;
    IBOutlet UILabel *labBetTypeTitle;
    IBOutlet UILabel *labExp;
    IBOutlet UILabel *labScoreExp;
    IBOutlet UILabel *labExpBar; 
    IBOutlet UILabel *labFreeMoney;
    
    IBOutlet UIButton *btnSound;
    
    IBOutlet VPRepeatButton *btnBetSpade;
    IBOutlet VPRepeatButton *btnBetHeart;
    IBOutlet VPRepeatButton *btnBetClube;
    IBOutlet VPRepeatButton *btnBetDmond;
    IBOutlet VPRepeatButton *btnBetKing;
    
    IBOutlet VPRepeatButton *btnAddCredit;
    IBOutlet VPRepeatButton *btnRemoveCredit;
    
    IBOutlet UIView *viewCashCountBg;
    CashCountView *cashCountView;
    
    BOOL fCashCountStop;
}

- (IBAction)pressBack;
- (IBAction)pressPurchase;


- (IBAction)pressChangeRate;
- (IBAction)pressGoOn;
- (IBAction)pressCancel;


- (IBAction)pressSound;

@end
