//
//  HelpViewController.h
//  WXHH
//
//  Created by Chen Weigang on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


BOOL isHelpVCPresent;

@interface HelpViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *sv;
    IBOutlet UIPageControl *pc;
}



@end
