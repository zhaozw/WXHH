//
//  Cash.m
//  PagingDemo
//
//  Created by Chen Weigang on 12-3-8.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "Cash.h"
#import "CashCountView.h"
#import "Model.h"

#define PAGE_SPEED_SCALE 1.f

BOOL isRateHit(int rate);

BOOL isRateHit(int rate)                                        
{
    
    int num = abs(arc4random())%100;
    
    NSLog(@"isRateHit = %@", num <= rate ?@"YES":@"NO");
    return num <= rate;
}

@interface Cash()
- (NSString *)getImageNameByPage:(int)p;
- (void)cash0;
@end

@implementation Cash
@synthesize type;
@synthesize value;


- (void)resetType
{
    Model *model = [Model sharedModel];
    int level = model.level;
    
    if (level==0) {
        BOOL is10$ = isRateHit(85);
        if (is10$) {
            type = 3;
        }
        else{
            type = 2;
        }        
    }
    else if (level==1) {
        BOOL is10$ = isRateHit(50);
        if (is10$) {
            type = 3;
        }
        else{
            BOOL is20$ = isRateHit(70);
            if (is20$) {
                type = 2;
            }    
            else{
                type = 1;            
            }
        }  
    }
    else if (level==2) {
        BOOL is10$ = isRateHit(25);
        if (is10$) {
            type = 3;
        }
        else{
            BOOL is20$ = isRateHit(50);
            if (is20$) {
                type = 2;
            }    
            else{
                BOOL is50$ = isRateHit(70);
                if (is50$) {
                    type = 1;
                }    
                else{
                    type = 0;
                }            
            }
        }
    }
    else if (level==3) {
        BOOL is10$ = isRateHit(25);
        if (is10$) {
            type = 3;
        }
        else{
            BOOL is20$ = isRateHit(50);
            if (is20$) {
                type = 2;
            }    
            else{
                BOOL is50$ = isRateHit(50);
                if (is50$) {
                    type = 1;
                }    
                else{
                    type = 0;
                }            
            }
        }
    }
    
    
    [self changeCash:0];
    
//    if (imgFake==nil) {
//        imgFake = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fake.png"]];
//        [self addSubview:imgFake];
//    }
    
//    isFake = isRateHit(28);
//    if (isFake) {
//        imgFake.hidden = YES;
//    }
//    else{
//        imgFake.hidden = YES;
//    }
    
//    if (isFake) {
//        value = 0;
//    }
//    else{
        int values[4] = {100, 50, 20, 10};
        value = values[type];
//    }
}

- (id)initWithOrigin:(CGPoint)origin CashType:(CashType)t 
{        
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, 320, 480)];

    if (self) {
        type = t;
        page = 0;
        [self resetType];
        [self cash0];
    }
    
    return self;
}

- (NSString *)getImageNameByPage:(int)p
{
    NSArray *names = [NSArray arrayWithObjects:@"usd100", @"usd50", @"usd20", @"usd10", nil];  
//    if (p==0) {        
//        return [NSString stringWithFormat:@"usd-%d-us-dollars-2.jpg", [names objectAtIndex:type]];
//    }
//    else{  
    
    return [NSString stringWithFormat:@"usd100_%d.png", p];   
//        return [NSString stringWithFormat:@"%@_%d.png", [names objectAtIndex:type], p];    
//    }
}

# pragma mark - animation

- (void)changeCash:(int)index
{    
    page = index;
    int lastImageHeight = self.image.size.height;
    UIImage *image = [UIImage imageNamed:[self getImageNameByPage:page]];  
    self.image = image;
//    int oy[6] = {20, 0, 50, 120, 240, 320};
    self.frame = CGRectMake(self.frame.origin.x, 
//                            oy[0]+oy[page],
                            page==0 ? 20 : self.frame.origin.y - image.size.height + lastImageHeight, 
                            image.size.width, 
                            image.size.height);
}

- (void)cash0
{
    [self changeCash:0];
}

- (void)cash1
{
    [self changeCash:1];
}

- (void)cash2
{
    [self changeCash:2];
}

- (void)cash3
{
    [self changeCash:3];
}

- (void)cash4
{
    [self changeCash:4];    
}

- (void)cash5
{    
    [self.superview bringSubviewToFront:self];
    [self changeCash:5];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)cash6
{
    [self changeCash:6];
}


- (void)cash7
{
    page = 7;
    self.image = nil;
    
}


// 掀開後往下拖拽 放連續動畫
- (void)page
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.userInteractionEnabled = NO;
    
    int scale = PAGE_SPEED_SCALE;
    [self performSelector:@selector(cash2) withObject:nil afterDelay:0.075f*scale];
    [self performSelector:@selector(cash3) withObject:nil afterDelay:0.15f*scale];
    [self performSelector:@selector(cash4) withObject:nil afterDelay:0.225f*scale];
    [self performSelector:@selector(cash5) withObject:nil afterDelay:0.3f*scale];
    [self performSelector:@selector(cash6) withObject:nil afterDelay:0.35f*scale];
    [self performSelector:@selector(cash7) withObject:nil afterDelay:0.4f*scale];
}

// 掀開一個角
- (void)pickup
{    
    int scale = PAGE_SPEED_SCALE;
    [self performSelector:@selector(cash1) withObject:nil afterDelay:0.035f*scale];
    [self performSelector:@selector(cash2) withObject:nil afterDelay:0.075f*scale];
  
}

// 掀開後，又放下了
- (void)putdown
{
    int scale = PAGE_SPEED_SCALE;
    [self performSelector:@selector(cash1) withObject:nil afterDelay:0.035f*scale];
    [self performSelector:@selector(cash0) withObject:nil afterDelay:0.075f*scale];
}


@end
