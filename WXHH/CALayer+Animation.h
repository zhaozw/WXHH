//
//  CALayer+Animation.h
//  Earthquake
//
//  Created by Chen Weigang on 12-3-14.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum {
	LayerAnimationTypeFade = 0,
	LayerAnimationTypePush,
	LayerAnimationTypeMoveIn,
	LayerAnimationTypeReveal,
	LayerAnimationTypePageCurl,
	LayerAnimationTypePageUnCurl,
	LayerAnimationTypeRippleEffect,
	LayerAnimationTypeSuckEffect,
	LayerAnimationTypeCube,
	LayerAnimationTypeOglFlip
}LayerAnimationType;

typedef enum {
	LayerAnimationDirectionTypeLeft = 0,
	LayerAnimationDirectionTypeRight = 1,
	LayerAnimationDirectionTypeTop = 2,
	LayerAnimationDirectionTypeBottom = 3,
}LayerAnimationDirectionType;


@interface CALayer(Animation)

- (void)transitionFade;
- (void)transitionMoveInByDirection:(LayerAnimationDirectionType)dir;
- (void)transitionPushByDirection:(LayerAnimationDirectionType)dir;
- (void)transitionRevealByDirection:(LayerAnimationDirectionType)dir;

- (void)transitionPageCurlByDirection:(LayerAnimationDirectionType)dir;
- (void)transitionPageUnCurlByDirection:(LayerAnimationDirectionType)dir;
- (void)transitionRippleEffect;
- (void)transitionSuckEffect;
- (void)transitionCubeByDirection:(LayerAnimationDirectionType)dir;
- (void)transitionOglFlipByDirection:(LayerAnimationDirectionType)dir;

- (void)transitionRandom;

@end
