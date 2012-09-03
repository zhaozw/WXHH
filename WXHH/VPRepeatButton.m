//
//  VPRepeatButton.m
//  LongPressButtonDemo
//
//  Created by Chen Weigang on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VPRepeatButton.h"

@implementation VPRepeatButton
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(pressDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchDragOutside];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code                
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(pressDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchDragOutside];
        
    }
    return self;
}

- (void)repeatEvent
{
    if (delegate!=nil && [delegate respondsToSelector:@selector(repeatButtonDidTouchRepeat:)]) {
        [delegate repeatButtonDidTouchRepeat:self];
    }           
}

- (void)pressDown
{
    if (!toggle) {        
        toggle = YES;
        
        [timerRepeat invalidate];
        [timerRepeat release], timerRepeat = nil;
        
        if (delegate!=nil && [delegate respondsToSelector:@selector(repeatButtonDidTouchDown:)]) {
            [delegate repeatButtonDidTouchDown:self];
        }
        
        timerRepeat = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(repeatEvent) userInfo:nil repeats:YES] retain];
    }    
}

- (void)pressUp
{
    if (toggle) {        
        toggle = NO;
        [timerRepeat invalidate];
        [timerRepeat release], timerRepeat = nil;
        
        if (delegate!=nil && [delegate respondsToSelector:@selector(repeatButtonDidTouchUp:)]) {
            [delegate repeatButtonDidTouchUp:self];
        }
    }
}


@end
