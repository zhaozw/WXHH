//
//  WXHHUtil.m
//  WXHH
//
//  Created by Chen Weigang on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WXHHUtil.h"

BOOL isParticleSupported(void)
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >=5.0) {
        if (NSClassFromString(@"CAEmitterLayer") && NSClassFromString(@"CAEmitterCell"))
        {
            return YES;
        }
    }
    
    return NO;
}
