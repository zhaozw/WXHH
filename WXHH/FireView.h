//
//  FireView.h
//  WXHH
//
//  Created by Chen Weigang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CAEmitterLayer;
@class CAEmitterCell;

@interface FireView : UIView {
    NSTimer *timer;
    double amount;
}

@property (strong) CAEmitterLayer *fireEmitter;
@property (strong) CAEmitterLayer *smokeEmitter;

- (void) setFireAmount:(float)zeroToOne;

@end
