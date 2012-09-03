//
//  VPRepeatButton.h
//  LongPressButtonDemo
//
//  Created by Chen Weigang on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VPRepeatButtonDelegate;


@interface VPRepeatButton : UIButton {

    NSTimer *timerRepeat;
    BOOL toggle;
}
@property (nonatomic,  assign) id<VPRepeatButtonDelegate> delegate;

@end



@protocol VPRepeatButtonDelegate <NSObject>

- (void)repeatButtonDidTouchDown:(VPRepeatButton *)button;
- (void)repeatButtonDidTouchUp:(VPRepeatButton *)button;
- (void)repeatButtonDidTouchRepeat:(VPRepeatButton *)button;

@end