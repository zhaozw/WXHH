//
//  CashCountView.m
//  PagingDemo
//
//  Created by Chen Weigang on 12-3-8.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "CashCountView.h"
#import "Cash.h"
#import "Model.h"

int CASH_COUNT = 0;
CGPoint pTouchDown;

@implementation CashCountView
@synthesize indexCash;
@synthesize delegate;

static bool isTouchDown = NO;

- (int)getTotalValue;
{
    return totalCash;
}

- (id)initWithFrame:(CGRect)frame number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        CASH_COUNT = number;
        arrCashs = [[NSMutableArray alloc] initWithCapacity:CASH_COUNT];        
        indexCash = CASH_COUNT-1; // 從最後一張開始
        
        totalCash = 0;
        
        for (int i=0; i<CASH_COUNT; i++) {
            Cash *cash = [[Cash alloc] initWithOrigin:CGPointMake(20+i/2, 20) CashType:i%4];
            totalCash += cash.value;
            cash.tag = i;           
            [self addSubview:cash];
            [arrCashs addObject:cash];
            [cash release];
        }
        
        btnTouch = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        btnTouch.frame = frame;
        [btnTouch addTarget:self action:@selector(touchDown:event:) forControlEvents:UIControlEventTouchDown];
        [btnTouch addTarget:self action:@selector(drag:event:) forControlEvents:UIControlEventTouchDragInside];
        [btnTouch addTarget:self action:@selector(drag:event:) forControlEvents:UIControlEventTouchDragOutside];
        [btnTouch addTarget:self action:@selector(touchUp:event:) forControlEvents:UIControlEventTouchUpInside];
        [btnTouch addTarget:self action:@selector(touchUp:event:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:btnTouch];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc { 
    [btnTouch release];
    [arrCashs release];
    [super dealloc];
}

- (void)reset
{    
    self.hidden = YES;
    totalCash = 0;
    for (Cash *cash in arrCashs) {      
        
        [cash cash0];
        [self bringSubviewToFront:cash];
        totalCash += cash.value;
    }
    indexCash = CASH_COUNT-1;
    self.hidden = NO;
}

- (void)touchDown:(id)sender event:(UIEvent *)event
{    
    if (indexCash>=0 && indexCash<[arrCashs count]) {
        Cash *cash = [arrCashs objectAtIndex:indexCash];
        [cash pickup];    
        isTouchDown = YES;
        UIButton *btn = sender;
        NSSet *touches = [event touchesForView:btn];
        UITouch *touch = [touches anyObject];
        pTouchDown = [touch locationInView:btn];
    }
}

- (void)drag:(id)sender event:(UIEvent *)event
{
    UIButton *btn = sender;
    NSSet *touches = [event touchesForView:btn];
    UITouch *touch = [touches anyObject];
    
    NSLog(@"x = %f y = %f", [touch locationInView:btn].x, [touch locationInView:btn].y);
    CGPoint pTouch = [touch locationInView:btn];
    
    if (pTouchDown.x!=-1 && pTouchDown.y!=-1 && isTouchDown && ABS(pTouchDown.x-pTouch.x) > 80 &&  ABS(pTouchDown.x-pTouch.x) > ABS(pTouchDown.y-pTouch.y)+30) {        
        [delegate cashCountDidStop];
    }
    else {
        
        if (isTouchDown && pTouch.y-pTouchDown.y>80) {
            if (indexCash>=0  && indexCash<[arrCashs count]) {
                Cash *cash = [arrCashs objectAtIndex:indexCash];
                [cash page];
                indexCash--;
                isTouchDown = NO;        
                
                [delegate cashCountFrameDidEnd];
                if (indexCash<0) {
                    [delegate cashCountDidEnd];
                    //                [self performSelector:@selector(delegateCashCountEnd) withObject:nil afterDelay:2.5f];
                }
            }    
        }    
    }


}

- (void)touchUp:(id)sender event:(UIEvent *)event
{
    if (indexCash>=0  && indexCash<[arrCashs count]) {
        Cash *cash = [arrCashs objectAtIndex:indexCash];
        [cash putdown];   
        pTouchDown.x = -1;
        pTouchDown.y = -1;
    }    
}

- (void)delegateCashCountEnd
{    
    [delegate cashCountDidEnd];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
