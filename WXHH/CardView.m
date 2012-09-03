//
//  CardView.m
//  WXHH
//
//  Created by Chen Weigang on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"
#import "ModelWXHH.h"
#import "AppDelegate.h"

@implementation CardView
@synthesize showCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
//        lab.font = [UIFont fontWithName:@"TpldKhangXiDict" size:16];
//        [self addSubview:lab];
//        lab.text = @"你好";
        showCount = 0;
    }
    return self;
}




- (BOOL)isBlackColor:(int)random
{
    if ((random-2)/13==1 || (random-2)/13==3) {
        return NO;
    }
    return YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    ModelWXHH *model = [ModelWXHH sharedInstance];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    // draw line;
    
    // Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	// Draw a single line from left to right
    
    for (int i=0; i<10; i++) {
        CGContextMoveToPoint(context, 0.0, i*15);
        CGContextAddLineToPoint(context, self.frame.size.width, i*15);
        CGContextStrokePath(context);
    }
    

    for (int i=0; i<6; i++) {
        CGContextMoveToPoint(context, 33*i, 0);
        CGContextAddLineToPoint(context, 33*i, self.frame.size.height);
        CGContextStrokePath(context);
    }
    
    
    
    NSMutableArray *cards = [ModelWXHH sharedInstance].arrayRandoms;
    for (int i=0; i<showCount; i++) {
        int randomValue = [[cards objectAtIndex:i] intValue];
        NSString *color = [model getColor:randomValue];
        NSString *value = [model getValue:randomValue];
        
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
        
        if ([self isBlackColor:randomValue]) {
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        }
        else{
            CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);        
        }
        
        [color drawAtPoint:CGPointMake(2+i%6*33, i/6*15+1) withFont:font];
        if ([value isEqualToString:@"10"]) {            
            [value drawAtPoint:CGPointMake(2+i%6*33+19, i/6*15+1+1) withFont:font];
        }
        else {
            [value drawAtPoint:CGPointMake(2+i%6*33+22, i/6*15+1+1) withFont:font];            
        }
    }
    
    
    UIGraphicsPopContext();	
}


@end
