//
//  FireView.m
//  WXHH
//
//  Created by Chen Weigang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FireView.h"

@implementation FireView
@synthesize fireEmitter;
@synthesize smokeEmitter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (NSClassFromString(@"CAEmitterLayer") && NSClassFromString(@"CAEmitterCell"))
        {
            [self initFire];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (NSClassFromString(@"CAEmitterLayer") && NSClassFromString(@"CAEmitterCell"))
        {
            [self initFire];
        
        }
    }
    return self;
}

- (void)initFire
{
	// Create the emitter layers
	self.fireEmitter	= [CAEmitterLayer layer];
	self.smokeEmitter	= [CAEmitterLayer layer];
	
	// Place layers just above the tab bar
	CGRect viewBounds = self.bounds;
	self.fireEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height/2);
	self.fireEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2, 0);
	self.fireEmitter.emitterMode	= kCAEmitterLayerOutline;
	self.fireEmitter.emitterShape	= kCAEmitterLayerLine;
	// with additive rendering the dense cell distribution will create "hot" areas
	self.fireEmitter.renderMode		= kCAEmitterLayerAdditive;
	
	self.smokeEmitter.emitterPosition = CGPointMake(viewBounds.size.width, viewBounds.size.height/2);
	self.smokeEmitter.emitterMode	= kCAEmitterLayerPoints;
	
	// Create the fire emitter cell
	CAEmitterCell* fire = [CAEmitterCell emitterCell];
	[fire setName:@"fire"];
    
	fire.birthRate			= 1;
	fire.emissionLongitude  = M_PI;
	fire.velocity			= -80;
	fire.velocityRange		= 30;
	fire.emissionRange		= 1.1;
	fire.yAcceleration		= -200;
	fire.scaleSpeed			= 0.3;
	fire.lifetime			= 50;
	fire.lifetimeRange		= (50.0 * 0.35);
    
	fire.color = [[UIColor colorWithRed:0.95 green:0.35 blue:0.15 alpha:0.1] CGColor];
	fire.contents = (id) [[UIImage imageNamed:@"DazFire"] CGImage];
	

    
	// Create the smoke emitter cell
	CAEmitterCell* smoke = [CAEmitterCell emitterCell];
	[smoke setName:@"smoke"];
    
	smoke.birthRate			= 11;
	smoke.emissionLongitude = -M_PI / 2;
	smoke.lifetime			= 3;
	smoke.velocity			= -40;
	smoke.velocityRange		= 20;
	smoke.emissionRange		= M_PI / 4;
	smoke.spin				= 1;
	smoke.spinRange			= 6;
	smoke.yAcceleration		= -160;
	smoke.contents			= (id) [[UIImage imageNamed:@"DazSmoke"] CGImage];
	smoke.scale				= 0.1;
	smoke.alphaSpeed		= -0.12;
	smoke.scaleSpeed		= 0.7;
	
	
	// Add the smoke emitter cell to the smoke emitter layer
	self.smokeEmitter.emitterCells	= [NSArray arrayWithObject:smoke];
	self.fireEmitter.emitterCells	= [NSArray arrayWithObject:fire];
	[self.layer addSublayer:self.smokeEmitter];
	[self.layer addSublayer:self.fireEmitter];

	amount = 0.03f;
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timer) userInfo:nil repeats:YES] retain];
}

- (void)timer
{
    if (amount<1.f) {
        amount += 0.04f;
        [self setFireAmount:amount];
//        NSLog(@"amount = %f", amount);
    }
    else {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void) setFireAmount:(float)zeroToOne
{
	// Update the fire properties
	[self.fireEmitter setValue:[NSNumber numberWithInt:(zeroToOne * 800)]
					forKeyPath:@"emitterCells.fire.birthRate"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:zeroToOne*0.45]
					forKeyPath:@"emitterCells.fire.lifetime"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:(zeroToOne * 0.5)]
					forKeyPath:@"emitterCells.fire.lifetimeRange"];
	self.fireEmitter.emitterSize = CGSizeMake(120 * zeroToOne, 0);
	
	[self.smokeEmitter setValue:[NSNumber numberWithInt:zeroToOne * 0.3]
					 forKeyPath:@"emitterCells.smoke.lifetime"];
	[self.smokeEmitter setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:zeroToOne * 0.1] CGColor]
					 forKeyPath:@"emitterCells.smoke.color"];
}

- (void)dealloc
{
    [timer invalidate];
    [timer release];
    timer = nil;
    
    
    [self.fireEmitter removeFromSuperlayer];
	self.fireEmitter = nil;
	[self.smokeEmitter removeFromSuperlayer];
	self.smokeEmitter = nil;
    
    
    
    [super dealloc];
}


@end
