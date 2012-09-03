//
//  Model.m
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelWXHH.h"

static ModelWXHH *instance;

#define TOTAL_CARDS 58

@implementation ModelWXHH

@synthesize arrayRandoms;
@synthesize dictPlayerInfo;
@synthesize money;
@synthesize credit;
@synthesize rate;
@synthesize plays;
@synthesize rounds;
@synthesize arrGoOns;

@synthesize betSpade;
@synthesize betHeart;
@synthesize betClub;
@synthesize betDiamond;
@synthesize betKing;

@synthesize winMoney;
@synthesize enableSound;

@synthesize topScore;
@synthesize exp;
@synthesize betLv;

/* 
 Exp & Lv
 10	20	40	60	80	100		200	300	400  500
 1	2	3	4	5	6		7	8	9	10
 1，16，81，256，625，1296，2401，4096，10000，20736，38416，
 65536，104976，160000，
 exp = 2500/10

 Bet Level 0-7
 赌徒，赌鬼，赌棍，赌霸，   赌侠，     赌王，     赌圣，     赌神
 600 1200  2400  4800	10000      25000	 50000              // 升级所需钱
 50  100   200   400	800        1500      2500      5000     // 该等级
 */


+ (NSString *)getBetLevelTitle
{
    NSArray *array = [NSArray arrayWithObjects:@"乞丐",@"屌丝",@"赌鬼",@"赌霸",@"赌侠",@"赌王",@"赌圣",@"赌神", nil];
    return [array objectAtIndex:[ModelWXHH sharedInstance].betLv];
}

+ (int)getLevelUpExp:(int)lv
{    
    if (lv>=1 && lv<=10) {        
        int levelup[10] = { 16, 81, 256, 625, 1320, 2400, 4000, 8000, 15000, 40000};
        return levelup[lv-1];
    }
    else {
        return 40000;
    }
}

+ (int)getTopScoreLevelUpExp
{    
    int topScores[8] = {0, 400, 800, 1600, 3200, 6400, 12800, 25600};
    return topScores[[ModelWXHH sharedInstance].betLv+1];    
}

+ (int)calcBetLevel 
{    
    int topScores[8] = {0, 400, 800, 1600, 3200, 6400, 12800, 25600};
    
    int yourTopScore = [ModelWXHH sharedInstance].topScore;
    
    if (yourTopScore>=25600) {
        return 7;
    }
    
    for (int i=0; i<8-1; i++) {
        if (yourTopScore>=topScores[i] && yourTopScore<topScores[i+1]) {
            return i;
        }
    }
    
    return 0;
}

//  根据等级 最多压多少
+ (int)getBetValueMax
{
    int betValues[8] = { 100, 150, 250, 500, 800, 1200, 2000, 3000};
    return betValues[[ModelWXHH sharedInstance].betLv];
}

+ (int)getFreeMoney
{
    int freeMoenyValues[10] = { 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000};
    int currentLv = [ModelWXHH getCurrentLv]-1;
    return freeMoenyValues[currentLv];
}

+ (int)getCurrentLv
{
    ModelWXHH *model = [ModelWXHH sharedInstance];
    int exp = model.exp;
    
    if (exp>=[ModelWXHH getLevelUpExp:10]) {
        return 10;
    }
    else if (exp<=15) {
        return 1;
    }
    else {
        for (int i=0; i<10-1; i++) {
            if (exp>=[ModelWXHH getLevelUpExp:i+1] && exp<[ModelWXHH getLevelUpExp:i+2]) {
                return i+2;
            }
        }
    }
    
    return 10;
}

+ (int)getCurrentExpMax
{    
    ModelWXHH *model = [ModelWXHH sharedInstance];
    int exp = model.exp;
    
    if (exp>=[ModelWXHH getLevelUpExp:10]) {
        return [ModelWXHH getLevelUpExp:10];
    }
    else if (exp<=15) {
        return [ModelWXHH getLevelUpExp:1];
    }
    else {
        for (int i=0; i<10-1; i++) {
            if (exp>=[ModelWXHH getLevelUpExp:i+1] && exp<[ModelWXHH getLevelUpExp:i+2]) {
                return [ModelWXHH getLevelUpExp:i+2];
            }
        }
    }
    
    return [ModelWXHH getLevelUpExp:10];
}




+ (ModelWXHH *)sharedInstance
{
    @synchronized(self){
        if (instance==nil) {        
            instance = [[ModelWXHH alloc] init];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            ModelWXHH *model = [ModelWXHH sharedInstance];
            
            if ([ud objectForKey:@"IsFirstLaunch"]==nil) {
                [ud setObject:@"NO" forKey:@"IsFirstLaunch"];
                model.money = 500;
            }
            else {
                model.money = [[ud objectForKey:@"UserMoney"] intValue];                
            }
            
            model.arrayRandoms = [ud objectForKey:@"UserSavedCards"];
            model.credit = [[ud objectForKey:@"UserCredit"] intValue];
            model.exp = [[ud objectForKey:@"UserExp"] intValue];

            model.topScore = [[ud objectForKey:@"UserTopScore"] intValue];   
            
            
            model.betLv =  [ModelWXHH calcBetLevel];
            
            
            if ([ud objectForKey:@"UserPlays"]!=nil) {                
                model.plays = [[ud objectForKey:@"UserPlays"] intValue];
            }
            else {
                model.plays = 0;
            }
            
            if ([ud objectForKey:@"UserRounds"]!=nil) {                
                model.rounds = [[ud objectForKey:@"UserRounds"] intValue];
            }
            else {
                model.rounds = 0;
            }
        }
    }   
    
    return instance;
}

- (void)resetCards
{
    ModelWXHH *model = [ModelWXHH sharedInstance];
    model.arrayRandoms = [[NSMutableArray alloc] initWithCapacity:TOTAL_CARDS];
    
    for (int i=0; i<TOTAL_CARDS; i++) {
        int random = arc4random()%54;
        NSNumber *n = [NSNumber numberWithInt:random];
        [model.arrayRandoms addObject:n];
    }    
    
    model.plays += 1;
    model.rounds = 0;
    if (model.plays>99) {
        model.plays = 1;
    }
}

- (int)calcWinScorecardRandom:(NSUInteger)r S:(NSUInteger)s H:(NSUInteger)h C:(NSUInteger)c D:(NSUInteger)d K:(NSUInteger)k
{
    int color = 0;
    
    if (r==0) { // 大王
        color = 5;
    }
    else if (r==1) { // 小王            
        color = 4;
    }
    else {
        color = (r-2)/13;
    }    
    
    if (color==0) {
        return s*3.8;
    }
    else if (color==1) {
        return h*3.8;
    }
    else if (color==2) {
        return c*4;
    }
    else if (color==3) {
        return d*4;
    }
    else if (color==4 || color==5){
        return k*20+s+h+c+d;
    }
    
    return 0;
}

- (NSString *)getImageName:(int)random
{
    if (random==0) { // 大王
        return @"54";
    }
    else if (random==1) { // 小王            
        return @"53";
    }
    else {
        int color = (random-2)/13;
        int value = (random-2)%13;
        NSArray *arrColors = [NSArray arrayWithObjects:@"card_sxx_open", @"card_hxx_open", @"card_cxx_open", @"card_dxx_open", nil];
        
        NSString *string = [arrColors objectAtIndex:color];
        return [string stringByReplacingOccurrencesOfString:@"xx" withString:[NSString stringWithFormat:@"%@%d", value+1<10?@"0":@"", value+1]];
    }  
}

- (int)getColorInteger:(int)random
{
    int color = 0;
    
    if (random==0) { // 大王
        color = 5;
    }
    else if (random==1) { // 小王            
        color = 4;
    }
    else {
        color = (random-2)/13;
    }    
    return color;
}

- (int)getValueInteger:(int)random
{
    int value = 0;
    
    if (random==0) { // 大王
        value = 13;
    }
    else if (random==1) { // 小王   
        value = 13;
    }
    else {
        value = (random-2)%13;
    }    
    return value;
}


- (NSString *)getColor:(int)random
{
    int color = [self getColorInteger:random];
    
    NSArray *arrColors = [NSArray arrayWithObjects:@"黑桃", @"红心", @"草花", @"方块",@" 小王", @" 大王", nil];
    NSString *currColor = [arrColors objectAtIndex:color];    
    
    return currColor;
}

- (NSString *)getValue:(int)random
{
    int value = [self getValueInteger:random];    
    
    NSArray *arrValues = [NSArray arrayWithObjects:@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K",@"", nil];
    NSString *currValue = [arrValues objectAtIndex:value];
        
    return currValue;
}

- (NSUInteger)calcSpadeCount
{
    int count = 0;
    int color = 0;
    
    for (int i=0;i<[arrayRandoms count] && i<rounds;i++) {
        NSNumber *number = [arrayRandoms objectAtIndex:i];
        color = [self getColorInteger:[number intValue]];
        if (color==0) {
            count++;
        }
    }
    
    return count;
}
- (NSUInteger)calcHeartCount
{
    int count = 0;
    int color = 0;
    
    for (int i=0;i<[arrayRandoms count] && i<rounds;i++) {
        NSNumber *number = [arrayRandoms objectAtIndex:i];
        color = [self getColorInteger:[number intValue]];
        if (color==1) {
            count++;
        }
    }
    
    return count;
}

- (NSUInteger)calcClubeCount
{
    int count = 0;
    int color = 0;
    
    for (int i=0;i<[arrayRandoms count] && i<rounds;i++) {
        NSNumber *number = [arrayRandoms objectAtIndex:i];
        color = [self getColorInteger:[number intValue]];
        if (color==2) {
            count++;
        }
    }
    
    return count;
}

- (NSUInteger)calcDiamondCount
{
    int count = 0;
    int color = 0;
    
    for (int i=0;i<[arrayRandoms count] && i<rounds;i++) {
        NSNumber *number = [arrayRandoms objectAtIndex:i];
        color = [self getColorInteger:[number intValue]];
        if (color==3) {
            count++;
        }
    }
    
    return count;
}

- (NSUInteger)calcJokerCount
{
    int count = 0;
    int color = 0;
    
    for (int i=0;i<[arrayRandoms count] && i<rounds;i++) {
        NSNumber *number = [arrayRandoms objectAtIndex:i];
        color = [self getColorInteger:[number intValue]];
        if (color==4 || color==5) {
            count++;
        }
    }
    
    return count;
}

- (void)autosave
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithInt:money] forKey:@"UserMoney"];
    [ud setObject:arrayRandoms forKey:@"UserSavedCards"];
    [ud setObject:[NSNumber numberWithInt:plays] forKey:@"UserPlays"];
    [ud setObject:[NSNumber numberWithInt:rounds] forKey:@"UserRounds"];
    [ud setObject:[NSNumber numberWithInt:credit] forKey:@"UserCredit"];
    [ud setObject:[NSNumber numberWithInt:topScore] forKey:@"UserTopScore"];
    [ud setObject:[NSNumber numberWithInt:exp] forKey:@"UserExp"];
    [ud synchronize];
}


@end
