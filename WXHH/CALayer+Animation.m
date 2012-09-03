//
//  CALayer+Animation.m
//  Earthquake
//
//  Created by Chen Weigang on 12-3-14.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "CALayer+Animation.h"

static NSString *STRING_ANIMATION_TYPE[] = {	
	@"fade",
	@"moveIn",
	@"push",
	@"reveal",
	@"pageCurl",
	@"pageUnCurl",
	@"rippleEffect",
	@"suckEffect",
	@"cube",
	@"oglFlip"
};

static NSString *STRING_DIRECTION_TYPE[] = {
	@"fromTop",
	@"fromBottom",
	@"fromLeft",
	@"fromRight"	
};

@implementation CALayer(Animation)

#pragma mark -
#pragma mark =============CAAnimation Basic===============

- (void)transitionFade {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"fade";  
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"fade"];
}


- (void)transitionMoveInByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"moveIn";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.3];
	[self addAnimation:transition forKey:@"moveIn"];
}


- (void)transitionPushByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"push";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[transition setDuration:0.3];
	[self addAnimation:transition forKey:@"push"];
}


- (void)transitionRevealByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"reveal";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"reveal"];
}


#pragma mark -
#pragma mark =============CAAnimation Extension===========

- (void)transitionPageCurlByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"pageCurl";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"pageCurl"];
}


- (void)transitionPageUnCurlByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"pageUnCurl";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"pageUnCurl"];
}


- (void)transitionRippleEffect {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"rippleEffect";  
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.4];
	[self addAnimation:transition forKey:@"rippleEffect"];
}


- (void)transitionSuckEffect {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"suckEffect";  
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"suckEffect"];
}


- (void)transitionCubeByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"cube";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.4];
	[self addAnimation:transition forKey:@"cube"];
}


- (void)transitionOglFlipByDirection:(LayerAnimationDirectionType)dir {
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"oglFlip";  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 1.0;   
	transition.startProgress = 0.0;
	[transition setDuration:0.8];
	[self addAnimation:transition forKey:@"oglFlip"];
}



#pragma mark -
#pragma mark =============CAAnimation Custom===============

- (void)transitionRandom {
	int animTypes = (sizeof STRING_ANIMATION_TYPE) / (sizeof STRING_ANIMATION_TYPE[0]);
	int dirTypes = (sizeof STRING_DIRECTION_TYPE) / (sizeof STRING_DIRECTION_TYPE[0]);
	int type = random() % animTypes;
	int dir = random() % dirTypes;	
	
	CATransition *transition = [CATransition animation];
	transition.delegate = self;
	transition.type = @"push";///STRING_ANIMATION_TYPE[type];  
	transition.subtype = STRING_DIRECTION_TYPE[dir];
	transition.endProgress = 0.99;   
	transition.startProgress = 0.0;
	[transition setDuration:0.2];
	[self addAnimation:transition forKey:STRING_ANIMATION_TYPE[type]];
}

- (void)rotation {
	// rotation
	CATransform3D rotationTransform = CATransform3DMakeRotation(-3.14, 0, 0, 1.0);		
	rotationTransform = CATransform3DInvert(rotationTransform); // 反
	
	CABasicAnimation* rotationAnimation;
	rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	
	rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
	rotationAnimation.duration = 1.0f;
	rotationAnimation.cumulative = YES;// 結束位置上繼續旋轉
	rotationAnimation.repeatCount = HUGE_VALF; 	
	
	self.anchorPoint = CGPointMake(0, 0);
	[self addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


/*
 - (void)rotationAnimation:(UIView *)__view {  // <label id="code.GroupAnimationView.rotationAnimation:"/>
 CALayer *layer=[__view layer];
 CABasicAnimation *rotation =
 [CABasicAnimation animationWithKeyPath:@"frameRotation"];
 rotation.fromValue = [NSNumber numberWithFloat:0.0f];
 rotation.toValue = [NSNumber numberWithFloat:45.0f];
 [layer addAnimation:rotation forKey:@"rotation"];
 }
 
 
 -(void)animation_3DRotate__:(UIView *)view duration:(int)duration
 {
 CALayer *layer = [view layer];
 CABasicAnimation *flipAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
 flipAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 flipAnimation.delegate=self;
 flipAnimation.duration=duration;
 //flipAnimation.repeatCount=1000000;
 flipAnimation.byValue=[NSNumber numberWithFloat:M_PI*2]; 
 flipAnimation.removedOnCompletion=YES;
 [layer addAnimation:flipAnimation forKey:@"flip"];
 }
 */


#pragma mark -
#pragma mark  =============Animation Delegate==============

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];	
	NSLog(@"animation stop~~");
}

- (void)animationDidStart:(CAAnimation *)anim {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	NSLog(@"animation start~~");
}

@end
