//
//  Model.h
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString *KEY_USER_NAME ;
NSString *KEY_PLAYER_MONEY;
NSString *KEY_CURRENT_CARDS;
NSString *KEY_CURRENT_CARD_INDEX;

typedef enum {
    RateType_5,
    RateType_10,
    RateType_100,
}RateType;


@interface ModelWXHH : NSObject

@property (nonatomic, retain) NSMutableArray *arrayRandoms;
@property (nonatomic, retain) NSMutableDictionary *dictPlayerInfo;

@property (nonatomic, assign) int money;
@property (nonatomic, assign) int credit;
@property (nonatomic, assign) RateType rate;
@property (nonatomic, assign) int plays; // 局
@property (nonatomic, assign) int rounds; // 轮

@property (nonatomic, assign) int betSpade;
@property (nonatomic, assign) int betHeart;
@property (nonatomic, assign) int betClub;
@property (nonatomic, assign) int betDiamond;
@property (nonatomic, assign) int betKing;

@property (nonatomic, assign) int winMoney;


@property (nonatomic, assign) NSMutableArray *arrGoOns;
@property (nonatomic, assign) BOOL enableSound;

@property (nonatomic, assign) int topScore; // 最高分


/*
 Exp & Lv
 10	20	40	60	80	100		200	300	400  500
 1	2	3	4	5	6		7	8	9	10
 1，16，81，256，625，1296，2401，4096，10000，20736，38416，
 65536，104976，160000，
 exp = 2500/10
 */

@property (nonatomic, assign) int exp; // 经验值

/*
 Bet Level 0-7
 赌徒，赌鬼，赌棍，赌霸，   赌侠，     赌王，     赌圣，     赌神
 600 1200  2400  4800	10000      25000	 50000              // 升级所需钱
 50  100   200   400	800        1500      2500      5000     // 该等级
 */
@property (nonatomic, assign) int betLv;// 押注等级


+ (NSString *)getBetLevelTitle;
+ (int)getLevelUpExp:(int)lv;
+ (int)getTopScoreLevelUpExp;
+ (int)calcBetLevel;
+ (int)getBetValueMax;
+ (int)getCurrentExpMax;
+ (int)getCurrentLv;
+ (int)getFreeMoney;

+ (ModelWXHH *)sharedInstance;
- (void)resetCards;
- (NSString *)getColor:(int)random;
- (NSString *)getValue:(int)random;
- (NSString *)getImageName:(int)random;

- (NSUInteger)calcSpadeCount;
- (NSUInteger)calcHeartCount;
- (NSUInteger)calcClubeCount;
- (NSUInteger)calcDiamondCount;
- (NSUInteger)calcJokerCount;

- (int)getColorInteger:(int)random;
- (int)getValueInteger:(int)random;

- (int)calcWinScorecardRandom:(NSUInteger)r S:(NSUInteger)s H:(NSUInteger)h C:(NSUInteger)c D:(NSUInteger)d K:(NSUInteger)k;

- (void)autosave;

+ (NSString *)getBetLevelTitle;
+ (int)getLevelUpExp:(int)lv;
+ (int)getCurrentExpMax;

@end
