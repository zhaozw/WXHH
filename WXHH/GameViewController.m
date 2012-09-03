//
//  ViewController.m
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "ModelWXHH.h"
#import "CardView.h"
#import "CALayer+Animation.h"
#import "HelpViewController.h"
#import "VPFadeMessageView.h"
#import "WXHH.h"
#import "CashCountView.h"

#define SECOND_TIME 30

BOOL isiAd = NO;

int second = SECOND_TIME;
int scorecard = 100;
int lastBet[5] = {0,0,0,0,0};

@interface GameViewController ()
- (void)updateMoneyViews;
- (void)updateCardViews;
@end

@implementation GameViewController

# pragma mark - press event

- (IBAction)pressHelp
{
    [GameAudio playSoundEffect:@"界面切换.mp3"];
    isiAd = YES;
    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    isHelpVCPresent = YES;
    [self presentModalViewController:helpVC animated:YES];
    [helpVC release];
}

- (IBAction)pressBack
{
    [GameAudio playSoundEffect:@"界面切换.mp3"];
//    [GameAudio stopBgMusic];
    
    state = GameStateExit;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate changeState:AppStateMain];
}

- (IBAction)pressSound
{
    [GameAudio enableMusic:![GameAudio isMusicEnable]];
    [GameAudio enableSoundEffect:![GameAudio isSoundEffectEnable]];
    [btnSound setBackgroundImage:[UIImage imageNamed:[GameAudio isMusicEnable]?@"soundOn.png":@"soundOff.png"] forState:UIControlStateNormal];
    
    if ([GameAudio isMusicEnable]) {
//        [self changeBgSound];
    }
}

- (IBAction)pressPurchase
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"购买筹码" 
                                                    delegate:self 
                                           cancelButtonTitle:@"取消" 
                                      destructiveButtonTitle:nil 
                                           otherButtonTitles:@"1000 = 6元", @"5000 = 24元", @"10000 = 42元", nil];
    as.tag = 0;
    [as showInView:self.view];
    [as release];
}

- (IBAction)pressMoenyButton{
    if ([self isNoMoenyAndCredit]) {
        // 以后有空再加
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"筹码不足！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"增添筹码", nil];
//        av.tag = 1;
//        [av show];
//        [av release];
    }
//    model.money += 100; 
    [self updateMoneyViews];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }
    else if (buttonIndex==1){
        
    }
    else if (buttonIndex==2){
    
    }
    else if (buttonIndex==3){
    
    }
    else if (buttonIndex==4){
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }
    else if (buttonIndex==1){
        
    }
}


- (BOOL)isNoMoenyAndCredit
{
    if (model.money<=0 && model.credit<=0 && model.betSpade<=0 && model.betHeart<=0 && model.betClub<=0 && model.betDiamond<=0 && model.betKing<=0) {
        return YES;
    }
    
    return NO;
}


- (void)addMoney
{
    if ([self isNoMoenyAndCredit]) {
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"筹码不足！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"增添筹码", nil];
//        av.tag = 1;
//        [av show];
//        [av release];
    }
    else {
        if (model.money>=100) {        
            model.money -= 100;     
            model.credit += 100;
//            [GameAudio playBetSoundEffect];
        }
        else if (model.money>0){
            model.credit += model.money;
            model.money = 0;        
//            [GameAudio playBetSoundEffect];
        }   
        else {
            showFadeMessageView(self.view, TEXT_NO_MORE_MONEY);
        }
        
        [model autosave];
        [self checkPurchaseView];
        

    }
    
    [self updateMoneyViews];        
}

- (void)getMoney
{
    if (model.credit>=100) {        
        model.credit -= 100;     
        model.money += 100;
        [GameAudio playBetSoundEffect];
    }
    else if (model.credit>0){
        model.money += model.credit;
        model.credit = 0;
        [GameAudio playBetSoundEffect];
    }
    else {        
        showFadeMessageView(self.view, TEXT_NO_MORE_CREDIT);
    }
    
    if (model.money>model.topScore) {
        model.topScore = model.money;
        model.betLv =  [ModelWXHH calcBetLevel];
    }
    
    [model autosave];
    [self updateMoneyViews];
}

// 换比例
- (IBAction)pressChangeRate
{
    rateType++;
    NSArray *arr = [NSArray arrayWithObjects:@"x10", @"x100", @"x500", nil];
    rateType %= [arr count];
    
    if (rateType==0) 
        betValue = 10;
    else if (rateType==1)
        betValue = 100;
    else if (rateType==2)
        betValue = 500;
        
    labChangeType.text = [arr objectAtIndex:rateType]; 
    [GameAudio playSoundEffect:@"下注.mp3"];
}

// 续压
- (IBAction)pressGoOn
{    
    if (state==GameStateBet) {
        int lastTotal = lastBet[0]+lastBet[1]+lastBet[2]+lastBet[3]+lastBet[4];
        if (lastTotal!=0) {// 钱还够续压吗
            if (model.credit+model.betSpade+model.betHeart+model.betClub+model.betDiamond+model.betKing>=lastTotal ) {
                model.credit = model.credit+model.betSpade+model.betHeart+model.betClub+model.betDiamond+model.betKing;
                model.betSpade = lastBet[0];
                model.betHeart = lastBet[1];
                model.betClub = lastBet[2];
                model.betDiamond = lastBet[3];
                model.betKing = lastBet[4];
                
                model.credit -= lastTotal;
                
                [GameAudio playSoundEffect:@"下注.mp3"];
            }
            else {
                showFadeMessageView(self.view, TEXT_NO_MORE_CREDIT);
            }
        }
        
        [self updateMoneyViews];
    }
    
}

// 取消压分
- (IBAction)pressCancel
{
    if (state==GameStateBet) {
        int betTotal = model.betSpade+model.betHeart+model.betClub+model.betDiamond+model.betKing;
        
        if (betTotal>0) {  
            model.credit += betTotal;
            model.betSpade = model.betHeart = model.betClub = model.betDiamond = model.betKing = 0;
            [self updateMoneyViews];
            
            [GameAudio playSoundEffect:@"取消下注.mp3"];
            [model autosave];
        }        
    }
}

# pragma mark - repeat button delegate

- (void)repeatButtonDidTouchDown:(VPRepeatButton *)button
{
    NSLog(@"down %d", button.tag);
    [self repeatButtonDidTouchRepeat:button];
}

- (void)repeatButtonDidTouchUp:(VPRepeatButton *)button
{
    NSLog(@"up %d", button.tag);
}

- (void)repeatButtonDidTouchRepeat:(VPRepeatButton *)button
{
    NSLog(@"repeat %d", button.tag);
    UIButton *btn = button;
    int tag = btn.tag;
    
    if (tag==99) { // 下分
        [self getMoney];
    }
    else if (tag==101) { // 上分
//        [self addMoney];
    }
    else if (state == GameStateBet) { // 压分
        
        if (model.credit>0) {
            int currentBet = MIN(betValue, model.credit);
            model.credit -= currentBet;
            int betMax = [ModelWXHH getBetValueMax];
            
            switch (tag) {
                case 0:
                    if (model.betSpade<betMax) {
                        [GameAudio playBetSoundEffect];
                    }
                    else {
                        showFadeMessageView(self.view, TEXT_REACH_BYTE_MAX);
                    }
                    
                    if (model.betSpade + currentBet<=betMax) {
                        model.betSpade += currentBet;
                    }
                    else {                    
                        int val = betMax-model.betSpade;
                        model.credit += (currentBet-val);
                        model.betSpade=betMax;
                    }
                    break;
                case 1:
                    if (model.betHeart<betMax) {
                        [GameAudio playBetSoundEffect];
                    }                
                    else {
                        showFadeMessageView(self.view, TEXT_REACH_BYTE_MAX);
                    }
                    
                    if (model.betHeart + currentBet<=betMax) {
                        model.betHeart += currentBet;
                    }
                    else {                    
                        int val = betMax-model.betHeart;
                        model.credit += (currentBet-val);
                        model.betHeart=betMax;
                    }                
                    break;
                case 2:
                    if (model.betClub<betMax) {
                        [GameAudio playBetSoundEffect];
                    }                
                    else {
                        showFadeMessageView(self.view, TEXT_REACH_BYTE_MAX);
                    }
                    
                    if (model.betClub + currentBet<=betMax) {
                        model.betClub += currentBet;
                    }
                    else {                    
                        int val = betMax-model.betClub;
                        model.credit += (currentBet-val);
                        model.betClub=betMax;
                    }
                    break;
                case 3:
                    if (model.betDiamond<betMax) {
                        [GameAudio playBetSoundEffect];
                    }
                    else {
                        showFadeMessageView(self.view, TEXT_REACH_BYTE_MAX);
                    }
                    
                    if (model.betDiamond + currentBet<=betMax) {
                        model.betDiamond += currentBet;
                    }
                    else {                    
                        int val = betMax-model.betDiamond;
                        model.credit += (currentBet-val);
                        model.betDiamond=betMax;
                    }
                    break;
                case 4:
                    if (model.betKing<betMax) {
                        [GameAudio playBetSoundEffect];
                    }
                    else {
                        showFadeMessageView(self.view, TEXT_REACH_BYTE_MAX);
                    }
                    
                    if (model.betKing + currentBet<=betMax) {
                        model.betKing += currentBet;
                    }
                    else {                    
                        int val = betMax-model.betKing;
                        model.credit += (currentBet-val);
                        model.betKing=betMax;
                    }
                    break;
            }
            
            [self updateMoneyViews];
        }
        else {
            if ([ModelWXHH sharedInstance].money<=0) {                
                showFadeMessageView(self.view, [NSString stringWithFormat:@"%@", TEXT_NO_MORE_CREDIT]);
            }
            else {
                showFadeMessageView(self.view, [NSString stringWithFormat:@"%@, %@", TEXT_NO_MORE_CREDIT, TEXT_PLEASE_ADD_CREDIT]);                
            }
        }
    }
}


- (void)updateGirlImage
{    
    static int i = -1;
    
    if (i==-1) {
        i = arc4random()%20;
    }
    i++;
    i%=20;
    int randomGirl = i;
    
    UIImageView *imgvTmp;
    
//    if ([ModelWXHH sharedInstance].plays>4 && [ModelWXHH sharedInstance].topScore >= 800) {
//        imgvTmp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", randomGirl] ofType:@"jpg"]]];
//    }
//    else {
        if (cardsList.showCount<[model.arrayRandoms count]) {
            NSNumber *number = [model.arrayRandoms objectAtIndex:cardsList.showCount];
            int value = [number intValue];
            imgvTmp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[model getImageName:value] ofType:@"png"]]];
        }
//    }
        
    imgvTmp.contentMode = imgCard.contentMode;
    imgvTmp.clipsToBounds = YES;
    imgvTmp.frame = imgCard.frame;
    imgvTmp.alpha = 0.f;
    
    [self.view insertSubview:imgvTmp aboveSubview:imgCard];
    
    [UIView animateWithDuration:1.33f
                     animations:^{
                         imgvTmp.alpha = 1.f;
                         imgCard.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imgCard.image = imgvTmp.image;
                         imgCard.alpha = 1.f;
                         [imgvTmp removeFromSuperview];
                         [imgvTmp release];
                         
                     }];
        
  

    

}

# pragma mark - logic

- (void)goToGameStateShow
{
    [self nextState:GameStateShow];
}

- (void)goToGameStateRoundBegin
{
    [self nextState:GameStateRoundBegin];
}

- (void)nextState:(GameState)nextState
{
    if (GameStateExit==state) {
        return;
    }
    
    state = nextState;
    switch (state) {
        case GameStateExit:
            break;
        case GameStateRoundBegin:
            [self checkPurchaseView];
            if (cardsList.showCount>=[model.arrayRandoms count]) {
                cardsList.showCount = 0;
                [model resetCards];
                
                labSpadeCount.text = [NSString stringWithFormat:@"%d", [model calcSpadeCount]];
                labHeartCount.text = [NSString stringWithFormat:@"%d", [model calcHeartCount]];
                labClubeCount.text = [NSString stringWithFormat:@"%d", [model calcClubeCount]];
                labDmondCount.text = [NSString stringWithFormat:@"%d", [model calcDiamondCount]];
                labKing.text = [NSString stringWithFormat:@"%d", [model calcJokerCount]];
                [cardsList setNeedsDisplay];
                model.rounds +=1;
            }
            else{
                model.rounds += 1;
            }
            labPlays.text = [NSString stringWithFormat:@"%d", model.plays];
            labRounds.text = [NSString stringWithFormat:@"%d", model.rounds];
            
            
            second = SECOND_TIME;
            if (timerForSecond==nil) {        
                timerForSecond = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES] retain];
            }
            [timerForSecond fire];
            [GameAudio playSoundEffect:@"倒数读秒.mp3"];
            model.betSpade = model.betHeart = model.betClub = model.betDiamond = model.betKing = 0;
            [self nextState:GameStateBet];            
            [self updateMoneyViews];
            break;
        case GameStateBet:
            break;
        case GameStateAtferBetDelay:
            [self performSelector:@selector(goToGameStateShow) withObject:nil afterDelay:2.f];            
            break;
        case GameStateShow:
        {  
            [model autosave];
            NSLog(@"show count = %d", cardsList.showCount);
            NSNumber *number = [model.arrayRandoms objectAtIndex:cardsList.showCount];
            
            int value = [number intValue];
            NSLog(@"value = %d", value);
            UIImage *image = [UIImage imageNamed:[model getImageName:value]];
            UIImageView *currCard = [[[UIImageView alloc] initWithImage:image] autorelease];
            
            [self.view insertSubview:currCard belowSubview:viewCashCountBg];
            
            currCard.frame = CGRectMake(320/2-image.size.width/2, 480/2+60-image.size.height/2, image.size.width, 0);
            currCard.contentMode = UIViewContentModeCenter;
            currCard.clipsToBounds = YES;
            [UIView animateWithDuration:4  
                                  delay:0  
                                options: UIViewAnimationCurveEaseOut  
                             animations:^{                    
                                 currCard.frame = CGRectMake(320/2-image.size.width/2, 480/2+60-image.size.height/2+1, image.size.width, image.size.height);
                                 CGPoint center = self.view.center;
                                 center.y = center.y+60;
                                 currCard.center = center;
                             }   
                             completion:^(BOOL finished){      
                                 [UIView animateWithDuration:0.33f
                                                  animations:^{
                                                      currCard.alpha = 0.f;
                                                  } completion:^(BOOL finished) {
                                                      [self updateGirlImage];
                                                      [currCard removeFromSuperview];
                                                      currCard.alpha = 1.f;
                                                      [self nextState:GameStateCheckMoney];
                                                  }];
                                 
                             }]; 
        }            
            break;
        case GameStateCheckMoney:
        {
            cardsList.showCount += 1;
            
            [self updateCardViews];
            labSpadeCount.text = [NSString stringWithFormat:@"%d", [model calcSpadeCount]];
            labHeartCount.text = [NSString stringWithFormat:@"%d", [model calcHeartCount]];
            labClubeCount.text = [NSString stringWithFormat:@"%d", [model calcClubeCount]];
            labDmondCount.text = [NSString stringWithFormat:@"%d", [model calcDiamondCount]];
            labKing.text = [NSString stringWithFormat:@"%d", [model calcJokerCount]];
            
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %d", cardsList, cardsList.showCount-1]);
            NSNumber *number = [model.arrayRandoms objectAtIndex:cardsList.showCount-1];
            
            int value = [number intValue];
            int color = [model getColorInteger:value];
            winCount = [model calcWinScorecardRandom:value 
                                                   S:model.betSpade 
                                                   H:model.betHeart 
                                                   C:model.betClub
                                                   D:model.betDiamond
                                                   K:model.betKing];
            
            
            
            lastBet[0] = model.betSpade;
            lastBet[1] = model.betHeart;
            lastBet[2] = model.betClub;
            lastBet[3] = model.betDiamond;
            lastBet[4] = model.betKing;
            
            scorecard = winCount;
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSNumber numberWithInt:model.money] forKey:@"UserMoney"];
            [ud setObject:[NSNumber numberWithInt:model.credit+scorecard] forKey:@"UserCredit"];
            [ud synchronize];
            
            if (scorecard>0) {
                if (lastBet[0]+lastBet[1]+lastBet[2]+lastBet[3]+lastBet[4]<winCount) {                    
                    model.exp += (winCount-lastBet[0]-lastBet[1]-lastBet[2]-lastBet[3]-lastBet[4])/10;
                }
                
                
                model.winMoney = winCount;
                labWin.text = [NSString stringWithFormat:@"%d", model.winMoney];
                [self updateMoneyViews];
                
                UILabel *fadeLabel = nil;
                if (color==0) {
                    fadeLabel = labBetSpade;
                }                                     
                if (color==1) {
                    fadeLabel = labBetHeart;
                }                                     
                if (color==2) {
                    fadeLabel = labBetClube;
                }                                     
                if (color==3) {
                    fadeLabel = labBetDmond;
                }                                     
                if (color==4 || color==5) {
                    fadeLabel = labBetKing;
                }
                
                [UIView animateWithDuration:0.25  
                                      delay:1.0  
                                    options: UIViewAnimationCurveEaseOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                                 animations:^{                    
                                     [UIView setAnimationRepeatCount:3];
                                     labWin.alpha = 0.f;
                                     fadeLabel.alpha = 0.f;
     
                                 }completion:^(BOOL finished){      
                                     labWin.alpha = 1.f;
                                     fadeLabel.alpha = 1.f;
                                     if (timerForScorecard==nil) {        
                                         timerForScorecard = [[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scorecardCount) userInfo:nil repeats:YES] retain];
                                     }
                                     [timerForScorecard fire];
                                     [GameAudio playSoundEffect:@"赢得筹码.mp3"];
                                 }]; 
            }
            else {
                if (timerForScorecard==nil) {        
                    timerForScorecard = [[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scorecardCount) userInfo:nil repeats:YES] retain];
                }
                [timerForScorecard fire];
            }
        }
            break;
        case GameStateRoundEnd:
            [self performSelector:@selector(goToGameStateRoundBegin) withObject:nil afterDelay:3.0];
            break;
    }
}

- (void)timerCount
{
    labWin.text = [NSString stringWithFormat:@"%d", second];
    
    second--;
    
    if (second<=5) {
        [GameAudio playSoundEffect:@"倒数读秒.mp3"];
    }
    
    if (second==-1) {
        [timerForSecond invalidate];
        [timerForSecond release], timerForSecond = nil;
        [self nextState:GameStateAtferBetDelay];
    }
}

- (void)scorecardCount
{
    labWin.text = [NSString stringWithFormat:@"%d", scorecard];
    
    labCredit.text = [NSString stringWithFormat:@"%d", (int)([labCredit.text intValue]+winCount/50.f)];
    scorecard -= (int)(winCount/50.f);
    
    
    if (scorecard<=50) {
        model.winMoney = 0;
        model.credit += winCount;
        model.betSpade = model.betHeart = model.betClub = model.betDiamond = model.betKing = 0;
        labWin.text = @"0";
        [self updateMoneyViews];
        [timerForScorecard invalidate];
        [timerForScorecard release], timerForScorecard = nil;
        [self nextState:GameStateRoundEnd];
    }
}

- (void)updateMoneyViews
{
    labBetSpade.text = [NSString stringWithFormat:@"%d", model.betSpade];
    labBetHeart.text = [NSString stringWithFormat:@"%d", model.betHeart];
    labBetClube.text = [NSString stringWithFormat:@"%d", model.betClub];
    labBetDmond.text = [NSString stringWithFormat:@"%d", model.betDiamond];
    labBetKing.text = [NSString stringWithFormat:@"%d", model.betKing];
//    labWin.text = [NSString stringWithFormat:@"%d", model.winMoney];
    labCredit.text = [NSString stringWithFormat:@"%d", model.credit];
    labMoney.text = [NSString stringWithFormat:@"%d", model.money];
    
    // exp level
    labExp.text = [NSString stringWithFormat:@"%d/%d", model.exp, [ModelWXHH getCurrentExpMax]];
    labLevel.text = [NSString stringWithFormat:@"Lv %d", [ModelWXHH getCurrentLv]];
    labBetTypeTitle.text = [ModelWXHH getBetLevelTitle];
    labHighScore.text = [NSString stringWithFormat:@"最高记录 %d", [ModelWXHH sharedInstance].topScore];
    labScoreExp.text = [NSString stringWithFormat:@"%d/%d", [ModelWXHH sharedInstance].topScore, [ModelWXHH getTopScoreLevelUpExp]];
    labFreeMoney.text = [NSString stringWithFormat:@"免费筹码 %d", [ModelWXHH getFreeMoney]];
    
    [self checkPurchaseView];
}

- (void)updateCardViews
{    
    [cardsList setNeedsDisplay];
}

- (void)clockLoop
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *clock = [ud objectForKey:@"FreeMoneyClock"];
    int count;
    
#define FREE_MONEY_TIME 60
    
    if (clock==nil) {
        count = FREE_MONEY_TIME;
    }
    else {
        count = [clock intValue];
        if (count<=0 || count>FREE_MONEY_TIME) {
            count = FREE_MONEY_TIME;
        }
    }

    count -= 1;
    
    if (count==0) {
        
        [GameAudio playSoundEffect:@"赢得筹码.mp3"];
        model.money += [ModelWXHH getFreeMoney];
        [model autosave];
        count = FREE_MONEY_TIME;
        [self updateMoneyViews];
    }
    else {
        int min = count/60;
        int sec = count%60;
        NSString *strMin = min<10?[NSString stringWithFormat:@"0%d", min]:[NSString stringWithFormat:@"%d", min];
        NSString *strSec = sec<10?[NSString stringWithFormat:@"0%d", sec]:[NSString stringWithFormat:@"%d", sec];

        
        labForTimeAndPurchase.text = [NSString stringWithFormat:@"%@ : %@", strMin, strSec]; 
    }
    
    [ud setObject:[NSNumber numberWithInt:count] forKey:@"FreeMoneyClock"];
    [ud synchronize];
    
    
}

- (void)checkPurchaseView
{
    if ([self isNoMoenyAndCredit]) {
        [UIView animateWithDuration:0.3 animations:^{
            viewForTimeAndPurchase.alpha = 1.f;
        } completion:^(BOOL finished) {            
            viewForTimeAndPurchase.hidden = NO;
            
            if (timerForWainting==nil) {
                timerForWainting = [[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(clockLoop) userInfo:nil repeats:YES] retain];
            }
            [timerForWainting fire];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            viewForTimeAndPurchase.alpha = 0.f;
        } completion:^(BOOL finished) {            
            viewForTimeAndPurchase.hidden = YES;
            [timerForWainting invalidate];
            [timerForWainting  release], timerForWainting = nil;
            
            
        }];
    }
}

# pragma mark - cash count

- (IBAction)showCashCountView
{
    NSLog(@"[ModelWXHH sharedInstance].money = %d", [ModelWXHH sharedInstance].money);
    if([ModelWXHH sharedInstance].money<=0){
        showFadeMessageView(self.view, @"筹码不足, 不能上分");
        return;
    }
    else if ([ModelWXHH sharedInstance].money<100) {
        model.credit += [ModelWXHH sharedInstance].money;
        [ModelWXHH sharedInstance].money = 0;
        [self updateMoneyViews];
        return;
    }
     
    
    showFadeMessageView(self.view, @"上分：向下滑动             完成：左右滑动");
    
    int cashNumber = 0;  
    if ([ModelWXHH sharedInstance].money>3000) {
        cashNumber = 30;
    }
    else {
        cashNumber = [ModelWXHH sharedInstance].money/100;
    }

    
    if (cashCountView==nil) {
        cashCountView = [[CashCountView alloc] initWithFrame:CGRectMake(0, 8, 320, 400) number:cashNumber
                         ]  ; 
        cashCountView.delegate = self;
        [viewCashCountBg addSubview:cashCountView];
        viewCashCountBg.userInteractionEnabled = YES;
    }
    [cashCountView reset];
}

- (void)dismissCashCountView
{
//    [UIView animateWithDuration:2.f animations:^{
//        viewCashCountBg.alpha = 0.f;   
//    } completion:^(BOOL finished) {
//
//    }];

    showFadeMessageView(self.view, @"上分完毕！");
    [cashCountView removeFromSuperview];
    [cashCountView release], cashCountView = nil;
    viewCashCountBg.userInteractionEnabled = NO;
    viewCashCountBg.alpha = 1.f;
}

- (void)cashCount
{
    
}

- (void)cashCountFrameDidEnd
{
    NSLog(@"cashCountFrameDidEnd");
    
    [self addMoney];
    [GameAudio playSoundEffect:@"pickMoney.mp3"];
}

- (void)cashCountDidStop
{
    [self dismissCashCountView];
}

- (void)cashCountDidEnd
{
    NSLog(@"cashCountDidEnd");
    [self dismissCashCountView];
    
}

# pragma mark - iAd

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = CGRectMake(0, 0, viewForiAd.frame.size.width, viewForiAd.frame.size.height);
    
    [UIView animateWithDuration:1.f animations:^{
        _bannerView.alpha = 1.f;
    }];
    
    bannerFrame.origin.y = contentFrame.size.height;
    [_bannerView.layer transitionOglFlipByDirection:2];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    viewForiAd.alpha = 1.f;
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    viewForiAd.alpha = 0.f;
//    [self layoutAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
//    [timerForiAd invalidate];    
//    [timerForiAd release], timerForiAd = nil;
    isiAd = YES;
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
//    timerForiAd = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addSecond) userInfo:nil repeats:YES] retain];
//    [timerForiAd fire];
    
}

# pragma mark - default

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    model = [ModelWXHH sharedInstance];
    
    if (model.arrayRandoms==nil) {        
        [model resetCards];
    }
    
    cardsList.showCount = model.rounds;
    
    labPlays.text = [NSString stringWithFormat:@"%d", model.plays];
    labRounds.text = [NSString stringWithFormat:@"%d", model.rounds];
    
    rateType = 0;
    betValue = 10;
        
    labSpadeCount.text = [NSString stringWithFormat:@"%d", [model calcSpadeCount]];
    labHeartCount.text = [NSString stringWithFormat:@"%d", [model calcHeartCount]];
    labClubeCount.text = [NSString stringWithFormat:@"%d", [model calcClubeCount]];
    labDmondCount.text = [NSString stringWithFormat:@"%d", [model calcDiamondCount]];
    labKing.text = [NSString stringWithFormat:@"%d", [model calcJokerCount]];
        
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [btnAddMoney addGestureRecognizer:longPress];
//    [longPress release];
//    
//    [self updateGirlImage];
    [self nextState:GameStateRoundBegin];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *flag = [ud objectForKey:@"RemoveAds"];
    if (![flag isEqualToString:@"YES"]) {
        
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
        _bannerView.frame = CGRectMake(0, 0, viewForiAd.frame.size.width, viewForiAd.frame.size.height);
        [viewForiAd addSubview:_bannerView];
        _bannerView.alpha = 0.f;
        
    }
    
    [self checkPurchaseView];
    
    [btnSound setBackgroundImage:[UIImage imageNamed:[GameAudio isMusicEnable]?@"soundOn.png":@"soundOff.png"] forState:UIControlStateNormal];
    
    btnBetSpade.delegate = self;
    btnBetHeart.delegate = self;
    btnBetClube.delegate = self;
    btnBetDmond.delegate = self;
    btnBetKing.delegate = self;
    
    btnRemoveCredit.delegate = self;
    
    viewCashCountBg.userInteractionEnabled = NO;
}

- (void)changeBgSound
{
    NSLog(@"bg1");
    int i = arc4random()%4;
    
    NSArray *arrBgMusicFileNames = [NSArray arrayWithObjects:@"bg1.mp3", @"bg2.mp3", @"bg3.mp3", @"bg4.mp3", nil];
    AVAudioPlayer *av = [GameAudio playBgMusic:[arrBgMusicFileNames objectAtIndex:i]];
    av.delegate = self;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self changeBgSound];
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{    
    isiAd = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [ud objectForKey:@"IsHelpViewShowed"]);
    if ([ud objectForKey:@"IsHelpViewShowed"]==nil) {
        isiAd = YES;
        HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
        isHelpVCPresent = YES;
        [self presentModalViewController:helpVC animated:NO];
        [helpVC release];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{    
    if (!isiAd) {        
        [timerForSecond invalidate];
        [timerForSecond release], timerForSecond = nil;
        
        [timerForScorecard invalidate];
        [timerForScorecard release], timerForScorecard = nil;
        
        [timerForWainting invalidate];    
        [timerForWainting release], timerForWainting = nil;
    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [viewCashCountBg release], viewCashCountBg = nil;
    [cashCountView release], cashCountView = nil;
    
    [timerForSecond invalidate];
    [timerForSecond release], timerForSecond = nil;
    
    [timerForScorecard invalidate];
    [timerForScorecard release], timerForScorecard = nil;
    
    [timerForWainting invalidate];    
    [timerForWainting release], timerForWainting = nil;
    
//    [avBet stop];
//    [avBet release], avBet = nil;
//    [avBg stop];
//    [avBg release], avBg = nil;
//    
//    [avCancelBet stop];
//    [avCancelBet release], avCancelBet = nil;
//    [avCountTime stop];
//    [avCountTime release], avCountTime = nil;
    
    [labMoney release], labMoney = nil;
    [labPlays release], labPlays = nil;
    [labRounds release], labRounds = nil;
    [imgCard release], imgCard = nil;
    [cardsList release], cardsList = nil;
    [labSpadeCount release], labSpadeCount = nil;
    [labHeartCount release], labHeartCount = nil;
    [labClubeCount release], labClubeCount = nil;
    [labDmondCount release], labDmondCount = nil;
    [labKing release], labKing = nil;
    [labCredit release], labCredit = nil;
    [labWin release], labWin = nil;
    [labChangeType release], labChangeType = nil;
    [labBetSpade release], labBetSpade = nil;
    [labBetHeart release], labBetHeart = nil;
    [labBetClube release], labBetClube = nil;
    [labBetDmond release], labBetDmond = nil;
    [labBetKing release], labBetKing = nil;
    [viewForTimeAndPurchase release], viewForTimeAndPurchase = nil;
    [labForTimeAndPurchase release], labForTimeAndPurchase = nil;
    [_bannerView release], _bannerView = nil;
    [viewForiAd release], viewForiAd = nil;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)dealloc
{   
    
    [timerForSecond invalidate];
    [timerForSecond release], timerForSecond = nil;
    
    [timerForScorecard invalidate];
    [timerForScorecard release], timerForScorecard = nil;
    
    [timerForWainting invalidate];    
    [timerForWainting release], timerForWainting = nil;
    
    
//    [avBet stop];
//    [avBet release];
//    [avBg stop];
//    [avBg release];
//    
//    [avCancelBet stop];
//    [avCancelBet release];
//    [avCountTime stop];
//    [avCountTime release];
    
    [labMoney release];
    [labPlays release];
    [labRounds release];
    [imgCard release];
    [cardsList release];
    [labSpadeCount release];
    [labHeartCount release];
    [labClubeCount release];
    [labDmondCount release];
    [labKing release];
    [labCredit release];
    [labWin release];
    [labChangeType release];
    [labBetSpade release];
    [labBetHeart release];
    [labBetClube release];
    [labBetDmond release];
    [labBetKing release];
    [viewForTimeAndPurchase release];
    [labForTimeAndPurchase release];
    [_bannerView release];
    [viewForiAd release];
    
    
    [super dealloc];
}

@end
