//
//  VPFadeMessageView.m
//  FadeMessageViewDemo
//
//  Created by Chen Weigang on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VPFadeMessageView.h"


@interface VPFadeMessageView : UIView {
    UITextView *tvMessage;
}

- (void)setMessage:(NSString *)text;

@end

void showFadeMessageView(UIView *parentView, NSString *text)
{        
    VPFadeMessageView *fv = [[VPFadeMessageView alloc] initWithFrame:CGRectMake(0, 0, 210, 50)];

    [fv setMessage:text];
    fv.center = parentView.center;
    
    fv.alpha = 0.f;
    [parentView addSubview:fv];
    
    [UIView animateWithDuration:0.5f 
                     animations:^{
                         fv.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f delay:0.8f 
                                             options:UIViewAnimationOptionCurveEaseInOut 
                                          animations:^{
                                              fv.alpha = 0.f;
                                          } completion:^(BOOL finished) {
                                              fv.alpha = 1.f;
                                              [fv removeFromSuperview];
                                              [fv release];
                                          }];
                     }];

    

}

# pragma mark VPFadeMessageView

@implementation VPFadeMessageView

- (void)dealloc
{
    [tvMessage release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tvMessage = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 210, 50)];
        [self addSubview:tvMessage];
        tvMessage.editable = NO;
        tvMessage.backgroundColor = [UIColor clearColor];
        tvMessage.textColor = [UIColor whiteColor];
        tvMessage.textAlignment = UITextAlignmentCenter;
        tvMessage.font = [tvMessage.font fontWithSize:18];
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]; 
        self.layer.cornerRadius = 5.f;
        self.layer.borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor;
        self.layer.borderWidth = 2.f;
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setMessage:(NSString *)text
{
    tvMessage.text = text;
    
    CGSize size = tvMessage.contentSize;
    CGRect frame = tvMessage.frame;
    frame.size = size;
    tvMessage.frame = frame;
    frame = self.frame;
    frame.size = size;
    self.frame = frame;
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
